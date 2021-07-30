package view
{
	import caurina.transitions.Tweener;
	import data.AchievementController;
	import data.AnimationRes;
	import data.Behavior;
	import data.ImageRes;
	import data.Progress;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.Analytics;
	import utils.BitmapClip;
	import utils.ButtonImage;
	import utils.Statistics;
	import utils.TextBox;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Victory extends Sprite
	{
		private var _reset:ButtonImage;
		private var _next:ButtonImage;
		private var _shop:ButtonImage;
		private var _progress:Progress;
		
		private var _starOnLvl:int = 0;
		
		private var _anim:Bitmap;
		private var _bd1:BitmapData;
		private var _bd2:BitmapData;
		
		public function Victory(progress:Progress)
		{
			_progress = progress;
			_starOnLvl = _progress.currentStar;
			
			Analytics.pushPage(Analytics.LEVEL_END, (_progress.currentLevel + 1).toString());
			Statistics.tntPerLvl = Behavior.tntToLevels[_progress.currentLevel] - _progress.currentTNT;
			
			if (Statistics.jumpAuto > 0)
				Analytics.pushEvent(Analytics.JUMP_AUTO, "CURRENT_LVL-" + (_progress.currentLevel + 1), Statistics.jumpAuto);
			
			if (Statistics.crawlAuto > 0)
				Analytics.pushEvent(Analytics.CRAWL_AUTO, "CURRENT_LVL-" + (_progress.currentLevel + 1), Statistics.crawlAuto);
			
			if (Statistics.crawlButton > 0)
				Analytics.pushEvent(Analytics.CRAWL_BUTTON, "CURRENT_LVL-" + (_progress.currentLevel + 1), Statistics.crawlButton);
			
			if (Statistics.tntPerLvl > 0)
				Analytics.pushEvent(Analytics.TNT_PER_LVL, "CURRENT_LVL-" + (_progress.currentLevel + 1), Statistics.tntPerLvl);
			
			if (Statistics.tntSpace > 0)
				Analytics.pushEvent(Analytics.TNT_SET_SPACE, "CURRENT_LVL-" + (_progress.currentLevel + 1), Statistics.tntSpace);
			
			if (Statistics.tntCtrl > 0)
				Analytics.pushEvent(Analytics.TNT_SET_CTRL, "CURRENT_LVL-" + (_progress.currentLevel + 1), Statistics.tntCtrl);
			
			if (Statistics.tntZ > 0)
				Analytics.pushEvent(Analytics.TNT_SET_Z, "CURRENT_LVL-" + (_progress.currentLevel + 1), Statistics.tntZ);
			
			Analytics.pushEvent(Analytics.LVL_RETRIES, "CURRENT_LVL-" + (_progress.currentLevel + 1), Statistics.lvlRetries);
			
			if (_progress.starToLevels[_progress.currentLevel] < _starOnLvl)
				_progress.starToLevels[_progress.currentLevel] = _starOnLvl;
			
			_progress.allStar = 0;
			_progress.totalMoney += _progress.moneyAtLevel;
			_progress.moneyAtLevel = 0;
			
			for each (var stars:uint in _progress.starToLevels)
			{
				_progress.allStar += stars;
			}
			
			//ApiKG.sendLevels(_progress.currentLevel + 1);
			//ApiKG.sendRubies(_progress.allStar);
			
			createBg();
			createButtons();
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_LEVEL_COMPLETE);
			
			//if (Branding.isConnectedKGorNG)
			//Branding.submitScoreHandler();
			
			setPositionButtons();
			createAnimations();
			
			AchievementController.getInstance().addParam(AchievementController.COMPLETE_LVL);
		}
		
		private function setPositionButtons():void
		{
			_next.x = 400;
			_next.y = 600;
			
			_shop.x = _next.x + 140;
			_shop.y = 600;
			
			_reset.x = _next.x - 140;
			_reset.y = 600;
			
			const y0:Number = 470;
			const y1:Number = y0; // + (_next.height - _shop.height) / 2;
			const y2:Number = y0; // + (_next.height - _reset.height) / 2;
			Tweener.addTween(_next, {y: y0, time: 0.3, delay: 0.2, transition: "easeOutBack"});
			Tweener.addTween(_shop, {y: y1, time: 0.3, delay: 0.4, transition: "easeOutBack"});
			Tweener.addTween(_reset, {y: y2, time: 0.3, delay: 0, transition: "easeOutBack"});
			_next.clasp();
		}
		
		private function createButtons():void
		{
			_reset = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_LVL_RESTART], ImageRes.buttonImages[ImageRes.BUTTON_LVL_RESTART_HOVER], true)
			addChild(_reset);
			
			_next = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_PLAY], ImageRes.buttonImages[ImageRes.BUTTON_PLAY_HOVER], true)
			addChild(_next);
			//_next.addEventListener(MouseEvent.CLICK, nextClickhandler);
			
			_shop = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_SHOP], ImageRes.buttonImages[ImageRes.BUTTON_SHOP_HOVER], true)
			addChild(_shop);
		}
		
		private function createAnimations():void
		{
			const sprite:Sprite = new Sprite();
			addChild(sprite);
			
			var bitmap:Bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_COMPLETE]);
			sprite.addChild(bitmap);
			sprite.x = int(800 - bitmap.width * 0.1 >> 1);
			sprite.y = int(180 + bitmap.height * 0.5);
			sprite.scaleX = sprite.scaleY = 0.1;
			Tweener.addTween(sprite, {x: (800 - 238 >> 1), y: 180, scaleX: 1, scaleY: 1, time: 0.4, transition: "easeOutBack"});
			
			var tf:TextBox = new TextBox(238, 80, 72, 0xF0EEC7, "", "Level", "center", true);
			sprite.addChild(tf);
			tf.x = 0;
			tf.y = 1;
			tf.mouseEnabled = false;
			tf.changeParams(0, 0);
			
			tf = new TextBox(200, 46, 24, 0x3B3B1F, "", "complete!", "center", true);
			sprite.addChild(tf);
			tf.x = 20;
			tf.y = 72;
			tf.mouseEnabled = false;
			
			var rubin:BitmapClip
			var slot:Bitmap
			for (var i:int = 0; i < 3; i++)
			{
				if (_starOnLvl > i)
				{
					rubin = new BitmapClip(new <uint>[AnimationRes.LEVEL_RUBIN], new <Array>[null], new Rectangle(0, 0, 64, 64));
					sprite.addChild(rubin);
					rubin.alpha = 0;
					rubin.play(AnimationRes.LEVEL_RUBIN, false);
					rubin.stop();
					rubin.x = 27 + 61 * i;
					rubin.y = 90;
					Tweener.addTween(rubin, {y: 100, alpha: 1, time: 0, delay: (0.4 + 0.2 * i), transition: "easeOutSine", onComplete: rubinHandler, onCompleteParams: [rubin]});
				}
				else
				{
					slot = new Bitmap(ImageRes.elementImages[ImageRes.EL_LEVEL_RUBY_SLOT]);
					sprite.addChild(slot);
					slot.x = 32 + 63 * i;
					slot.y = 115;
				}
			}
			_bd1 = ImageRes.elementImages[ImageRes.EL_VICTORY_RUBY_0_0 + _starOnLvl * 2];
			_bd2 = ImageRes.elementImages[ImageRes.EL_VICTORY_RUBY_0_0 + _starOnLvl * 2 + 1];
			_anim = new Bitmap(_bd2);
			sprite.addChild(_anim);
			_anim.x = 104;
			_anim.y = -102;
			changeFrame();
		}
		
		private function changeFrame():void
		{
			if (_anim.bitmapData == _bd2)
				_anim.bitmapData = _bd1;
			else
				_anim.bitmapData = _bd2
			
			Tweener.addTween(_anim, {alpha: 1, time: 0.35, transition: "linear", onComplete: changeFrame});
		}
		
		private function rubinHandler(rubin:BitmapClip):void
		{
			SoundManager.getInstance().playSFX(SoundRes.SFX_GET_GEM);
			rubin.play(AnimationRes.LEVEL_RUBIN, false);
		
			//Controller.juggler.add(rubin); //remove auto
		}
		
		private function createBg():void
		{
			const shape:Shape = new Shape();
			addChild(shape);
			shape.graphics.beginFill(0x10100E, 0.95);
			shape.graphics.drawRect(0, 0, 800, 600); //no stage
			shape.graphics.endFill();
			shape.alpha = 0;
			
			Tweener.addTween(shape, {alpha: 1, time: 0.3, transition: "linear"});
		}
		
		//for keyboard
		public function nextClickhandler(e:MouseEvent = null):void
		{
			//if (e)
			//e.stopPropagation();
			//
			//_next.removeEventListener(MouseEvent.CLICK, nextClickhandler);
			
			//if (Branding.isKGorNG)
			//{
			_next.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true));
			//return;//-------------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			//}
		
			//if (SoundManager.getInstance().isMusic)
			//{
			////SoundManager.getInstance().muteOnOff();
			//_prevMusicState = true;
			//}
		
			//Branding.isShowingAds = true;
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_next.removeEventListener(MouseEvent.CLICK, nextClickhandler);
			
			while (numChildren)
				removeChildAt(0);
			
			_progress = null;
			_shop = null;
			_reset = null;
			_next = null;
		}
		
		public function get shop():ButtonImage
		{
			return _shop;
		}
		
		public function get next():ButtonImage
		{
			return _next;
		}
		
		public function get reset():ButtonImage
		{
			return _reset;
		}
	}

}