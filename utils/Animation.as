package utils
{
	import data.AnimationRes;
	import data.Model;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * type:uint, bitmap:Bitmap, rect:Rectangle, keys:Array = null
	 * @author spirit2
	 */
	public class Animation extends EventDispatcher
	{
		private var _bd:BitmapData;
		private var _point:Point = new Point(); //cache
		private var _rect:Rectangle;
		private var _bitmap:Bitmap;
		private var _completeCallback:Function;
		private var _frameCallback:Function;
		
		private var _isPlaying:Boolean;
		private var _isReverse:Boolean;
		private var _isLoop:Boolean;
		
		private var _numX:uint;
		private var _numY:uint;
		private var _startFrame:uint;
		private var _finishFrame:uint;
		private var _currentFrame:int;
		private var _totalFrames:uint;
		
		private var _cbFrame:uint;
		
		public function Animation(type:uint, bitmap:Bitmap, rect:Rectangle, keys:Array = null)
		{
			_bd = AnimationRes.getSpriteList(type);
			_rect = rect;
			_bitmap = bitmap;
			
			init(keys);
		}
		
		private function init(keys:Array):void
		{
			_numX = _bd.width / _rect.width;
			_numY = _bd.height / _rect.height;
			_totalFrames = _numX * _numY;
			
			_startFrame = 0;
			_finishFrame = _totalFrames - 1;
			
			if (keys)
			{
				_startFrame = keys[0];
				_finishFrame = keys[1];
				//trace(_finishFrame)
			}
			
			_currentFrame = _startFrame;
			_isPlaying = true;
			update();
		}
		
		public function update():void
		{
			if (!_isPlaying || Controller.model.globalState == Model.GLOBAL_PAUSE)
				return;
			
			if (_currentFrame > _finishFrame)
			{
				_completeCallback();
				
				if (!_isLoop)
				{
					stop();
					return;
				}
				
				if (!_rect) //_rect destroy from callback
					return;
				
				if (_isPlaying)
					reset();
			}
			else if (_isReverse && _currentFrame < 0)
			{
				_completeCallback();
				if (!_isLoop)
				{
					stop();
					return;
				}
				if (_isPlaying)
					reset();
			}
			
			if (!_isPlaying)
				return;
			
			_rect.y = int(_currentFrame / _numX) * _rect.height;
			_rect.x = (_currentFrame - int(_currentFrame / _numX) * _numX) * _rect.width;
			
			_bitmap.bitmapData.copyPixels(_bd, _rect, _point);
			
			if (_frameCallback != null && _currentFrame == _cbFrame)
				_frameCallback();
			
			if (!_isReverse)
				_currentFrame++;
			else
				_currentFrame--;
		}
		
		public function play(isLoop:Boolean, isContinue:Boolean, isReverse:Boolean):void
		{
			_isLoop = isLoop;
			_isPlaying = true;
			_isReverse = isReverse;
			
			if (!isContinue)
				reset();
		}
		
		public function stop():void
		{
			_isPlaying = false;
		}
		
		public function reset():void
		{
			_rect.x = _rect.y = 0;
			_currentFrame = _startFrame;
			
			if (_isReverse)
				_currentFrame = _finishFrame;
		}
		
		public function goToAndStop(frame:int):void
		{
			_isPlaying = false;
			
			_currentFrame = frame;
			if (_currentFrame == -1)
				_currentFrame = _finishFrame;
			
			_rect.y = int(_currentFrame / _numX) * _rect.height;
			_rect.x = (_currentFrame - int(_currentFrame / _numX) * _numX) * _rect.width;
			
			_bitmap.bitmapData.copyPixels(_bd, _rect, _point);
		}
		
		public function goToAndPlay(frame:uint):void
		{
			_isPlaying = true;
			
			_currentFrame = frame;
			
			_rect.y = int(_currentFrame / _numX) * _rect.height;
			_rect.x = (_currentFrame - int(_currentFrame / _numX) * _numX) * _rect.width;
			
			_bitmap.bitmapData.copyPixels(_bd, _rect, _point);
		}
		
		public function destroy():void
		{
			_point = null;
			_bd = null;
			_bitmap = null;
			_rect = null;
			_completeCallback = null;
			_frameCallback = null;
		}
		
		public function set completeCallback(value:Function):void
		{
			_completeCallback = value;
		}
		
		public function setFrameCallback(frame:uint, callback:Function):void
		{
			_cbFrame = frame;
			_frameCallback = callback;
		}
	}

}