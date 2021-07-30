package view
{
	import caurina.transitions.Tweener;
	import data.ImageRes;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.Analytics;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Credits extends Sprite
	{
		
		public function Credits()
		{
			createBg();
			createButtons();
			
			//Analytics.pushPage(Analytics.CLICK_CREDITS);
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function createButtons():void
		{
			this.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			Tweener.addTween(getChildAt(1), {y: 600, time: 0.4, transition: "easeOutQuart", onComplete: completeHandler});
		}
		
		private function completeHandler():void
		{
			parent.parent.removeChild(this.parent);
		}
		
		private function createBg():void
		{
			const shape:Shape = new Shape();
			addChild(shape);
			shape.graphics.beginFill(0x1d1a13, 0);
			shape.graphics.drawRect(0, 0, 800, 600); //no stage
			shape.graphics.endFill();
			
			const sprite:Sprite = new Sprite();
			addChild(sprite);
			const bitmap:Bitmap = new Bitmap(ImageRes.backgrounds[ImageRes.CREDITS]);
			sprite.addChild(bitmap);
			sprite.y = 600;
			
			Tweener.addTween(sprite, {y: (600 - bitmap.height), time: 0.4, transition: "easeInQuart"});
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			this.removeEventListener(MouseEvent.CLICK, clickHandler);
			
			while (numChildren)
				removeChildAt(0);
		}
	}

}