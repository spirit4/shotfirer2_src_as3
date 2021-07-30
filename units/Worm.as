package units
{
	import data.AnimationRes;
	import data.Model;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import utils.BitmapClip;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Worm extends Enemy
	{
		
		public function Worm()
		{
			_typeMove = AnimationRes.WORM_IDLE;
			_typeAttack = AnimationRes.WORM_ATTACK;
			_rect = new Rectangle(0, 0, 36, 68);
			
			super(false);
		}
		
		override protected function createView():void
		{
			_view = new BitmapClip(new <uint>[_typeMove, _typeAttack], new <Array>[AnimationRes.WORM_IDLE_KEYS, AnimationRes.WORM_ATTACK_KEYS], _rect);
			addChild(_view);
			_view.play(_typeMove);
			//trace("[cr view]", _typeAttack);
		}
		
		override protected function createBody():void
		{
			_body = new Body(BodyType.STATIC);
			_body.allowRotation = false;
			_body.userData.bodyClass = this;
			
			_sensor = new Polygon(Polygon.rect(-5, -10, 10, 50));
			_sensor.sensorEnabled = true;
			_body.shapes.add(_sensor);
			
			super.createBody();
		}
		
		override protected function attack():void
		{
			//trace("[attack]", _isAttack);
			_isAttack = true;
			_view.play(_typeAttack, false);
			_view.addEventListener(Event.COMPLETE, attackCompleteHandler);
		}
		
		override public function update():void
		{
			this.y = _body.position.y - this.height + 12;
			this.x = _body.position.x - this.width / 2;
		
			_view.scaleX = -_directionX;
		}
		
		override public function touchHandler(direction:int):void
		{
			//_directionX = -direction;
			
			attack();
		}
		
		override protected function move():void
		{

		}
		
		override public function destroy():void
		{
		
		}
	
	}

}