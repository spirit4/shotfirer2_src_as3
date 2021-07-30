package view
{
	import data.AnimationRes;
	import data.ImageRes;
	import data.PreloaderRes;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import utils.Analytics;
	import utils.BitmapClip;
	import utils.ButtonImage;
	import utils.ButtonLink;
	import utils.ButtonSoundImage;
	import utils.IUpdatable;
	import utils.TextBox;
	import view.hints.Reminder;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class MainMenu extends Sprite implements IUpdatable
	{
		private var _sound:ButtonSoundImage;
		private var _music:ButtonSoundImage;
		private var _play:ButtonImage;
		private var _more:ButtonImage;
		private var _credits:ButtonImage;
		private var _reset:ButtonImage;
		
		private var _resetPopup:Sprite;
		
		private var _bgLayerBottom:Bitmap;
		private var _bgLayerMid:Bitmap;
		private var _bgLayerTop:Bitmap;
		
		private var _flame:BitmapClip;
		
		public function MainMenu()
		{
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
			
			setPositionButtons();
		}
		
		private function setPositionButtons():void
		{
			_reset.x = 20;
			_reset.y = 20;
			
			_sound.x = 800 - _sound.width * 0.5 - 8;
			_sound.y = 8 + _sound.height * 0.5;
			
			_music.x = 800 - _music.width * 0.5 - 8;
			_music.y = _sound.height * 1.5 + 16;
			
			_play.x = 550;
			_play.y = 600 - 170;
			
			_more.x = _play.x + 140;
			_more.y = _play.y;
			
			_credits.x = _play.x - 140;
			_credits.y = _play.y;
			
			_play.clasp();
			
			CONFIG::debug
			{
				PreloaderRes.init();
			}
			
			AnimationRes.animReses.push(PreloaderRes.preloaderImages[3]);
			_flame = new BitmapClip(new <uint>[AnimationRes.animReses.length - 1], new <Array>[null], new Rectangle(0, 0, 64, 64));
			addChild(_flame);
			_flame.x = 291;
			_flame.y = 215;
			_flame.play();
			
			Controller.juggler.add(this);
		}
		
		public function update():void
		{
			_bgLayerTop.x = -10 * (stage.mouseX - 400) / 400 - 35;
			_flame.x = -10 * (stage.mouseX - 400) / 400 + 291 - 10;
			_bgLayerMid.x = -8 * (stage.mouseX - 400) / 400 - 800 + _bgLayerMid.width + 8;
			_bgLayerBottom.x = -6 * (stage.mouseX - 400) / 400 - 16;
			
			_bgLayerTop.y = -8 * (stage.mouseY - 300) / 300 + (600 - _bgLayerTop.height + 8);
			_flame.y = -8 * (stage.mouseY - 300) / 300 + 218 + 8;
			_bgLayerMid.y = -6 * (stage.mouseY - 300) / 300 + (600 - _bgLayerMid.height + 6);
			_bgLayerBottom.y = -4 * (stage.mouseY - 300) / 300 - 14;
		}
		
		private function createButtons():void
		{
			_sound = new ButtonSoundImage(ImageRes.buttonImages[ImageRes.BUTTON_SOUND_ON], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_OFF], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_ON_HOVER], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_OFF_HOVER])
			addChild(_sound);
			
			_music = new ButtonSoundImage(ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_ON], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_OFF], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_ON_HOVER], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_OFF_HOVER], true)
			addChild(_music);
			
			_reset = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_RESET], ImageRes.buttonImages[ImageRes.BUTTON_RESET_HOVER], true)
			addChild(_reset);
			_reset.addEventListener(MouseEvent.CLICK, resetHandler);
			
			_play = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_PLAY], ImageRes.buttonImages[ImageRes.BUTTON_PLAY_HOVER], true)
			addChild(_play);
			
			_more = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_MORE], ImageRes.buttonImages[ImageRes.BUTTON_MORE_HOVER], true)
			addChild(_more);
			//_more.addEventListener(MouseEvent.CLICK, Branding.moreHandler);
			
			_credits = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_CREDITS], ImageRes.buttonImages[ImageRes.BUTTON_CREDITS_HOVER], true)
			addChild(_credits);
		}
		
		private function resetHandler(e:MouseEvent):void 
		{
			_resetPopup = new Sprite()
			addChild(_resetPopup);
			
			_resetPopup.graphics.beginFill(0x1D1C10, 0.8);
			_resetPopup.graphics.drawRect(0, 0, 800, 600);
			_resetPopup.graphics.endFill();
			
			const bitmap:Bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_HELP_BG]);
			_resetPopup.addChild(bitmap);
			bitmap.x = 220;
			bitmap.y = 170;
			
			var tf:TextBox;
			tf = new TextBox(280, 30, 18, 0x433C2C, "", "Are you sure you want reset the entire game progress?", "center", true);
			_resetPopup.addChild(tf);
			tf.x = bitmap.x + 15;
			tf.y = bitmap.y + 30;
			
			var button:ButtonLink
			button = new ButtonLink("Yes", 20, 0x433C2C, 0x833C2C, "left", hidePopup);
			button.x = bitmap.x + 70;
			button.y = bitmap.y + 120;
			button.name = "Yes"
			_resetPopup.addChild(button);
			
			button = new ButtonLink("No", 20, 0x433C2C, 0x833C2C, "left", hidePopup);
			button.x = bitmap.x + 190;
			button.y = bitmap.y + 120;
			button.name = "No"
			_resetPopup.addChild(button);
		}
		
		private function hidePopup(e:MouseEvent):void
		{
			if (e.target.name == "Yes")
			{
				Controller.model.clearSharedObject();
				this.addChild(new Reminder("Game progress has been deleted", Reminder.GET_UP, 3));
				Analytics.pushPage(Analytics.CLICK_RESET_PROGRESS);
			}
			
			_resetPopup.graphics.clear();
			_resetPopup.removeChildren();
			_resetPopup = null;
		}
		
		private function createBg():void
		{
			var bitmap:Bitmap;
			bitmap = new Bitmap(ImageRes.backgrounds[ImageRes.MAIN_MENU_0]);
			addChildAt(bitmap, 0);
			_bgLayerBottom = bitmap;
			bitmap.x = -6;
			bitmap.y = -4;
			
			bitmap = new Bitmap(ImageRes.backgrounds[ImageRes.MAIN_MENU_1]);
			addChildAt(bitmap, 1);
			_bgLayerMid = bitmap;
			bitmap.x = 800 - bitmap.width + 10;
			bitmap.y = 600 - bitmap.height + 8;
			
			bitmap = new Bitmap(ImageRes.backgrounds[ImageRes.MAIN_MENU_2]);
			addChildAt(bitmap, 2);
			_bgLayerTop = bitmap;
			bitmap.x = -25 - 10;
			bitmap.y = 600 - bitmap.height + 8;
			
			const version:TextBox = new TextBox(60, 20, 12, 0xC29E60, "", Analytics.instance.gameVersion, "left", true);
			addChild(version);
			version.x = 3;
			version.y = 580;
			version.mouseEnabled = false;
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			Controller.juggler.remove(this);
			
			while (numChildren)
				removeChildAt(0);
			
			_resetPopup = null;
			_reset = null;
			_music = null;
			_sound = null;
			_play = null;
			_more = null;
			_credits = null;
			_flame = null;
			_bgLayerBottom = null;
			_bgLayerMid = null;
			_bgLayerTop = null;
		}
		
		public function get credits():ButtonImage
		{
			return _credits;
		}
		
		public function get play():ButtonImage
		{
			return _play;
		}
		
		public function get sound():ButtonSoundImage
		{
			return _sound;
		}
	}

}