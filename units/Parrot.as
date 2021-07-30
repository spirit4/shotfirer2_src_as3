package units
{
	import data.AnimationRes;
	import data.Model;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.BitmapClip;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Parrot extends Enemy
	{
		private var _attackSensor:Shape;
		private var _bullet:Body;
		
		public function Parrot(isRight:Boolean)
		{
			_typeMove = AnimationRes.PARROT_MOVE;
			_typeAttack = AnimationRes.PARROT_ATTACK;
			_rect = new Rectangle(0, 0, 48, 64);
			
			super(isRight);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			createBullet();
		}
		
		override public function touchHandler(direction:int):void
		{
			if (_bullet.space)
				bulletHide();
			else
				super.touchHandler(direction);
		}
		
		private function bulletHide():void
		{
			//Controller.juggler.remove(_bullet.userData.view);
			
			_bullet.userData.view.stop();
			_bullet.userData.view.visible = false;
			_bullet.space = null;
			
			_isAttack = false;
		}
		
		private function createBullet():void
		{
			_bullet = new Body();
			
			var circle:Circle = new Circle(7, null, Material.sand());
			circle.body = _bullet;
			
			_bullet.gravMass = 0;
			_bullet.allowRotation = false;
			
			const bitmap:BitmapClip = new BitmapClip(new <uint>[AnimationRes.SPIT], new <Array>[null], new Rectangle(0, 0, 20, 20));
			bitmap.play(AnimationRes.SPIT);
			bitmap.stop();
			parent.addChild(bitmap);
			bitmap.visible = false;
			
			_bullet.userData.type = "bullet";
			_bullet.userData.view = bitmap;
			_bullet.userData.bodyClass = this;
			
			_bullet.setShapeFilters(Model.FILTER_ENEMY_BULLET);
			circle.cbTypes.add(Model.BODY_DANGER);
			circle.cbTypes.add(Model.BODY_ENEMY);
		}
		
		override protected function attack():void
		{
			_directionX = -_directionX;
			super.attack();
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_ATTACK_CRAB);
			
			_bullet.space = _body.space;
			_bullet.userData.view.visible = true;
			_bullet.userData.view.play(AnimationRes.SPIT);
			_bullet.position.setxy(_body.position.x, (_directionY == -1 ? _body.position.y - 10 : _body.position.y));
			_bullet.applyImpulse(Vec2.weak(-_directionX * 45, 0));
			
			//Controller.juggler.add(_bullet.userData.view);
		}
		
		override protected function attackCompleteHandler(e:Event):void
		{
			_view.removeEventListener(Event.COMPLETE, attackCompleteHandler);
			
			_isAttack = false;
			_view.play(_typeMove);
		}
		
		override protected function createBody():void
		{
			_body = new Body();
			_body.allowRotation = false;
			_body.userData.bodyClass = this;
			
			var circle:Circle = new Circle(10, null, Material.ice());
			circle.body = _body;
			circle.cbTypes.add(Model.BODY_ENEMY);
			
			_sensor = new Polygon(Polygon.rect(-5, -27, 10, 54));
			_sensor.sensorEnabled = true;
			_body.shapes.add(_sensor);
			
			_attackSensor = new Polygon(Polygon.rect(-140, -4, 280, 8));
			_attackSensor.sensorEnabled = true;
			_body.shapes.add(_attackSensor);
			
			_attackSensor.cbTypes.add(Model.BODY_DANGER);
			_attackSensor.cbTypes.add(Model.BODY_ENEMY);
			_attackSensor.cbTypes.add(Model.BODY_PARROT_ATTACK_SENSOR);
			
			_body.gravMass = 0;
			
			super.createBody();
		}
		
		override public function update():void
		{
			if (!_isAttack)
			{
				move();
				_body.velocity.y = 50 * _directionY;
			}
			
			if (_directionX == 1)
				this.x = _body.position.x - 20;
			else
				this.x = _body.position.x + this.width - 20;
			
			this.y = _body.position.y - this.height / 2;
			
			_view.scaleX = _directionX;
			
			if (_bullet.space)
			{
				_bullet.rotation = 0;
				_bullet.userData.view.x = _bullet.position.x - 10;
				_bullet.userData.view.y = _bullet.position.y - 10;
				
				if (isHitBullet(_bullet.space.bodiesInShape(_bullet.shapes.at(0))) || Vec2.dsq(_bullet.position, _body.position) > 20000)
					bulletHide();
			}
			
			_delayCounter++;
		}
		
		private function isHitBullet(list:BodyList):Boolean
		{
			var types:Array = [Model.BODY_GROUND, Model.BODY_HERO_CENTER];
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
		
		//override protected function move():void
		//{
			//if (_delayCounter < 40 && _directionDelay == _directionX)
				//return;
			//
			//if (_delayCounter > 200)
				//_isCollision = false;
			//
			//if (!_isCollision && _body.space.bodiesInShape(_sensor).length > 1)
			//{
				//_directionY = _directionY == 1 ? -1 : 1;
				//_isCollision = true;
				//trace("[move Enemy]", isCollisionCheck(_body.space.bodiesInShape(_sensor)));
			//}
			//else if (_isCollision && _body.space.bodiesInShape(_sensor).length == 1)
				//_isCollision = false;
			//
			//if (_directionDelay != _directionY)
			//{
				//_delayCounter = 0;
				//_directionDelay = _directionY;
			//}
		//}
		
		override protected function move():void
		{
			if (_delayCounter < 40 && _directionDelay == _directionY)
				return;
			if (_delayCounter > 200)
				_isCollision = false;
			
			if (!_isCollision && isCollisionCheck(_body.space.bodiesInShape(_sensor)))
			{
				_directionY = _directionY == 1 ? -1 : 1;
				_isCollision = true;
			}
			else if (_isCollision && !isCollisionCheck(_body.space.bodiesInShape(_sensor)))
				_isCollision = false;
			
			if (_directionDelay != _directionY)
			{
				_delayCounter = 0;
				_directionDelay = _directionY;
			}
		}
		
		override public function destroy():void
		{
			if (_bullet.userData.view.parent)
			{
				_bullet.userData.view.parent.removeChild(_bullet.userData.view);
				_bullet.space = null;
			}
			
			_bullet = null;
			_attackSensor = null;
			super.destroy();
		}
		
		public function get attackSensor():Shape
		{
			return _attackSensor;
		}
	}

}