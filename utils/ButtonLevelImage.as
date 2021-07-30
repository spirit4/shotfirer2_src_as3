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
	public class ButtonLevelImage extends ButtonImage
	{
		private var _tf:TextBox;
		
		private var _rubins:Sprite;
		
		private var _stars:int;
		
		public function ButtonLevelImage(stars:int, title:String, image:BitmapData, imageHover:BitmapData = null, isAnimation:Boolean = false)
		{
			super(image, imageHover, isAnimation);
			_stars = stars;
			
			var bitmap:Bitmap;
			if (title != Controller.model.progress.numberLevels.toString())
			{
				_tf = new TextBox(image.width, image.height, 42, 0x3e3d26, "", title, "center", true);
				_tf.x = -image.width >> 1;
				_tf.y = -32;
				
				addChild(_tf);
				_tf.mouseEnabled = false;
			}
			else 
			{
				if(Controller.model.progress.isGameComplete)
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_LEVELS_IDOL], "auto", true);
				else
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_LEVELS_IDOL_BACK], "auto", true);
					
				addChild(bitmap);
				bitmap.x = -bitmap.width >> 1;
				bitmap.y = -28;
			}
			
			_rubins = new Sprite();
			addChild(_rubins);
			_rubins.x = -26;
			_rubins.y = 15;
			_rubins.mouseEnabled = false;
			_rubins.mouseChildren = false;
			
			var rubin:Bitmap;
			for (var i:int = 0; i < 3; i++)
			{
				if (_stars > i)
					rubin = new Bitmap(ImageRes.elementImages[ImageRes.EL_RUBIN], "auto", true);
				else
					rubin = new Bitmap(ImageRes.elementImages[ImageRes.EL_RUBIN_BACK], "auto", true);
				
				_rubins.addChild(rubin);
				rubin.x = i * 18;
			}
		}
		
		override protected function destroy(e:Event):void
		{
			while (_rubins.numChildren)
				_rubins.removeChildAt(0);
			
			super.destroy(e);
			
			while (numChildren)
				removeChildAt(0);
			
			_rubins = null;
			_tf = null;
		}
	}

}