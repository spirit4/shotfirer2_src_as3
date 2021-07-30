package view
{
	import caurina.transitions.Tweener;
	import data.AchievementController;
	import data.ApiKG;
	import data.ArtefactsController;
	import data.Behavior;
	import data.CoinsController;
	import data.GameController;
	import data.GemsController;
	import data.ImageRes;
	import data.Model;
	import data.PressController;
	import effects.PhysicalBurst;
	import effects.Shaker;
	import event.GameEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import units.*;
	import utils.Analytics;
	import utils.TextBox;
	import utils.TimeUtils;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Game extends Sprite
	{
		private var _data:Model;
		//private var _bonusController:BonusController;
		
		private var _heroController:HeroController;
		private var _gemsController:GemsController;
		private var _coinsController:CoinsController;
		private var _artsController:ArtefactsController;
		private var _pressController:PressController;
		private var _gameController:GameController;
		
		private var _levelLayer:Sprite;
		private var _testgrid:Sprite;
		
		private var _timerLevel:Timer;
		private var _timeInLevel:int;
		
		private var _activeBursts:Vector.<PhysicalBurst> = new Vector.<PhysicalBurst>();
		private var _activeShakers:Vector.<Shaker> = new Vector.<Shaker>();
		
		private var _costs:Vector.<TextBox> = new Vector.<TextBox>();
		
		public function Game()
		{
			_data = Controller.model;
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			createBg();
			
			CONFIG::debug
			{
				drawTestGrid();
			}
			
			createLevelLayer();
			_data.loadLevel(_levelLayer, _testgrid);
			
			if (_data.progress.currentLevel == 9 && _data.progress.radarLevel == 0)
				_data.progress.radarLevel = 1;
				
			if (_data.progress.currentLevel == 9 && _data.progress.batteryLevel == 0)
				_data.progress.batteryLevel = 1;
			
			_data.progress.currentTNT = Behavior.tntToLevels[_data.progress.currentLevel] + _data.progress.tntNumber[_data.progress.tntLevel];
			_data.progress.currentBattery = _data.progress.batteryNumber[_data.progress.batteryLevel];
			
			_heroController = new HeroController(stage, _data.space, _data.hero);
			_gameController = new GameController(this, _heroController);
			_gemsController = new GemsController(this);
			_coinsController = new CoinsController(this);
			_artsController = new ArtefactsController(this);
			_pressController = new PressController(this);
			
			addEventListener(GameEvent.HERO_TO_EXIT, toExitHandler);
			_levelLayer.addEventListener(GameEvent.ENEMY_DIED, enemyDiedHandler);
			
			if (!_data.progress.achievements[ImageRes.A_SPRINTER])
			{
				_timerLevel = new Timer(10000, 1);
				_timerLevel.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
				_timerLevel.start();
			}
			
			_timeInLevel = getTimer();
			///Controller.juggler.add(_data.hero, 1/1)debug only
		}
		
		private function timerCompleteHandler(e:TimerEvent = null):void
		{
			_timerLevel.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			_timerLevel = null;
		}
		
		private function enemyDiedHandler(e:GameEvent):void
		{
			const enemy:Enemy = e.body.userData.bodyClass as Enemy;
			const index:int = _data.enemies.indexOf(enemy);
			
			//const clip:BitmapClip = new BitmapClip(new <uint>[AnimationRes.BLOOD], new <Array>[null], new Rectangle(0, 0, 80, 80));
			//clip.play(AnimationRes.BLOOD, false);
			//_levelLayer.addChildAt(clip, _levelLayer.getChildIndex(enemy) - 1);
			//clip.x = enemy.body.position.x - 40;
			//clip.y = enemy.body.position.y - 40;
			//
			////Controller.juggler.add(clip);
			//clip.addEventListener(Event.COMPLETE, bloodCompleteHandler);
			
			costUp(enemy);
			_data.progress.moneyAtLevel += Behavior.monsterCosts[Object(enemy).constructor];
			dispatchEvent(new GameEvent(GameEvent.CHANGE_CAPACITY, true));
			
			_data.enemies.splice(index, 1);
			enemy.destroy();
			
			_levelLayer.removeChild(enemy);
			
			e.body.userData.bodyClass = null;
			e.body.space = null;
			
			Analytics.pushPage(Analytics.MONSTER_DEATH, (enemy as Enemy).toString()); //TODO
			ApiKG.sendEnemyKilled();
			//AchievementController.getInstance().addParam(AchievementController.ENEMY_DEATH);
			
			//trace("enemy dead1", Object(enemy).constructor);
			//trace("enemy dead2", Behavior.monsterCosts[Object(enemy).constructor]);
		}
		
		private function costUp(enemy:Enemy):void
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
				cost = new TextBox(30, 10, 10, 0xFEFF00, "", Behavior.monsterCosts[Object(enemy).constructor].toString(), "left", true, false, [new DropShadowFilter(0, 0, 0x353535, 1, 2, 2, 20, 2)]);
				_costs.push(cost);
			}
			
			enemy.parent.addChild(cost);
			cost.x = enemy.body.position.x + 10;
			cost.y = enemy.body.position.y - 30;

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
		
		private function toExitHandler(e:GameEvent):void
		{
			if (_timerLevel)
			{
				timerCompleteHandler();
				AchievementController.getInstance().addParam(AchievementController.TEN_SECOND_LVL);
			}
			
			_data.progress.spentTime += getTimer() - _timeInLevel;
			//trace("time in level1: ", TimeUtils.getTimeString(int((getTimer() - _timeInLevel) / 1000)), "spent time: ", TimeUtils.getTimeString(int(_data.progress.spentTime / 1000)));
			_timeInLevel = 0;
		}
		
		//-----------------update-------------------------------------===================================================================
		public function update():void
		{
			if (_testgrid)
			{
				if (Model.isDebug)
					_testgrid.visible = true;
				else
					_testgrid.visible = false;
			}
			
			_heroController.update();
			
			var len:int = _activeBursts.length;
			var burst:PhysicalBurst;
			var shaker:Shaker;
			for (var i:int = 0; i < len; i++)
			{
				burst = _activeBursts[i];
				if (burst)
					burst.update();
				else
				{
					_activeBursts.splice(i, 1);
					i = (i - 1 >= 0) ? (i - 1) : 0;
					len--;
				}
			}
			
			len = _activeShakers.length;
			for (i = 0; i < len; i++)
			{
				shaker = _activeShakers[i];
				if (shaker)
					shaker.update();
				else
				{
					_activeShakers.splice(i, 1);
					i = (i - 1 >= 0) ? (i - 1) : 0;
					len--;
				}
			}
		}
		
		//-----------------update-------------------------------------
		
		private function drawTestGrid():void
		{
			_testgrid = new Sprite();
			_testgrid.mouseEnabled = false;
			_testgrid.mouseChildren = false;
			addChild(_testgrid);
			
			const delta:Number = Model.SIZE >> 1;
			for (var i:int = 0; i <= Model.HEIGHT; i++)
			{
				_testgrid.graphics.lineStyle(1, 0xC3E6EC, 0.1);
				_testgrid.graphics.moveTo(delta, i * Model.SIZE + Model.PADDING_TOP);
				_testgrid.graphics.lineTo(Model.SIZE * Model.WIDTH + delta, i * Model.SIZE + Model.PADDING_TOP);
			}
			for (i = 0; i <= Model.WIDTH; i++)
			{
				_testgrid.graphics.lineStyle(1, 0xC3E6EC, 0.1);
				_testgrid.graphics.moveTo(i * Model.SIZE + delta, Model.PADDING_TOP);
				_testgrid.graphics.lineTo(i * Model.SIZE + delta, Model.SIZE * Model.HEIGHT + Model.PADDING_TOP);
			}
			
			const stats:Stats = new Stats();
			stats.x = 10;
			stats.y = 30;
			_testgrid.addChild(stats);
		}
		
		private function createBg():void
		{
			const bitmap:Bitmap = new Bitmap(ImageRes.backgrounds[0]);
			addChildAt(bitmap, 0);
		}
		
		private function destroy(e:Event):void
		{
			if (_timeInLevel != 0)
			{
				_data.progress.spentTime += getTimer() - _timeInLevel;
				//trace("time in level2: ", TimeUtils.getTimeString(int((getTimer() - _timeInLevel) / 1000)), "spent time: ", TimeUtils.getTimeString(int(_data.progress.spentTime / 1000)));
				_timeInLevel = 0;
			}
			
			if (_timerLevel)
				timerCompleteHandler();
			
			_levelLayer.removeEventListener(GameEvent.ENEMY_DIED, enemyDiedHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListener(GameEvent.HERO_TO_EXIT, toExitHandler);
			
			_gameController.destroy();
			_gemsController.destroy();
			_coinsController.destroy();
			_artsController.destroy();
			_pressController.destroy();
			_heroController.destroy();
			
			if (_testgrid)
			{
				_testgrid.graphics.clear();
				while (_testgrid.numChildren)
					_testgrid.removeChildAt(0);
			}
			
			_levelLayer.graphics.clear();
			while (_levelLayer.numChildren)
				_levelLayer.removeChildAt(0);
			
			this.graphics.clear();
			while (this.numChildren)
				this.removeChildAt(0);
			
			_levelLayer = null;
			_testgrid = null;
			
			_heroController = null;
			_gameController = null;
			_gemsController = null;
			_coinsController = null;
			_artsController = null;
			_pressController = null;
			_data = null;
		}
		
		private function createLevelLayer():void
		{
			_levelLayer = new Sprite();
			addChildAt(_levelLayer, 1);
			
			_levelLayer.mouseChildren = false;
			_levelLayer.mouseEnabled = false;
		}
		
		public function get levelLayer():Sprite
		{
			return _levelLayer;
		}
		
		public function get data():Model
		{
			return _data;
		}
		
		public function get activeBursts():Vector.<PhysicalBurst>
		{
			return _activeBursts;
		}
		
		public function get activeShakers():Vector.<Shaker>
		{
			return _activeShakers;
		}
	}

}