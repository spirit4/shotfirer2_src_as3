package effects
{
	import caurina.transitions.Tweener;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class TransitionQuarter extends Sprite
	{
		private var _object:DisplayObject;
		private var _bd:BitmapData;
		
		public function TransitionQuarter(object:DisplayObject)
		{
			_object = object;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_bd = new BitmapData(640, 480);
			_bd.draw(_object);
			
			var shape:Shape;
			const w:Number = 640 / 2;
			const h:Number = 480 / 2;
			
			_object.scaleX = _object.scaleY = 0.8;
			_object.x = w - _object.width / 2;
			_object.y = h - _object.height / 2;
			Tweener.addTween(_object, {x: 0, y: 0, scaleX: 1, scaleY: 1, time: 0.5, transition: "easeOutQuad"});
			
			shape = new Shape();
			shape.x = 0;
			shape.y = h;
			shape.graphics.beginBitmapFill(_bd, new Matrix(1, 0, 0, 1, 0, -h), false, true);
			shape.graphics.drawRect(0, -h, w, h);
			shape.graphics.endFill();
			addChild(shape);
			Tweener.addTween(shape, {rotation: -90, time: 0.5, transition: "easeInQuad"});
			
			shape = new Shape();
			shape.x = w * 2;
			shape.y = h;
			shape.graphics.beginBitmapFill(_bd, new Matrix(1, 0, 0, 1, -2 * w, -h), false, true);
			shape.graphics.drawRect(-w, -h, w, h);
			shape.graphics.endFill();
			addChild(shape);
			Tweener.addTween(shape, {rotation: 90, time: 0.5, transition: "easeInQuad"});
			
			shape = new Shape();
			shape.x = 0;
			shape.y = h;
			shape.graphics.beginBitmapFill(_bd, new Matrix(1, 0, 0, 1, 0, -h), false, true);
			shape.graphics.drawRect(0, 0, w, h);
			shape.graphics.endFill();
			addChild(shape);
			Tweener.addTween(shape, {rotation: 90, time: 0.5, transition: "easeInQuad"});
			
			shape = new Shape();
			shape.x = w * 2;
			shape.y = h;
			shape.graphics.beginBitmapFill(_bd, new Matrix(1, 0, 0, 1, -2 * w, -h), false, true);
			shape.graphics.drawRect(-w, 0, w, h);
			shape.graphics.endFill();
			addChild(shape);
			Tweener.addTween(shape, {rotation: -90, time: 0.5, transition: "easeInQuad", onComplete: destroy});
		}
		
		private function destroy():void
		{
			while (numChildren)
				removeChildAt(0);
			
			_object = null;
			_bd.dispose();
			_bd = null;
			
			parent.removeChild(this);
		}
	}

}