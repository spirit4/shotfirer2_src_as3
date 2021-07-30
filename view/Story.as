package view
{
	import caurina.transitions.Tweener;
	import data.ImageRes;
	import event.WindowEvent;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.Analytics;
	import utils.ButtonLink;
	import utils.TextBox;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Story extends Sprite
	{
		private var _next:ButtonLink;
		private var _continue:ButtonLink;
		private var _eyes:Bitmap;
		private var _frames:Vector.<Sprite> = new Vector.<Sprite>();
		
		public function Story()
		{
			createBg();
			createButtons();
			
			Analytics.pushPage(Analytics.GAME_START);
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			setPositionButtons();
		}
		
		private function setPositionButtons():void
		{
			_next.x = 800 - 110;
			_next.y = 600 - 60;
		}
		
		private function createButtons():void
		{
			_next = new ButtonLink("SKIP", 32);
			addChild(_next);
		}
		
		private function createBg():void
		{
			graphics.beginFill(0x000000, 1);
			graphics.drawRect(0, 0, 800, 600); //no stage
			graphics.endFill();
			
			var bitmap:Bitmap;
			var sprite:Sprite;
			var tf:TextBox;
			sprite = new Sprite();
			addChild(sprite);
			bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_INTRO_1], "auto", true);
			sprite.addChild(bitmap);
			sprite.x = 86 + bitmap.width * 0.5;
			sprite.y = 47 + bitmap.height * 0.5;
			bitmap.x = -bitmap.width >> 1;
			bitmap.y = -bitmap.height >> 1;
			sprite.alpha = 0;
			sprite.scaleX = sprite.scaleY = 0;
			_frames.push(sprite);
			tf = new TextBox(300, 50, 15, 0x111111, "", "Somewhere in the Himalayas...");
			tf.x = -135;
			tf.y = -64;
			sprite.addChild(tf);
			
			sprite = new Sprite();
			addChild(sprite);
			bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_INTRO_2], "auto", true);
			sprite.addChild(bitmap);
			sprite.x = 413 + bitmap.width * 0.5;
			sprite.y = 30 + bitmap.height * 0.5;
			bitmap.x = -bitmap.width >> 1;
			bitmap.y = -bitmap.height >> 1;
			sprite.alpha = 0;
			sprite.scaleX = sprite.scaleY = 0;
			_frames.push(sprite);
			tf = new TextBox(200, 50, 24, 0x111111, "", "Grrr...");
			tf.x = -5;
			tf.y = -101;
			sprite.addChild(tf);
			
			sprite = new Sprite();
			addChild(sprite);
			bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_INTRO_3], "auto", true);
			sprite.addChild(bitmap);
			sprite.x = 43 + bitmap.width * 0.5;
			sprite.y = 214 + bitmap.height * 0.5;
			bitmap.x = -bitmap.width >> 1;
			bitmap.y = -bitmap.height >> 1;
			sprite.alpha = 0;
			sprite.scaleX = sprite.scaleY = 0;
			_frames.push(sprite);
			tf = new TextBox(200, 50, 18, 0x111111, "", "Whoooa. \rI've found it!", "center");
			tf.x = -185;
			tf.y = -130;
			sprite.addChild(tf);
			
			sprite = new Sprite();
			addChild(sprite);
			bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_INTRO_4], "auto", true);
			sprite.addChild(bitmap);
			sprite.x = 432 + bitmap.width * 0.5;
			sprite.y = 310 + bitmap.height * 0.5;
			bitmap.x = -bitmap.width >> 1;
			bitmap.y = -bitmap.height >> 1;
			sprite.alpha = 0;
			sprite.scaleX = sprite.scaleY = 0;
			_frames.push(sprite);
			tf = new TextBox(200, 80, 14, 0x111111, "", "Every gem\rwill be mine!", "center");
			tf.x = -160;
			tf.y = -70;
			sprite.addChild(tf);
			
			bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_INTRO_EYES], "auto", true);
			sprite.addChild(bitmap);
			bitmap.x = 68;
			bitmap.y = 1;
			_eyes = bitmap;
			_eyes.alpha = 0;
			
			showNext(0);
			//addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		//private function clickHandler(e:MouseEvent):void
		//{
		//for (var i:int = 0; i < _frames.length; i++)
		//{
		//if (_frames[i].alpha < 1)
		//{
		//Tweener.removeTweens(_frames[i]);
		//_frames[i].alpha = 1;
		//_frames[i].scaleX = _frames[i].scaleY = 1;
		//showNext(i + 1);
		//return;
		//}
		//}
		//}
		
		private function showNext(currentFrame:int):void
		{
			if (_frames && _frames.length > currentFrame)
				Tweener.addTween(_frames[currentFrame], {scaleX: 1, scaleY: 1, alpha: 1, time: 0.7, delay: currentFrame / currentFrame * 0.9, transition: "easeOutBack", onComplete: showNext, onCompleteParams: [currentFrame + 1]});
			else
				showEyes();
		}
		
		private function showEyes():void
		{
			_next.visible = false;
			Tweener.addTween(_eyes, {alpha: 1, time: 1, transition: "linear", onComplete: addContinue});
		}
		
		private function addContinue():void
		{
			_continue = new ButtonLink("click to continue", 20, 0xFFFFFF, 0xDDDDDD, "left", hideAll);
			_continue.x = 800 - 490;
			_continue.y = 600 - 50;
			addChild(_continue);
			//Tweener.addTween(_continue, {alpha: 1, time: 0.1, transition: "linear", onComplete: hideAll});
		}
		
		private function hideAll(e:MouseEvent = null):void
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0x1D1C10, 0.8);
			shape.graphics.drawRect(0, 0, 800, 600);
			shape.graphics.endFill();
			addChild(shape);
			shape.alpha = 0;
			
			//Tweener.addTween(_frames[1], {alpha: 0, time: 1, transition: "linear"});
			//Tweener.addTween(_frames[2], {alpha: 0, time: 1, transition: "linear"});
			//Tweener.addTween(_frames[3], {alpha: 0, time: 1, transition: "linear"});
			Tweener.addTween(shape, {alpha: 1, time: 0.7, transition: "linear", onComplete: goToFurther});
		}
		
		private function goToFurther():void
		{
			dispatchEvent(new WindowEvent(WindowEvent.INTRO_DONE));
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			//removeEventListener(MouseEvent.CLICK, clickHandler);
			
			for (var i:int = 0; i < _frames.length; i++)
			{
				Tweener.removeTweens(_frames[i]);
			}
			Tweener.removeTweens(_eyes);
			
			while (numChildren)
				removeChildAt(0);
			
			_frames.length = 0;
			_frames = null;
			
			_continue = null;
			_next = null;
			_eyes = null;
		}
		
		public function get next():ButtonLink
		{
			return _next;
		}
	}

}