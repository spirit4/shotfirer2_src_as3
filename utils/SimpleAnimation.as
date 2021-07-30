package utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class SimpleAnimation extends Sprite
	{
		private var _bd:BitmapData;
		private var _point:Point = new Point(); //cache
		private var _rect:Rectangle;
		private var _bitmap:Bitmap;
		
		private var _numX:uint;
		private var _numY:uint;
		private var _startFrame:uint;
		private var _finishFrame:uint;
		private var _currentFrame:int;
		private var _totalFrames:uint;
		
		private var _counter:uint;
		
		public function SimpleAnimation(bd:BitmapData, rect:Rectangle)
		{
			mouseEnabled = false;
			
			_bd = bd;
			_rect = rect;
			_bitmap = new Bitmap(new BitmapData(_rect.width, _rect.height));
			addChild(_bitmap);
			
			_numX = _bd.width / _rect.width;
			_numY = _bd.height / _rect.height;
			_totalFrames = _numX * _numY;
			
			_startFrame = 0;
			_finishFrame = _totalFrames - 1;
		}
		
		public function update():void
		{
			_counter++;
			if (_counter % 2 == 0)
				return;
			
			if (_currentFrame > _finishFrame)
				reset();
			
			_rect.y = int(_currentFrame / _numX) * _rect.height;
			_rect.x = (_currentFrame - int(_currentFrame / _numX) * _numX) * _rect.width;
			
			_bitmap.bitmapData.copyPixels(_bd, _rect, _point);
			
			_currentFrame++;
		}
		
		public function play():void
		{
			update();
		}
		
		public function reset():void
		{
			_rect.x = _rect.y = 0;
			_currentFrame = _startFrame;
			_counter = 0;
		}
		
		public function destroy():void
		{
			removeChild(_bitmap);
			
			_point = null;
			_bd = null;
			_bitmap = null;
			_rect = null;
		}
	}

}