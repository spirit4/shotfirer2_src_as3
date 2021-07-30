package effects
{
	import caurina.transitions.Tweener;
	import data.ImageRes;
	import data.Model;
	import event.GameEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.RandUtils;
	import utils.TextBox;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class TransitionRockfall extends Sprite
	{
		private var _level:int;
		private var _model:Model;
		private var _callback:Function;
		
		private var _startTime:uint;
		private const DELAY:uint = 400;
		
		private var _shape:Shape;
		private var _parts:Vector.<Sprite> = new Vector.<Sprite>();
		
		public function TransitionRockfall(level:int, callback:Function, model:Model = null)
		{
			_level = level;
			_model = model;
			_callback = callback;
			
			_shape = new Shape();
			_shape.graphics.beginFill(0x10100E, 1);
			_shape.graphics.drawRect(0, 0, 800, 600);
			_shape.graphics.endFill();
			addChild(_shape);
			_shape.alpha = 0;
			
			//trace("obj", _model)
			if (_model)
				_model.addEventListener(GameEvent.LEVEL_INIT, initHandler);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function initHandler(e:GameEvent):void//for levels
		{
			_model.removeEventListener(GameEvent.LEVEL_INIT, initHandler);
			//trace("initHandler");
			open();
		}
		
		private function init(e:Event):void
		{
			//trace("init");
			Tweener.addTween(_shape, { alpha: 1, time: 0.4, transition: "easeOutSine", onComplete: clapHandler } );
			
			var bitmap:Bitmap;
			var sprite:Sprite;
			var index:int;
			var speed:Number;
			var rotation:int;
			
			for (var i:int = 0; i < 15; i++) 
			{
				sprite = new Sprite();
				
				index = RandUtils.getInt(0, 4);
				speed = RandUtils.getFloat(0.3, 0.7);
				rotation = RandUtils.getInt(0, 1) == 0 ? RandUtils.getFloat(-100, -50) : RandUtils.getFloat(50, 100);
				bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_ROCKFALL_0 + index], "auto", true);
				sprite.x = RandUtils.getFloat(0, 20) + i * 50;
				sprite.y = -130;
				bitmap.x = -bitmap.width >> 1;
				bitmap.y = -bitmap.height >> 1;
				sprite.addChild(bitmap);
				addChild(sprite);
				_parts.push(sprite);
				//trace("init", index, speed, rotation,sprite.x,sprite.y);
				Tweener.addTween(sprite, { y: 770, rotation: rotation, time: speed, delay: RandUtils.getFloat(0, 0.5), transition: "linear" } );
			}
		}
		
		private function clapHandler():void
		{
			if (_level != -1)
			{
				const sprite:Sprite = new Sprite();
				addChild(sprite);
				sprite.mouseEnabled = false;
				sprite.mouseChildren = false;
				sprite.alpha = 0;
				
				const text:String = "Level " + (_level + 1).toString();
				const tf:TextBox = new TextBox(240, 46, 40, 0xFFFFFF, "", text, "center", true);
				sprite.addChild(tf);
				tf.y = 3;
				tf.mouseEnabled = false;
				
				tf.changeParams(2, 1);
				
				const dx:Number = (800 - sprite.width) >> 1;
				const dy:Number = (600 - sprite.height) >> 1;
				
				sprite.scaleX = sprite.scaleY = 0.2;
				sprite.x = (800 - sprite.width) >> 1;
				sprite.y = (600 - sprite.height) >> 1;
				Tweener.addTween(sprite, {x: dx, y: dy, scaleX: 1, scaleY: 1, alpha: 1, time: 0.4, transition: "easeOutBack", onComplete: sendCallback});
			}
			else
			{
				sendCallback();
			}
		}
		
		private function sendCallback():void
		{
			_startTime = getTimer();
			
			_callback();
			
			if (!_model)
				open();
		}
		
		private function open():void
		{
			var delayTween:Number = 0;
			if (getTimer() - _startTime < DELAY)
				delayTween = DELAY * 0.001;
			
			//trace("open2", getTimer() - _startTime, delayTween)
			
			if (_level != -1)
			{
				Tweener.addTween(getChildAt(numChildren - 1), {alpha: 0, time: 0.4, delay: delayTween, transition: "linear"});
			}
			
			_shape.alpha = 1;
			Tweener.addTween(_shape, {alpha: 0, time: 0.4, transition: "easeInSine"});
			Tweener.addTween(this, {time: 0.5, delay: 0.4, transition: "linear", onComplete: destroy});
		}
		
		private function destroy():void
		{
			while (numChildren)
				removeChildAt(0);
			
			_parts.length = 0;
			_parts = null;
			
			_callback = null;
			_shape = null;
			_model = null;
			
			parent.removeChild(this);
		}
	}

}