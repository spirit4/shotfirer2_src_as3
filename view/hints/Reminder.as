package view.hints
{
	import caurina.transitions.Tweener;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import utils.TextBox;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Reminder extends Sprite
	{
		static public const GET_UP:int = 0;
		static public const JUMP:int = 1;
		
		public function Reminder(text:String, type:int, time1:Number, time2:Number = 1)
		{
			mouseChildren = false;
			mouseEnabled = false;
			
			changeEffect(text, type, time1, time2);
		}
		
		private function changeEffect(text:String, type:int, time1:Number, time2:Number):void
		{
			switch (type)
			{
				case GET_UP: 
					useGetUp(text, time1);
					break;
				case JUMP: 
					useJump(text, time1, time2);
					break;
			}
		}
		
		private function useGetUp(text:String, time1:Number):void
		{
			const shout:TextBox = new TextBox(400, 40, 36, 0xFFFFFF, "", text, "center", true, false);
			addChild(shout);
			shout.x = -shout.width / 2;
			shout.y = -shout.height / 2;
			
			this.x = (800 - this.width) / 2 + shout.width / 2;
			this.y = (600 - this.height) / 2 + 40;
			
			Tweener.addTween(this, {y: this.y - 140, alpha: 0, time: time1, transition: "linear", onComplete: removeThis});
		}
		
		public function useJump(text:String, time1:Number, time2:Number):void
		{
			const shout:TextBox = new TextBox(400, 30, 26, 0xD20606, "", text, "center", true, false, [new DropShadowFilter(0, 0, 0xFFFFFF, 1, 2, 2, 20, 2)]);
			addChild(shout);
			shout.x = -shout.width / 2;
			shout.y = -shout.height / 2;
			
			this.x = (800 - this.width) / 2 + shout.width / 2;
			this.y = (600 - this.height) / 2 - shout.height / 2;
			
			this.scaleX = this.scaleY = 0.2;
			Tweener.addTween(this, {scaleX: 1.5, scaleY: 1.5, time: time1, transition: "easeOutElastic"});
			Tweener.addTween(this, {scaleX: 2.8, scaleY: 2.8, alpha: 0, time: time2, delay: time1, transition: "linear", onComplete: removeThis});
		}
		
		private function removeThis():void
		{
			if (parent)
				parent.removeChild(this);
		}
	
	}

}