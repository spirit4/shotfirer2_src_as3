package utils
{
	import data.ImageRes;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import utils.TextBox;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class ScoreBox extends Sprite 
	{
		private var _score:TextBox;
		
		public function ScoreBox(color:uint = 0xFEFF00, size:int = 16)
		{
			const bg:Bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_COINS]);
			addChild(bg);
			
			_score = new TextBox(100, 30, size, color, "", "0", "left", true);
			addChild(_score);
			_score.x = 30;
			_score.y = 1;
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		public function updateScore(score:uint):void
		{
			_score.text = score.toString();
		}
		
		protected function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			while (numChildren)
				removeChildAt(0);
			
			_score = null;
		}
	}
	
}