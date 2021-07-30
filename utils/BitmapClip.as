package utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class BitmapClip extends Bitmap implements IUpdatable
	{
		private var _rect:Rectangle;
		private var _animations:Object /*Animation*/ = new Object();
		private var _currentType:uint;
		
		private var _fps:Number;
		
		public function BitmapClip(types:Vector.<uint>, keys:Vector.<Array>, rect:Rectangle, fps:Number = 30)
		{
			_rect = rect;
			_fps = fps;
			super(new BitmapData(_rect.width, _rect.height));
			
			Controller.juggler.add(this, 1 / _fps);
			init(types, keys);
		}
		
		private function init(types:Vector.<uint>, keys:Vector.<Array>):void
		{
			for (var i:int = 0; i < types.length; i++)
			{
				_animations[types[i]] = new Animation(types[i], this, _rect, keys[i]);
				_animations[types[i]].completeCallback = completeCallback;
			}
			_currentType = types[0];
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		public function play(type:int = -1, isLoop:Boolean = true, isContinue:Boolean = false, isReverse:Boolean = false):void
		{
			if (_animations[_currentType] && type != _currentType)
				_animations[_currentType].reset();
			
			if (type > -1)
			{
				if (!isContinue)
				{
					_currentType = type;
					_animations[_currentType].play(isLoop, isContinue, isReverse);
				}
				else
					_animations[_currentType].play(isLoop, isContinue, isReverse);
			}
			else
				_animations[_currentType].play(isLoop, isContinue, isReverse);
				
			Controller.juggler.add(this, 1 / _fps);
		}
		
		public function stop():void
		{
			Controller.juggler.remove(this);
			_animations[_currentType].stop();
		}
		
		public function goToAndStop(frame:int):void
		{
			_animations[_currentType].goToAndStop(frame);
		}
		
		public function goToAndPlay(frame:uint):void
		{
			_animations[_currentType].goToAndPlay(frame);
		}
		
		public function update():void
		{
			_animations[_currentType].update();
		}
		
		private function completeCallback():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function addFrameCallback(frame:uint, callback:Function):void
		{
			_animations[_currentType].setFrameCallback(frame, callback);
		}
		
		private function destroy(e:Event):void
		{
			Controller.juggler.remove(this);
			
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			for (var key:String in _animations)
			{
				//trace("_animations[key]",key)
				if (_animations[key]) //wtf!!! only local bug without ide
					_animations[key].destroy();
				_animations[key] = null
			}
			
			_animations = null;
			_rect = null;
		}
		
		public function get currentType():uint 
		{
			return _currentType;
		}
		
		public function get fps():Number 
		{
			return _fps;
		}
		
		public function set fps(value:Number):void 
		{
			_fps = value;
			Controller.juggler.remove(this);
			Controller.juggler.add(this, 1 / value);
		}
	}

}