package view
{
	import data.ImageRes;
	import data.JSONRes;
	import data.Progress;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import utils.ButtonImage;
	import utils.ButtonSoundImage;
	import utils.ButtonTab;
	import utils.Functions;
	import utils.ScrollBoxFixed;
	import utils.TextBox;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Achievements extends Sprite
	{
		//private var _logo:SimpleButton;
		
		private var _back:ButtonImage;
		private var _levels:ButtonImage;
		private var _shop:ButtonImage;
		
		private var _sound:ButtonSoundImage;
		private var _music:ButtonSoundImage;
		
		private var _progress:Progress;
		private var _lists:Dictionary /*Sprite*/ = new Dictionary();
		
		public function Achievements(progress:Progress)
		{
			_progress = progress;
			
			createBg();
			createButtons();
			
			Controller.juggler.addCall(doInNextFrame, 1 / 60);
			
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
		
		private function doInNextFrame():void
		{
			Controller.juggler.removeCall(doInNextFrame);
			createIcons();
		}
		
		private function createIcons():void
		{
			const list:Array = JSONRes.jsonAch;
			var tf:TextBox;
			var bitmap:Bitmap;
			var sprite:Sprite;
			var items:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			
			const len:int = ImageRes.achAlphaImages.length;
			for (var i:int = 0; i < len; i++)
			{
				sprite = new Sprite();
				bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_ACH_ITEM]);
				sprite.addChild(bitmap);
				
				bitmap = new Bitmap(ImageRes.achAlphaImages[i]);
				sprite.addChild(bitmap);
				bitmap.x = 5;
				bitmap.y = 7;
				
				tf = new TextBox(225, 40, 16, 0x433C2C, "", "", "left", false);
				sprite.addChild(tf);
				tf.htmlText = '<b>' + list[i].title + '</b>\r<FONT SIZE="13">' + list[i].text + '</FONT>';
				tf.x = 80;
				tf.y = 8;
				
				if (_progress.achievements[i] < 777)
				{
					tf.changeTextFormat(false, 0x555555);
					tf.alpha = 0.8;
					
					Functions.doGrayColor(bitmap);
					bitmap.alpha = 0.8;
					
					if (i == 10 || i == 11 || i == 12 || i == 24 || i == 25)
					{
						bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_ACH_BG_COUNTER]);
						sprite.addChild(bitmap);
						bitmap.x = 52;
						bitmap.y = 6;
						
						tf = new TextBox(30, 30, 14, 0x130302, "", _progress.achievements[i].toString(), "center", false);
						sprite.addChild(tf);
						tf.x = 49;
						tf.y = 8;
					}
				}
				
				items.push(sprite as DisplayObject);
			}
			
			const scrollBox:ScrollBoxFixed = new ScrollBoxFixed(items, 2, true, 7, 5);
			addChild(scrollBox);
			scrollBox.x = 31;
			scrollBox.y = 64;
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			const tab:ButtonTab = e.currentTarget as ButtonTab;
			if (!_lists[tab].visible)
			{
				for each (var sprite:Sprite in _lists)
				{
					sprite.visible = false;
				}
				for (var i:int = 0; i < numChildren; i++)
				{
					if (getChildAt(i) is ButtonTab)
						(getChildAt(i) as ButtonTab).isActive = false;
				}
				
				_lists[tab].visible = true;
				tab.isActive = true;
			}
		}
		
		private function setPositionButtons():void
		{
			_sound.x = 800 - _sound.width * 0.5 - 8;
			_sound.y = 8 + _sound.height * 0.5;
			
			_music.x = 800 - _music.width * 0.5 - 8;
			_music.y = _sound.height * 1.5 + 16;
			
			_levels.x = 400;
			_levels.y = 540;
			
			_back.x = _levels.x - 240;
			_back.y = _levels.y;
			
			_shop.x = _levels.x + 240;
			_shop.y = _levels.y;
			
			const tntLvl:int = _progress.tntLevel == _progress.tntCosts.length - 1 ? _progress.tntLevel : _progress.tntLevel + 1;
			const radarLvl:int = _progress.radarLevel == _progress.radarCosts.length - 1 ? _progress.radarLevel : _progress.radarLevel+1;
			const batteryLvl:int = _progress.batteryLevel == _progress.batteryNumber.length - 1 ? _progress.batteryLevel : _progress.batteryLevel+1;
			
			const min:int = Math.min(_progress.tntCosts[tntLvl], _progress.radarCosts[radarLvl], _progress.batteryCosts[batteryLvl]);
			if (_progress.totalMoney >= min) 
			{
				const mark:Bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_SHOP_BUTTON_MARK]);
				addChild(mark);
				mark.x = _shop.x + 22;
				mark.y = _shop.y - 57;	
			}
		}
		
		private function createButtons():void
		{
			_sound = new ButtonSoundImage(ImageRes.buttonImages[ImageRes.BUTTON_SOUND_ON], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_OFF], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_ON_HOVER], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_OFF_HOVER]);
			addChild(_sound);
			
			_music = new ButtonSoundImage(ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_ON], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_OFF], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_ON_HOVER], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_OFF_HOVER], true);
			addChild(_music);
			
			_back = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_BACK], ImageRes.buttonImages[ImageRes.BUTTON_BACK_HOVER], true);
			addChild(_back);
			
			_levels = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_LEVELS], ImageRes.buttonImages[ImageRes.BUTTON_LEVELS_HOVER], true);
			addChild(_levels);
			
			_shop = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_SHOP], ImageRes.buttonImages[ImageRes.BUTTON_SHOP_HOVER], true);
			addChild(_shop);
		}
		
		private function createBg():void
		{
			var bitmap:Bitmap = new Bitmap(ImageRes.backgrounds[ImageRes.LEVELS]);
			addChildAt(bitmap, 0);
			
			bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_ACH_BG]);
			addChildAt(bitmap, 1);
			bitmap.x = 800 - bitmap.width >> 1;
			bitmap.y = 40;
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			//_logo.removeEventListener(MouseEvent.CLICK, Branding.logoHandler);
			
			while (numChildren)
				removeChildAt(0);
			
			_lists = null;
			_progress = null;
			_back = null;
			_shop = null;
			_levels = null;
			_sound = null;
			_music = null;
		}
		
		public function get sound():ButtonSoundImage
		{
			return _sound;
		}
		
		public function get back():ButtonImage
		{
			return _back;
		}
		
		public function get levels():ButtonImage
		{
			return _levels;
		}
		
		public function get shop():ButtonImage
		{
			return _shop;
		}
	
	}

}