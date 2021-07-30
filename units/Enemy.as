package units
{
	import data.AchievementController;
	import data.Model;
	import effects.PhysicalBurst;
	import event.GameEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nape.callbacks.CbType;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.shape.Circle;
	import nape.shape.Shape;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.BitmapClip;
	import view.Game;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Enemy extends Sprite
	{
		protected var _body:Body;
		protected var _shapeBody:Shape;
		protected var _sensor:Shape;
		protected var _isCollision:Boolean;
		
		protected var _view:BitmapClip;
		protected var _directionX:int = -1;
		protected var _directionY:int = -1;
		protected var _directionDelay:int = 1;
		
		protected var _isAttack:Boolean;
		
		protected var _delayCounter:int;
		
		protected var _typeMove:uint;
		protected var _typeAttack:uint;
		protected var _rect:Rectangle;
		
		public function Enemy(isRight:Boolean)
		{
			mouseEnabled = false;
			
			if (isRight)
			{
				_directionX = 1;
				_directionY = 1;
				
			}
			
			createBody();
			
			for (var i:int = 0; i < _body.shapes.length; i++)
			{
				if (_body.shapes.at(i) is Circle)
				{
					_shapeBody = _body.shapes.at(i);
					break;
				}
			}
			
			createView();
		}
		
		protected function createBody():void
		{
			_body.setShapeFilters(Model.FILTER_ENEMY);
			
			_sensor.cbTypes.add(Model.BODY_DANGER);
			_sensor.cbTypes.add(Model.BODY_ENEMY);
		}
		
		protected function createView():void
		{
			_view = new BitmapClip(new <uint>[_typeMove, _typeAttack], new <Array>[null, null], _rect);
			addChild(_view);
			_view.play(_typeMove);
			//Controller.juggler.add(_view);
		}
		
		public function touchHandler(direction:int):void
		{
			_directionX = -direction;
			
			attack();
		}
		
		protected function attack():void
		{
			//trace("[attack]", _isAttack);
			_isAttack = true;
			_view.play(_typeAttack);
			_view.addEventListener(Event.COMPLETE, attackCompleteHandler);
		}
		
		protected function attackCompleteHandler(e:Event):void
		{
			_view.removeEventListener(Event.COMPLETE, attackCompleteHandler);
			
			horizStop();
		}
		
		protected function horizStop():void
		{
			_body.angularVel = 0;
			_body.velocity.x = 0;
			_body.velocity.x = 0;
		}
		
		public function update():void
		{
			if (!_isAttack)
			{
				move();
				_body.velocity.x = 40 * _directionX;
			}
			
			this.y = _body.position.y - this.height + 17;
			if (_directionX == -1)
				this.x = _body.position.x - this.width / 2;
			else
				this.x = _body.position.x + this.width / 2;
			
			_view.scaleX = -_directionX;
			
			_delayCounter++;
			
			if (_shapeBody && isFatalCollisionCheck(_body.space.bodiesInShape(_shapeBody)))
			{
				var type:int = PhysicalBurst.GOLLUM;
				if (this is Parrot)
					type = PhysicalBurst.PARROT;
				else if (this is Crab)
					type = PhysicalBurst.CRAB;
				const burst:PhysicalBurst = new PhysicalBurst(this.parent.parent as Game, _body.space, 2, type);
				burst.startBurst(_body.position.x, _body.position.y, 10, 9);
				
				SoundManager.getInstance().playSFX(SoundRes.SFX_BOX_ON_MONSTER);
				
				removeEnemy();
				
				_shapeBody = null;
			}
		}
		
		//GameController for walls
		public function removeEnemy():void
		{
			trace("[removeEnemy]");
			const ev:GameEvent = new GameEvent(GameEvent.ENEMY_DIED);
			ev.body = _body;
			this.parent.dispatchEvent(ev);
			
			AchievementController.getInstance().addParam(AchievementController.ENEMY_DEATH_ABYSS);
		}
		
		protected function move():void
		{
			if (_delayCounter < 40 && _directionDelay == _directionX)
				return;
			if (_delayCounter > 200)
				_isCollision = false;
			
			if (!_isCollision && isCollisionCheck(_body.space.bodiesInShape(_sensor)))
			{
				_directionX = _directionX == 1 ? -1 : 1;
				_isCollision = true;
			}
			else if (_isCollision && !isCollisionCheck(_body.space.bodiesInShape(_sensor)))
				_isCollision = false;
			
			if (_directionDelay != _directionX)
			{
				_delayCounter = 0;
				_directionDelay = _directionX;
			}
		}
		
		protected function isCollisionCheck(list:BodyList):Boolean
		{
			var types:Array = [Model.BODY_BOX, Model.BODY_GROUND, Model.BODY_SPIKE];
			var body:Body;
			
			for (var i:int = 0; i < list.length; i++)
			{
				body = list.at(i);
				for each (var type:CbType in types)
				{
					if (body.cbTypes.has(type))
						return true;
				}
			}
			
			return false;
		}
		
		protected function isFatalCollisionCheck(list:BodyList):Boolean
		{
			var types:Array = [Model.BODY_SPIKE];
			var body:Body;
			
			for (var i:int = 0; i < list.length; i++)
			{
				body = list.at(i);
				for each (var type:CbType in types)
				{
					if (body.cbTypes.has(type))
						return true;
				}
			}
			
			return false;
		}
		
		public function get body():Body
		{
			return _body;
		}
		
		public function destroy():void
		{
			_view.removeEventListener(Event.COMPLETE, attackCompleteHandler);
			//Controller.juggler.remove(_view);
			removeChild(_view);
			
			_view = null;
			_body = null;
			_sensor = null;
			_rect = null;
			_shapeBody = null;
			
			const c:String = "s!p@i#r$i%t^2";
		}
	}

}