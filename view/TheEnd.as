package view
{
	import caurina.transitions.Tweener;
	import data.AchievementController;
	import data.AnimationRes;
	import data.ImageRes;
	import data.Progress;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.Analytics;
	import utils.BitmapClip;
	import utils.ButtonImage;
	import utils.ScoreBox;
	import utils.TextBox;
	import utils.TimeUtils;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class TheEnd extends Sprite
	{
		private var _play:ButtonImage;
		private var _star:BitmapClip;
		private var _points:Vector.<Point>;
		
		private var _progress:Progress;
		
		public function TheEnd(progress:Progress)
		{
			_progress = progress;
			
			_progress.totalMoney += _progress.moneyAtLevel;
			_progress.moneyAtLevel = 0;
			
			createBg();
			createButtons();
			
			Analytics.pushPage(Analytics.GAME_END);
			
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
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_GAME_COMPLETE);
			AchievementController.getInstance().addParam(AchievementController.COMPLETE_LVL);
			
			createStar();
		}
		
		private function setPositionButtons():void
		{
			_play.x = 570;
			_play.y = 490;
		}
		
		private function createButtons():void
		{
			_play = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_PLAY], ImageRes.buttonImages[ImageRes.BUTTON_PLAY_HOVER], true)
			addChild(_play);
		}
		
		private function createBg():void
		{
			var bitmap:Bitmap;
			
			bitmap = new Bitmap(ImageRes.backgrounds[ImageRes.COMPLETE]);
			addChild(bitmap);
			
			const text:String = "You have found\rthe big piece of gold.\rMEEEOW!";
			var tf:TextBox = new TextBox(400, 80, 28, 0xFFFFFF, "", text, "center", true);
			addChild(tf);
			tf.x = 370;
			tf.y = 140;
			tf.mouseEnabled = false;
			
			tf = new TextBox(150, 40, 20, 0xFFFFFF, "", "Spent time:", "left", true);
			addChild(tf);
			tf.x = 440;
			tf.y = 300;
			tf.mouseEnabled = false;
			
			tf = new TextBox(150, 40, 20, 0x54CE45, "", TimeUtils.getTimeString(int(_progress.spentTime / 1000)), "left", true);
			addChild(tf);
			tf.x = 580;
			tf.y = 300;
			tf.mouseEnabled = false;
			
			tf = new TextBox(200, 40, 20, 0xFFFFFF, "", "Earned money:", "left", true);
			addChild(tf);
			tf.x = 440;
			tf.y = 340;
			tf.mouseEnabled = false;
			
			const box:ScoreBox = new ScoreBox(0xF6D850, 20);
			addChild(box);
			box.x = 620;
			box.y = 340;
			box.updateScore(_progress.totalMoney);
			
		}
		
		private function createStar():void
		{
			_points = new <Point>[new Point(326, 201), new Point(160, 340), new Point(191, 410)];
			
			_star = new BitmapClip(new <uint>[AnimationRes.STAR], new <Array>[null], new Rectangle(0, 0, 50, 50));
			_star.play(AnimationRes.STAR, false);
			addChild(_star);
			_star.x = _points[0].x;
			_star.y = _points[0].y;
			
			_star.addEventListener(Event.COMPLETE, completeHandler);
		}
		
		private function completeHandler(e:Event):void
		{
			_star.removeEventListener(Event.COMPLETE, completeHandler);
			
			_star.visible = false;
			
			Controller.juggler.addCall(playStar, 70 / 60);
		}
		
		private function playStar():void
		{
			Controller.juggler.removeCall(playStar);
			const index:int = int(Math.random() * 3);
			_star.x = _points[index].x;
			_star.y = _points[index].y;
			
			_star.visible = true;
			_star.play(AnimationRes.STAR, false);
			
			_star.addEventListener(Event.COMPLETE, completeHandler);
		}
		
		//private function loop(sprite:Sprite):void
		//{
			//Tweener.addTween(sprite, {rotation: 360, time: 8, transition: "linear", onComplete: loop, onCompleteParams: [sprite]});
		//}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			_star.removeEventListener(Event.COMPLETE, completeHandler);
			
			Controller.juggler.removeCall(playStar);
			
			while (numChildren)
				removeChildAt(0);
			
			_play = null;
			_star = null;
			
			_points.length = 0;
			_points = null;
		}
		
		public function get back():ButtonImage
		{
			return _play;
		}
	
	}

}