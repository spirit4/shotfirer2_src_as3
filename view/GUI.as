package view
{
	import caurina.transitions.Tweener;
	import data.AchievementController;
	import data.Behavior;
	import data.ImageRes;
	import data.Progress;
	import event.GameEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.ButtonImage;
	import utils.ButtonSoundImage;
	import utils.ButtonStateImage;
	import utils.Functions;
	import utils.TextBox;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class GUI extends Sprite
	{
		private var _reset:ButtonImage;
		private var _pause:ButtonImage;
		private var _menu:ButtonImage;
		private var _options:ButtonStateImage;
		private var _sound:ButtonSoundImage;
		private var _music:ButtonSoundImage;
		private var _buttonBox:Sprite;
		
		private var _tnt:TextBox;
		private var _bonusTNT:TextBox;
		private var _level:TextBox;
		private var _money:TextBox;
		private var _battery:TextBox;
		
		private var _logo:Bitmap;
		
		private var _radarRange:Vector.<Bitmap> = new Vector.<Bitmap>();
		
		private var _progress:Progress;
		
		private var _isHide:Boolean = true;
		
		public function GUI(progress:Progress)
		{
			_progress = progress;
			
			createButtons();
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function createFields():void
		{
			_level = new TextBox(100, 30, 16, 0xFFFFFF, "", "123", "left", true);
			addChild(_level);
			_level.x = 15;
			_level.y = 12;
			_level.mouseEnabled = false;
			
			_money = new TextBox(100, 30, 16, 0xFEFF00, "", (_progress.moneyAtLevel + _progress.totalMoney).toString(), "left", true);
			addChild(_money);
			_money.x = 160;
			_money.y = _level.y;
			_money.mouseEnabled = false;
			
			var bitmap:Bitmap;
			bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_COINS]);
			addChild(bitmap);
			bitmap.x = _money.x - 30;
			bitmap.y = _money.y - 0;
			
			_battery = new TextBox(100, 30, 18, 0xFFFFFF, "", _progress.currentBattery.toString(), "left", true);
			addChild(_battery);
			_battery.x = _money.x + 130;
			_battery.y = _money.y - 2;
			_battery.mouseEnabled = false;
			
			bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_BATTERY_GUI]);
			addChild(bitmap);
			bitmap.x = _battery.x - 25;
			bitmap.y = _battery.y - 1;
			
			if (_progress.currentLevel < 9)
			{
				_battery.visible = false;
				bitmap.visible = false;
			}
			
			_tnt = new TextBox(60, 40, 34, 0xFFFFFF, "", _progress.currentTNT.toString(), "left", true);
			addChild(_tnt);
			_tnt.x = 490;
			_tnt.y = _level.y - 4;
			_tnt.mouseEnabled = false;
			
			bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_NUM_TNT]);
			addChild(bitmap);
			bitmap.x = _tnt.x - 20;
			bitmap.y = _tnt.y - 2;
			
			if (_progress.tntLevel > 0)
			{
				_bonusTNT = new TextBox(80, 40, 18, 0xFFFFFF, "", "+" + _progress.tntNumber[_progress.tntLevel], "left", true);//0x6CFF00
				addChild(_bonusTNT);
				_bonusTNT.x = (_tnt.text.length == 1) ? _tnt.x + 25 : _tnt.x + 48;
				_bonusTNT.y = _tnt.y - 2;
				_bonusTNT.mouseEnabled = false;
			}
			
			bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_LOGO_GUI]);
			addChild(bitmap);
			bitmap.x = _tnt.x + 110;
			bitmap.y = _tnt.y + 1;
			_logo = bitmap;
			
			stage.addEventListener(GameEvent.CHANGE_LEVEL, levelChangeHandler);
			stage.addEventListener(GameEvent.CHANGE_CAPACITY, tntChangeHandler);
			
			tntChangeHandler();
			levelChangeHandler();
			updateRadarIcons();
		}
		
		private function levelChangeHandler(e:GameEvent = null):void
		{
			if (e)
				e.stopPropagation();
			
			_level.text = "Level " + (_progress.currentLevel + 1);
			
			if (Behavior.tntToLevels[_progress.currentLevel] > 20)
				_level.text = "Bonus";
		}
		
		private function tntChangeHandler(e:GameEvent = null):void
		{
			if (e)
				e.stopPropagation();
			
			_tnt.text = _progress.currentTNT.toString();
			_battery.text = _progress.currentBattery.toString();
			_money.text = (_progress.moneyAtLevel + _progress.totalMoney).toString()
			
			if(_bonusTNT)
				_bonusTNT.x = (_tnt.text.length == 1) ? _tnt.x + 25 : _tnt.x + 48;
			
			if (_progress.currentBattery > 0)
				_battery.changeTextFormat(false, 0xFFFFFF);
			else
			{
				_battery.changeTextFormat(false, 0xB40404);
				
				if(_progress.batteryLevel > 0)
					AchievementController.getInstance().addParam(AchievementController.DISCHARGE_BATTERY);
			}
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			createFields();
		}
		
		private function updateRadarIcons():void
		{
			const coords:Array = [//left, top, right, bottom
				{x: -9, y: 14, rot: 180},//
				{x: -7, y: -2, rot: 270},//
				{x: 9, y: 0, rot: 0 },//
				{x: 7, y: 16, rot: 90 },//
				{x: -14, y: 14, rot: 180},//
				{x: -7, y: -7, rot: 270},//
				{x: 14, y: 0, rot: 0 },//
				{x: 7, y: 22, rot: 90 },//
			];//
			
			for each (var icon:Bitmap in _radarRange) 
			{
				removeChild(icon);
			}
			_radarRange.length = 0;
			
			var bitmap:Bitmap;
			var i:int;
			
			for (i = 0; i < coords.length; i++) 
			{
				bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_ARC_GUI]);
				
				if (!_progress.radarStates[_progress.radarLevel][i])
				{
					Functions.doGrayColor(bitmap);
					bitmap.alpha = 0.5;
				}
				
				_radarRange.push(bitmap);	
				addChild(bitmap);
				bitmap.x = 395 + coords[i].x;
				bitmap.y = 18 + coords[i].y;
				bitmap.rotation = coords[i].rot;
				
				if (_progress.currentLevel < 9)
				{
					bitmap.visible = false;
				}
			}
		}
		
		private function createButtons():void
		{
			_buttonBox = new Sprite();
			addChild(_buttonBox);
			
			_pause = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_PAUSE], ImageRes.buttonImages[ImageRes.BUTTON_PAUSE_HOVER])
			_buttonBox.addChild(_pause);
			_pause.x = 25;
			_pause.y = 24;
			
			_options = new ButtonStateImage(ImageRes.buttonImages[ImageRes.BUTTON_OPTIONS], ImageRes.buttonImages[ImageRes.BUTTON_OPTIONS_HOVER], ImageRes.buttonImages[ImageRes.BUTTON_OPTIONS_HOVER], ImageRes.buttonImages[ImageRes.BUTTON_OPTIONS])
			_buttonBox.addChild(_options);
			_options.x =  _pause.x + _pause.width + 10;
			_options.y = _pause.y;
			_options.addEventListener(MouseEvent.CLICK, clickHandler);
			
			_reset = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_RESET], ImageRes.buttonImages[ImageRes.BUTTON_RESET_HOVER])
			_buttonBox.addChild(_reset);
			_reset.x = _options.x + _options.width + 10;
			_reset.y = _pause.y;
			
			_menu = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_MENU], ImageRes.buttonImages[ImageRes.BUTTON_MENU_HOVER])
			_buttonBox.addChild(_menu);
			_menu.x = _reset.x + _reset.width + 10;
			_menu.y = _pause.y;
			
			_music = new ButtonSoundImage(ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_ON], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_OFF], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_ON_HOVER], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_OFF_HOVER], true)
			_buttonBox.addChild(_music);
			_music.x = _menu.x + _menu.width + 10;
			_music.y = _pause.y;
			
			_sound = new ButtonSoundImage(ImageRes.buttonImages[ImageRes.BUTTON_SOUND_ON], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_OFF], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_ON_HOVER], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_OFF_HOVER])
			_buttonBox.addChild(_sound);
			_sound.x = _music.x + _music.width + 10;
			_sound.y = _pause.y;
		
			_buttonBox.x = 800 - 83;
			_buttonBox.y = 0;
			
			_buttonBox.graphics.beginFill(0xFFFFFF, 0.01);
			_buttonBox.graphics.drawRect(0, 0, _buttonBox.width + 25, _buttonBox.height + 24);
			_buttonBox.graphics.endFill();
			
			_buttonBox.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			_buttonBox.addEventListener(MouseEvent.ROLL_OUT, outHandler);
		}
		
		private function overHandler(e:MouseEvent):void 
		{
			Controller.juggler.removeCall(hideButtons);
		}
		
		private function outHandler(e:MouseEvent):void 
		{
			Controller.juggler.addCall(hideButtons, 2);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			if (_options.isActive)
				showButtons();
			else
				hideButtons();
		}
		
		private function showButtons():void
		{
			_logo.visible = false;
			Tweener.addTween(_buttonBox, { x: (800 - _buttonBox.width + 3), time: 0.4, transition: "easeInQuart" } );//y: 50, 
		}
		
		private function hideButtons():void
		{
			if(!_options)
				return;
				
			_options.isActive = false;
			_logo.visible = true;
				
			Controller.juggler.removeCall(hideButtons);
			Tweener.addTween(_buttonBox, {x: (800 - 83), time: 0.4, transition: "easeOutQuart"});//y: 0, 
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			stage.removeEventListener(GameEvent.CHANGE_LEVEL, levelChangeHandler);
			stage.removeEventListener(GameEvent.CHANGE_CAPACITY, tntChangeHandler);
			
			Tweener.removeTweens(_buttonBox);
			Controller.juggler.removeCall(hideButtons);
			
			while (numChildren)
				removeChildAt(0);
			
			_progress = null;
			_tnt = null;
			_bonusTNT = null;
			_money = null;
			_level = null;
			_battery = null;
			_radarRange.length = 0;
			_radarRange = null;
			
			_reset = null;
			_pause = null;
			_menu = null;
			_sound = null;
			_music = null;
			_options = null;
		}
		
		public function get sound():ButtonSoundImage
		{
			return _sound;
		}
		
		public function get menu():ButtonImage
		{
			return _menu;
		}
		
		public function get pause():ButtonImage
		{
			return _pause;
		}
		
		public function get reset():ButtonImage
		{
			return _reset;
		}
	
	}

}