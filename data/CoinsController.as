package data
{
	import caurina.transitions.Tweener;
	import event.GameEvent;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.callbacks.OptionType;
	import nape.phys.Body;
	import sound.SoundManager;
	import sound.SoundRes;
	import units.States;
	import utils.Analytics;
	import utils.BitmapClip;
	import utils.TextBox;
	import view.Game;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class CoinsController
	{
		private var _data:Model;
		private var _game:Game;
		
		private var _costs:Vector.<TextBox> = new Vector.<TextBox>();
		
		public function CoinsController(game:Game)
		{
			_data = Controller.model;
			_game = game;
			
			init();
		}
		
		private function init():void
		{
			//for each (var body:Body in _data.coins)
			//{
			//Controller.juggler.add(body.userData.view);
			//}
			
			playAnimationCoin();
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_COIN, new OptionType([Model.BODY_HERO_CENTER, Model.BODY_HERO_BASE]), toCoinGetHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_COIN, Model.BODY_HERO_RADAR, toCoinFindHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_LOGO, Model.BODY_HERO_RADAR, toCoinFindHandler));
		}
		
		private function playAnimationCoin():void
		{
			if (_data.coins.length == 0)
				return;
			
			const delayNextPlay:int = int(Math.random() * 60) + 30;
			
			const index:uint = uint(Math.random() * _data.coins.length);
			if (_data.coins[index].userData.view.visible) //coz hidden most part of time
				(_data.coins[index].userData.view as BitmapClip).play();
			
			Controller.juggler.addCall(playAnimationCoin, delayNextPlay / 60);
		}
		
		private function toCoinGetHandler(cb:InteractionCallback):void
		{
			if (cb.int2.castShape.body != _data.hero.base && _data.hero.topShape.sensorEnabled)
				return;
			
			if (_data.hero.states.currentState == States.DEATH_0)
				return;
			
			const coinBody:Body = cb.int1.castBody;
			const bitmap:Bitmap = coinBody.userData.view as Bitmap;
			const coinType:int = (coinBody.userData.type - ImageRes.COIN_0) * 2 + AnimationRes.COINS_0 + 1;
			
			const animation:BitmapClip = new BitmapClip(new <uint>[coinType], new <Array>[null], new Rectangle(0, 0, 64, 64));
			animation.play(coinType, false);
			animation.x = bitmap.x - 16;
			animation.y = bitmap.y - 32;
			
			_game.levelLayer.addChild(animation);
			animation.addEventListener(Event.COMPLETE, completeHandler);
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_GET_GEM);
			
			//addEffectGetting(bitmap);
			
			//_costs[int(bitmap.name)].visible = false;
			//trace("check length",_costs.length);
			costUp(_costs[int(bitmap.name)]);
			_data.progress.moneyAtLevel += Behavior.coinCosts[coinBody.userData.type - ImageRes.COIN_0];
			_game.dispatchEvent(new GameEvent(GameEvent.CHANGE_CAPACITY, true));
			
			bitmap.parent.removeChild(bitmap);
			coinBody.userData.view = null;
			coinBody.space = null;
			
			const index:uint = _data.coins.indexOf(coinBody);
			_data.coins.splice(index, 1);
			
			Analytics.pushPage(Analytics.GET_TREASURE,(coinBody.userData.type - ImageRes.COIN_0).toString());
			AchievementController.getInstance().addParam(AchievementController.GETTING_GOLD);
		}
		
		private function costUp(tf:TextBox):void
		{
			tf.parent.addChild(tf);
			Tweener.addTween(tf, {scaleX: 2, scaleY: 2, y: (tf.y - 20), time: 0.5, transition: "easeInQuart", onComplete: costDown, onCompleteParams: [tf]});
		}
		
		private function costDown(tf:TextBox):void
		{
			Tweener.addTween(tf, {scaleX: 1.2, scaleY: 1.2, alpha: 0, time: 0.4, transition: "easeOutQuart", onComplete: costDown, onCompleteParams: [tf]});
		}
		
		private function costHide(tf:TextBox):void
		{
			tf.visible = false;
		}
		
		private function completeHandler(e:Event):void
		{
			const bitmap:BitmapClip = e.currentTarget as BitmapClip;
			
			bitmap.removeEventListener(Event.COMPLETE, completeHandler);
			_game.levelLayer.removeChild(bitmap);
		}
		
		private function toCoinFindHandler(cb:InteractionCallback):void
		{
			//if (cb.int2.castShape.body != _data.hero.base && _data.hero.topShape.sensorEnabled)//creep
				//return;
			
			if (_data.hero.states.currentState == States.DEATH_0)
				return;
			
			const bitmap:Bitmap = cb.int1.castBody.userData.view as Bitmap;
			if (bitmap.visible)
				return;
			
			if (_data.progress.currentBattery == 0)
			{
				//_game.addChild(new Reminder("need more battery!!!", Reminder.GET_UP, 2));
				return
			}
			
			if (cb.int2.castShape.userData.radarType == 1 || cb.int2.castShape.userData.radarType == 5)
				AchievementController.getInstance().addParam(AchievementController.FIND_GOLD_RADAR_TOP);
			
			//trace("radar type", cb.int2.castShape.userData.radarType);
			
			bitmap.visible = true;
			showCost(bitmap, cb.int1.castBody.userData.type);
			
			if (_data.progress.currentBattery > 0)
			{
				_data.progress.currentBattery--;
				_data.hero.dispatchEvent(new GameEvent(GameEvent.CHANGE_CAPACITY, true));
					//_game.addChild(new Reminder("battery: " + _data.progress.currentBattery, Reminder.GET_UP, 2));
			}
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_NO_TNT);
		}
		
		private function showCost(bitmap:Bitmap, type:int):void
		{
			if (type == ImageRes.LOGO_BODY)
				return;
			
			var cost:TextBox;
			for each (var item:TextBox in _costs)
			{
				if (!item.visible)
				{
					cost = item;
					break;
				}
			}
			if (!cost)
			{
				cost = new TextBox(30, 10, 10, 0xFEFF00, "", Behavior.coinCosts[type - ImageRes.COIN_0].toString(), "left", true, false, [new DropShadowFilter(0, 0, 0x353535, 1, 2, 2, 20, 2)]);
				_costs.push(cost);
			}
			
			bitmap.parent.addChild(cost);
			cost.x = bitmap.x + 20;
			cost.y = bitmap.y - 3;
			bitmap.name = _costs.indexOf(cost).toString();
			cost.scaleX = cost.scaleY = 1;
			cost.alpha = 1;
			cost.visible = true;
		}
		
		public function destroy():void
		{
			//for each (var body:Body in _data.coins)
			//{
			//Controller.juggler.remove(body.userData.view);
			//}
			Controller.juggler.removeCall(playAnimationCoin);
			
			_costs.length = 0;
			_costs = null;
			
			_game = null;
			_data = null;
		}
	}

}