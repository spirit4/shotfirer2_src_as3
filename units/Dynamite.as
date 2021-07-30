package units
{
	import caurina.transitions.Tweener;
	import data.AchievementController;
	import data.AnimationRes;
	import data.Model;
	import effects.PhysicalBurst;
	import effects.Shaker;
	import event.GameEvent;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.BitmapClip;
	import view.Game;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Dynamite extends EventDispatcher
	{
		static public const GROUND:uint = 0;
		static public const STONE:uint = 1;
		static public const BOX:uint = 2;
		static public const BOX_TNT:uint = 3;
		
		private var _game:Game;
		private var _hero:Hero;
		private var _space:Space;
		private var _enemies:Vector.<Enemy>;
		
		private var _view:BitmapClip;
		private var _countdown:BitmapClip;
		private var _boom:BitmapClip;
		private var _smoke:BitmapClip;
		private var _body:Body;
		
		private var _index:int = 0;
		private var _timerTNT:Timer = new Timer(1500, 1);
		
		private var _type:uint;
		
		private var _range:Shape;
		
		public function Dynamite(game:Game, index:int, type:uint = 0)
		{
			_index = index;
			_game = game;
			
			const model:Model = Controller.model;
			_hero = model.hero;
			_space = model.space;
			_enemies = model.enemies
			_type = type;
			
			startCountdown();
			
			_game.levelLayer.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function startCountdown():void
		{
			_timerTNT.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			_timerTNT.start();
			
			createTNT();
		}
		
		private function createTNT():void
		{
			SoundManager.getInstance().playSFX(SoundRes.SFX_FUSE);
			
			_view = new BitmapClip(new <uint>[AnimationRes.TNT_FUSE], new <Array>[null], new Rectangle(0, 0, 32, 32));
			_view.play(AnimationRes.TNT_FUSE, false);
			
			_countdown = new BitmapClip(new <uint>[AnimationRes.TNT_TIMER], new <Array>[null], new Rectangle(0, 0, 32, 32));
			_countdown.play(AnimationRes.TNT_TIMER, false);
			
			//Controller.juggler.add(_view);
			//Controller.juggler.add(_countdown);
			//trace("tnt_set")
			_countdown.addEventListener(Event.COMPLETE, animationCompleteHandler);
			
			_body = new Body();
			var poly:Polygon = new Polygon(Polygon.rect(-8, -9, 16, 18), Material.steel(), Model.FILTER_TNT);
			_body.shapes.add(poly);
			_body.allowRotation = false;
			//poly.sensorEnabled = true;
			
			poly.cbTypes.add(Model.BODY_TNT);
			_body.space = _space;
			
			const indexDO:int = _index == 0 ? _game.levelLayer.numChildren - 1 : 0;
			_game.levelLayer.addChildAt(_view, indexDO);
			_game.levelLayer.addChild(_countdown);
		}
		
		private function animationCompleteHandler(e:Event):void
		{
			_countdown.removeEventListener(Event.COMPLETE, animationCompleteHandler);
			
			//Controller.juggler.remove(_view);
			//Controller.juggler.remove(_countdown);
			//trace("tnt_off")
		}
		
		private function completeHandler(e:TimerEvent):void
		{
			_timerTNT.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			_timerTNT.reset();
			_timerTNT = null;
			
			if (_type != STONE)
			{
				if ((_index == 0 && _body.position.y + Model.SIZE > (Model.HEIGHT + 0.5) * Model.SIZE) || (_index == -1 && _body.position.x - Model.SIZE < 0) || (_index == 1 && _body.position.x + Model.SIZE > (Model.WIDTH + 0.5) * Model.SIZE))
				{
					removeTNT();
					destroy();
					return;
				}
			}
			
			detonateTNT();
			dispatchEvent(new GameEvent(GameEvent.DETONATED_DYNAMITE));
		}
		
		private function removeTNT():void
		{
			_body.space = null;
			if (_game.levelLayer)
			{
				_game.levelLayer.removeChild(_view);
				_game.levelLayer.removeChild(_countdown);
			}
		}
		
		private function checkTargetHit():void
		{
			var type:int = PhysicalBurst.GOLLUM;
			var dx2:Number;
			var dy2:Number;
			var radius2:Number = 2100//1300; //---------------------------------------------------------------------radius
			const queueToDie:Array = [];
			for each (var enemy:Enemy in _enemies)
			{
				dx2 = (_body.position.x - enemy.body.position.x) * (_body.position.x - enemy.body.position.x);
				dy2 = (_body.position.y - enemy.body.position.y) * (_body.position.y - enemy.body.position.y);
				
				if (dx2 + dy2 < radius2)
				{
					if (enemy is Parrot)
						type = PhysicalBurst.PARROT;
					else if (enemy is Crab)
						type = PhysicalBurst.CRAB;
					
					const burst:PhysicalBurst = new PhysicalBurst(_game, _space, 2, type);
					burst.startBurst(enemy.body.position.x, enemy.body.position.y, 10, 9);
					
					queueToDie.push(enemy.body);
					
					
					AchievementController.getInstance().addParam(AchievementController.ENEMY_DEATH_TNT);
				}
			}
			
			var ev:GameEvent;
			for each (var body:Body in queueToDie) 
			{
				ev = new GameEvent(GameEvent.ENEMY_DIED);
				ev.body = body;
				_game.levelLayer.dispatchEvent(ev);
			}
			
			var posX:Number = _view.x + 16;
			var posY:Number = _view.y + 16;
			
			if (_view.rotation > 0)
			{
				posX -= 32;
				posY += 16;
			}
			else if (_view.rotation < 0)
			{
				posY -= 32;
			}
			dx2 = (posX - _hero.base.position.x) * (posX - _hero.base.position.x);
			dy2 = (posY - (_hero.base.position.y - 20)) * (posY - (_hero.base.position.y - 20));
			
			//shape = new Shape();
			//_game.levelLayer.addChild(shape);
			//shape.graphics.beginFill(0xFFFF00, 1);
			//shape.graphics.drawCircle(_hero.base.position.x, _hero.base.position.y - 20, 2);
			//shape.graphics.endFill();
			//
			//shape = new Shape();
			//_game.levelLayer.addChild(shape);
			//shape.graphics.beginFill(0x00FF00, 1);
			//shape.graphics.drawCircle(posX, posY, 2);
			//shape.graphics.endFill();
			
			radius2 = 1500;//only for hero
			if (dx2 + dy2 < radius2)
				dispatchEvent(new GameEvent(GameEvent.HERO_DEAD));
		}
		
		public function addRange():void
		{
			var posX:Number = _view.x + 16;
			var posY:Number = _view.y + 16;
			
			if (_view.rotation > 0)
			{
				posX -= 32;
				//posY += 16;
			}
			else if (_view.rotation < 0)
			{
				posY -= 32;
			}
			
			_range = new Shape();
			_game.levelLayer.addChild(_range);
			_range.x = posX;// - 16;
			_range.y = posY;// + 16;
			_range.graphics.lineStyle(1, 0xFFFFFF, 1);
			_range.graphics.drawCircle(0, 0, 32);
			_range.graphics.endFill();
			
			tweenRange();
		}
		
		private function tweenRange():void
		{
			//trace("tweenRange", _range);
			_range.scaleX = _range.scaleY = 0;
			Tweener.addTween(_range, {scaleX: 1, scaleY: 1, time: 1.5, transition: "easeOutSine", onComplete: removeRange});
		}
		
		private function removeRange():void
		{
			if (_range)
			{
				//trace("rem", Tweener.removeTweens(_range));
				Tweener.removeTweens(_range)
				_range.graphics.clear();
				
				if(_range.parent)
					_game.levelLayer.removeChild(_range);
					
				_range = null;
			}
		}
		
		private function detonateTNT():void
		{
			checkTargetHit();
			removeTNT();
			
			const shaker:Shaker = new Shaker(_game, _game);
			
			var typeBoom:int;
			if (_type == STONE)
				typeBoom = AnimationRes.TNT_BOOM_SMALL;
			else if (_type == BOX)
				typeBoom = AnimationRes.BONUS_BOOM;
			else if (_type == BOX_TNT)
			{
				destroy();
				return;
			}
			else
				typeBoom = AnimationRes.TNT_BOOM;
			
			var rect:Rectangle = new Rectangle(0, 0, 64, 64);
			if (_type == BOX)
				rect = new Rectangle(0, 0, 128, 128);
			
			_boom = new BitmapClip(new <uint>[typeBoom], new <Array>[null], rect);
			_boom.play(typeBoom, false);
			_game.levelLayer.addChild(_boom);
			_boom.x = _countdown.x - 16;
			_boom.y = _countdown.y - 36;
			
			//Controller.juggler.add(_boom);
			_boom.addEventListener(Event.COMPLETE, boomCompleteHandler);
			
			if (_index == -1)
			{
				_boom.rotation = 90;
				_boom.x += 78;
				_boom.y += 21;
			}
			else if (_index == 1)
			{
				_boom.rotation = -90;
				_boom.x -= 15;
				_boom.y += 80;
			}
			
			if (_type != BOX)
			{
				_smoke = new BitmapClip(new <uint>[AnimationRes.SMOKE], new <Array>[null], new Rectangle(0, 0, 64, 64));
				_smoke.play(AnimationRes.SMOKE, false);
				_game.levelLayer.addChild(_smoke);
				_smoke.x = _countdown.x - 16;
				_smoke.y = _countdown.y - 66;
				
				if (_index == -1)
				{
					_smoke.x += 25;
					_smoke.y += 31;
				}
				else if (_index == 1)
				{
					_smoke.x -= 25;
					_smoke.y += 30;
				}
				
				//Controller.juggler.add(_smoke);
				_smoke.addEventListener(Event.COMPLETE, smokeCompleteHandler);
			}
			
			var burst:PhysicalBurst;
			if (_type == BOX)
			{
				_boom.x -= 32;
				_boom.y -= 32;
				
				burst = new PhysicalBurst(_game, _space, _index, PhysicalBurst.BOX);
				burst.startBurst(_countdown.x, _countdown.y, 15, 6);
			}
			
			if (_type == GROUND)
			{
				burst = new PhysicalBurst(_game, _space, _index, PhysicalBurst.GROUND);
				burst.startBurst(_countdown.x, _countdown.y);
			}
		}
		
		private function boomCompleteHandler(e:Event):void
		{
			_boom.removeEventListener(Event.COMPLETE, boomCompleteHandler);
			//Controller.juggler.remove(_boom);
			
			_game.levelLayer.removeChild(_boom);
			_boom = null;
		}
		
		private function smokeCompleteHandler(e:Event):void
		{
			_smoke.removeEventListener(Event.COMPLETE, boomCompleteHandler);
			//Controller.juggler.remove(_smoke);
			
			_game.levelLayer.removeChild(_smoke);
			_smoke = null;
			destroy();
		}
		
		private function destroy(e:Event = null):void
		{
			_game.levelLayer.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			removeRange();
			
			if (_boom)
				_boom.removeEventListener(Event.COMPLETE, boomCompleteHandler);
			
			if (_smoke)
				_smoke.removeEventListener(Event.COMPLETE, boomCompleteHandler);
			
			_countdown.removeEventListener(Event.COMPLETE, animationCompleteHandler);
			_game = null;
			
			if (_timerTNT)
			{
				_timerTNT.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
				_timerTNT.stop();
				_timerTNT = null;
			}
			_body.space = null;
			
			_space = null;
			_enemies = null;
			_hero = null;
			_body = null;
			_view = null;
			_countdown = null;
			_boom = null;
			_smoke = null;
		}
		
		public function get body():Body
		{
			return _body;
		}
		
		public function get view():BitmapClip
		{
			return _view;
		}
		
		public function get countdown():BitmapClip
		{
			return _countdown;
		}
		
		public function get type():uint
		{
			return _type;
		}
	}

}