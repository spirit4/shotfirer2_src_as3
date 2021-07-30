package data
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class PreloaderRes
	{
		[Embed(source="../../images/bg/PriBack.png")]
		private static var ResBg:Class;
		[Embed(source="../../images/elements/Fitil3.png")]
		private static var ResFuse0:Class;
		[Embed(source="../../images/elements/Fitil2.png")]
		private static var ResFuse1:Class;
		[Embed(source="../../images/animation/Fire-64x64.png")]
		private static var ResFlame:Class;
		
		[Embed(source="../../images/animation/HeroRunRight-48x64.png")]
		private static var ResHeroRun:Class;
		
		[Embed(source="../../images/buttons/ButPlay.png")]
		public static var ResPlayNormal:Class;
		[Embed(source="../../images/buttons/ButPlayActiv.png")]
		public static var ResPlayHover:Class;
		
		static public var preloaderImages:Vector.<BitmapData> = new Vector.<BitmapData>(7);
		
		public function PreloaderRes()
		{
		
		}
		
		static public function init():void
		{
			preloaderImages[0] = (new ResBg as Bitmap).bitmapData;
			preloaderImages[1] = (new ResFuse0 as Bitmap).bitmapData;
			preloaderImages[2] = (new ResFuse1 as Bitmap).bitmapData;
			preloaderImages[3] = (new ResFlame as Bitmap).bitmapData;
			preloaderImages[4] = (new ResPlayNormal as Bitmap).bitmapData;
			preloaderImages[5] = (new ResPlayHover as Bitmap).bitmapData;
			preloaderImages[6] = (new ResHeroRun as Bitmap).bitmapData;
		}
		
		static public function destroy():void
		{
			for (var i:int = 0; i < 3; i++)
			{
				if (preloaderImages[i]) //without preloader
					preloaderImages[i].dispose();
					preloaderImages[i] = null;
			}
			//preloaderImages.length = 0;
			//preloaderImages = null;
			if (preloaderImages[6]) //without preloader
				preloaderImages[6].dispose();
				preloaderImages[6] = null;
		}
	}
}