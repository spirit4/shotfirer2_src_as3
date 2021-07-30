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
	public class GemsController
	{
		private var _data:Model;
		private var _game:Game;
		
		private var _costs:Vector.<TextBox> = new Vector.<TextBox>();
		
		public function GemsController(game:Game)
		{
			_data = Controller.model;
			_game = game;
			

			init();
		}
		
		private function init():void
		{
			for each (var body:Body in _data.gems)
			{
				//Controller.juggler.add(body.userData.view);
			}

			playAnimationGem();
			//Model.console.tf.appendText("\r" + "test");
			//Model.console.tf.appendText("\r" + _data.space.listeners);
			//Model.console.tf.appendText("\r" + toGemHandler);
			
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_GEM, new OptionType([Model.BODY_HERO_CENTER, Model.BODY_HERO_BASE]), toGemHandler));
		}
		
		private function playAnimationGem():void
		{
			Controller.juggler.removeCall(playAnimationGem);
			
			if (_data.gems.length == 0)
				return;
			
			const delayNextPlay:int = int(Math.random() * 60) + 30;
			
			const index:uint = uint(Math.random() * _data.gems.length);
			(_data.gems[index].userData.view as BitmapClip).play(AnimationRes.GEM, false);
			
			Controller.juggler.addCall(playAnimationGem, delayNextPlay/60);
		}
		
		private function toGemHandler(cb:InteractionCallback):void
		{
			//Model.console.tf.appendText("\r111" + cb.toString());
			if (cb.int2.castShape.body != _data.hero.base && _data.hero.topShape.sensorEnabled)
				return;
			//Model.console.tf.appendText("\r222" + cb.toString());	
			if (_data.hero.states.currentState == States.DEATH_0)
				return;
			//Model.console.tf.appendText("\r333" + cb.toString());	
			const bitmap:Bitmap = cb.int1.castBody.userData.view as Bitmap;
			
			//Model.console.tf.appendText("\r" + cb.toString());
			//Model.console.tf.appendText("\r" + cb.int1.toString());
			//Model.console.tf.appendText("\r" + cb.int1.castBody.userData.view);
			//
			
			if(!bitmap)
			{
				//trace("cb.int1.castBody.userData AHTUNG", cb.int1.castBody.userData.type)// attention! debug|release bug
				return;
			}
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_GET_GEM);
			
			addEffectGetting(bitmap);
			
			costUp(bitmap);
			_data.progress.moneyAtLevel += Behavior.RUBY_COST;
			_game.dispatchEvent(new GameEvent(GameEvent.CHANGE_CAPACITY, true));
			
			bitmap.parent.removeChild(bitmap);
			cb.int1.castBody.userData.view = null;
			cb.int1.castBody.space = null;
			
			const index:uint = _data.gems.indexOf(cb.int1.castBody);
			_data.gems.splice(index, 1);
			_data.progress.currentStar++;
			
			Analytics.pushPage(Analytics.GET_RUBIN);
			AchievementController.getInstance().addParam(AchievementController.GETTING_RUBY);
			
			//if (_data.hero.states.currentState == States.JUMP_IDLE)
				//AchievementController.getInstance().addParam(AchievementController.GETTING_FLY_GEM);
		}
		
		private function costUp(bitmap:Bitmap):void
		{
			var cost:TextBox;
			for each (var item:TextBox in _costs) 
			{
				if (!item.visible)
				{
					cost = item;
					break;
				}
			}
			if(!cost)
			{
				cost = new TextBox(30, 10, 10, 0xFEFF00, "", Behavior.RUBY_COST.toString(), "left", true, false, [new DropShadowFilter(0, 0, 0x353535, 1, 2, 2, 20, 2)]);
				_costs.push(cost);
			}
			
			bitmap.parent.addChild(cost);
			cost.x = bitmap.x + 20;
			cost.y = bitmap.y - 3;

			cost.scaleX = cost.scaleY = 1;
			cost.alpha = 1;
			cost.visible = true;
			
			Tweener.addTween(cost, {scaleX: 2, scaleY: 2, y: (cost.y - 20), time: 0.4, transition: "easeInQuart", onComplete: costDown, onCompleteParams: [cost]});
		}
		
		private function costDown(tf:TextBox):void
		{
			Tweener.addTween(tf, {scaleX: 1.2, scaleY: 1.2, alpha:0, time: 0.3, transition: "easeOutQuart", onComplete: costDown, onCompleteParams: [tf]});
		}
		
		private function costHide(tf:TextBox):void
		{
			tf.visible = false;
		}
		
		private function addEffectGetting(gemClip:Bitmap):void
		{
			const bitmap:BitmapClip = new BitmapClip(new <uint>[AnimationRes.GEM_GET], new <Array>[null], new Rectangle(0, 0, 64, 64));
			bitmap.play(AnimationRes.GEM_GET, false);
			bitmap.x = gemClip.x - 16;
			bitmap.y = gemClip.y - 32;
			
			//Controller.juggler.add(bitmap);
			
			_game.levelLayer.addChild(bitmap);
			bitmap.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
		}
		
		private function completeHandler(e:Event):void
		{
			const bitmap:BitmapClip = e.currentTarget as BitmapClip;
			//Controller.juggler.remove(bitmap);
			
			bitmap.removeEventListener(Event.COMPLETE, completeHandler);
			_game.levelLayer.removeChild(bitmap);
		}
		
		public function destroy():void
		{
			//for each (var body:Body in _data.gems)
			//{
				//Controller.juggler.remove(body.userData.view);
			//}
			Controller.juggler.removeCall(playAnimationGem);
			
			_costs.length = 0;
			_costs = null;
			
			_game = null;
			_data = null;
		}
	}

}