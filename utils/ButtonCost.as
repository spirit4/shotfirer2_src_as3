package utils
{
	import data.ImageRes;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class ButtonCost extends ButtonImage
	{
		private var _tf:TextBox;
		
		private var _isActive:Boolean = true;
		
		public function ButtonCost(image:BitmapData, imageHover:BitmapData = null, isAnimation:Boolean = false)
		{
			super(image, imageHover, isAnimation);

				_tf = new TextBox(80, 20, 24, 0x4C4C19, "", "0", "left", true);
				addChild(_tf);
				_tf.x = -25;
				_tf.y = -16;

		}
		
		public function updateCost(cost:int):void
		{
			if (cost == -1)
				_tf.text = "MAX!"
			else
				_tf.text = cost.toString();
		}
		
		override protected function destroy(e:Event):void
		{
			super.destroy(e);
			
			while (numChildren)
				removeChildAt(0);
			
			_tf = null;
		}
		
		public function set isActive(value:Boolean):void 
		{
			_isActive = value;
			if (!_isActive)
			{
				this.mouseEnabled = false;
				Functions.doGrayColor2(this);
			}
		}
	}

}