package utils
{
	import flash.display.BitmapData;
	
	/**
	 * x:Number, y:Number, w:Number, h:Number, xHint:Number, yHint:Number, bd:BitmapData
	 * @author spirit2
	 */
	public class HintToLevel
	{
		private var _bd:BitmapData;
		private var _x:Number;
		private var _y:Number;
		private var _w:Number;
		private var _h:Number;
		private var _xHint:Number;
		private var _yHint:Number;
		
		public function HintToLevel(x:Number, y:Number, w:Number, h:Number, xHint:Number, yHint:Number, bd:BitmapData)
		{
			_x = x;
			_y = y;
			_w = w;
			_h = h;
			_xHint = xHint;
			_yHint = yHint;
			_bd = bd;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function get bd():BitmapData
		{
			return _bd;
		}
		
		public function get w():Number
		{
			return _w;
		}
		
		public function get h():Number
		{
			return _h;
		}
		
		public function get yHint():Number
		{
			return _yHint;
		}
		
		public function get xHint():Number
		{
			return _xHint;
		}
	}

}