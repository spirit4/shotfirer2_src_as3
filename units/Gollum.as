package units
{
	import data.AnimationRes;
	import data.Model;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import utils.BitmapClip;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Gollum extends Enemy
	{
		private var _moveSensor:Shape;
		
		public function Gollum(isRight:Boolean)
		{
			_typeMove = AnimationRes.GOLLUM_MOVE;
			_typeAttack = AnimationRes.GOLLUM_ATTACK;
			_rect = new Rectangle(0, 0, 64, 64);
			
			super(isRight);
		}
		
		override protected function createView():void
		{
			_view = new BitmapClip(new <uint>[_typeMove, _typeAttack], new <Array>[null, null], _rect);
			addChild(_view);
			_view.play(_typeMove);
			//Controller.juggler.add(_view);
		}
		
		override protected function createBody():void
		{
			_body = new Body();
			_body.allowRotation = false;
			_body.userData.bodyClass = this;
			
			var circle:Circle = new Circle(10, null, Material.ice());
			circle.body = _body;
			circle.material.elasticity = 0.1;
			circle.cbTypes.add(Model.BODY_ENEMY);
			
			_sensor = new Polygon(Polygon.rect(-16, -36, 32, 32));
			_sensor.sensorEnabled = true;
			_body.shapes.add(_sensor);
			
			_moveSensor = new Polygon(Polygon.rect(-24, -25, 48, 10));
			_moveSensor.sensorEnabled = true;
			_body.shapes.add(_moveSensor);
			
			super.createBody();
		}
		
		override protected function move():void
		{
			const prevDirection:int = _directionX;
			
			if (_delayCounter < 40 && _directionDelay == _directionX)
				return;
			if (_delayCounter > 200)
				_isCollision = false;
			
			if (!_isCollision && isCollisionCheck(_body.space.bodiesInShape(_moveSensor)))
			{
				_directionX = _directionX == 1 ? -1 : 1;
				_isCollision = true;
			}
			else if (_isCollision && !isCollisionCheck(_body.space.bodiesInShape(_moveSensor)))
				_isCollision = false;
			
			if (_directionDelay != _directionX)
			{
				_delayCounter = 0;
				_directionDelay = _directionX;
			}
			
			//if (_directionX != prevDirection)
			//{
				//_view.play(AnimationRes.GOLLUM_FF, false);
				//_view.addEventListener(Event.COMPLETE, ffCompleteHandler);
			//}
		}
		
		//private function ffCompleteHandler(e:Event):void
		//{
			//_view.removeEventListener(Event.COMPLETE, ffCompleteHandler);
			//_view.play(_typeMove);
		//}
		
		override public function destroy():void
		{
			_moveSensor = null;
		}
		
		public function get moveSensor():Shape 
		{
			return _moveSensor;
		}
	}

}