package view
{
	import data.AchievementController;
	import data.Behavior;
	import data.ImageRes;
	import data.Progress;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.ButtonCost;
	import utils.ButtonImage;
	import utils.ButtonSoundImage;
	import utils.Functions;
	import utils.TextBox;
	import view.hints.Reminder;
	import view.hints.Tooltip;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Shop extends Sprite
	{
		private var _money:TextBox;
		
		private var _tnt:Vector.<Bitmap> = new Vector.<Bitmap>();
		private var _radar:Vector.<Bitmap> = new Vector.<Bitmap>();
		private var _battery:Vector.<Bitmap> = new Vector.<Bitmap>();
		
		private var _tntCost:ButtonCost;
		private var _radarCost:ButtonCost;
		private var _batteryCost:ButtonCost;
		
		private var _back:ButtonImage;
		private var _levels:ButtonImage;
		private var _achievements:ButtonImage;
		
		private var _sound:ButtonSoundImage;
		private var _music:ButtonSoundImage;
		
		private var _progress:Progress;
		
		private var _bonusTNT:TextBox;
		private var _bonusBattery:TextBox;
		private var _radarRange:Vector.<Bitmap> = new Vector.<Bitmap>();
		
		public function Shop(progress:Progress)
		{
			_progress = progress;
			
			createButtons();
			createBg();
			createUpgrades();
			
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
			addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			addEventListener(MouseEvent.MOUSE_OUT, outHandler);
		}
		
		private function overHandler(e:MouseEvent):void
		{
			if (e.target == _tntCost)
				Tooltip.getInstance().showTooltip(getHelpTNT());
			else if (e.target == _radarCost)
				Tooltip.getInstance().showTooltip(getHelpRadar());
			else if (e.target == _batteryCost)
				Tooltip.getInstance().showTooltip(getHelpBattery());
		}
		
		private function outHandler(e:MouseEvent = null):void
		{
			Tooltip.getInstance().hideTooltip();
		}
		
		private function getHelpTNT():Sprite
		{
			const sprite:Sprite = new Sprite();
			var tf:TextBox;
			tf = new TextBox(280, 30, 22, 0x433C2C, "", "Spare Dynamite", "center", true);
			sprite.addChild(tf);
			tf.x = 15;
			tf.y = 20;
			
			tf = new TextBox(280, 30, 14, 0x433C2C, "", Behavior.shopDescriptions[0], "center", false);
			sprite.addChild(tf);
			tf.x = 15;
			tf.y = 55;
			
			tf = new TextBox(280, 30, 16, 0x333C2C, "", "", "left", false);
			sprite.addChild(tf);
			tf.htmlText = 'Number:  <b>+' + _progress.tntNumber[_progress.tntLevel] + ' <FONT COLOR="#429C00">(' + _progress.tntNumber[_progress.tntLevel + 1] + ')</FONT></b>';
			tf.x = 20;
			tf.y = 110;
			
			tf = new TextBox(280, 30, 16, 0x433C2C, "", "", "left", false);
			sprite.addChild(tf);
			tf.htmlText = 'Upgrade price:        <b>' + _progress.tntCosts[_progress.tntLevel + 1] + '</b>';
			tf.x = 20;
			tf.y = 140;
			
			const coin:Bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_COINS]);
			sprite.addChild(coin);
			coin.x = 170;
			coin.y = 139;
			
			return sprite;
		}
		
		private function getHelpRadar():Sprite
		{
			const sprite:Sprite = new Sprite();
			var tf:TextBox;
			tf = new TextBox(280, 30, 22, 0x433C2C, "", "Radar", "center", true);
			sprite.addChild(tf);
			tf.x = 15;
			tf.y = 20;
			
			tf = new TextBox(280, 30, 14, 0x433C2C, "", Behavior.shopDescriptions[1], "center", false);
			sprite.addChild(tf);
			tf.x = 15;
			tf.y = 55;
			
			tf = new TextBox(280, 30, 16, 0x333C2C, "", "", "left", false);
			sprite.addChild(tf);
			tf.htmlText = 'Upgrade range: ';
			tf.x = 20;
			tf.y = 120;
			
			tf = new TextBox(280, 30, 16, 0x433C2C, "", "", "left", false);
			sprite.addChild(tf);
			tf.htmlText = 'Upgrade price:        <b>' + _progress.radarCosts[_progress.radarLevel + 1] + '</b>';
			tf.x = 20;
			tf.y = 155;
			
			const coin:Bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_COINS]);
			sprite.addChild(coin);
			coin.x = 170;
			coin.y = 154;
			
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
			
			var bitmap:Bitmap;
			var i:int;
			
			for (i = 0; i < coords.length; i++) 
			{
				bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_ARC_GUI]);
				
				if (!_progress.radarStates[_progress.radarLevel + 1][i])
				{
					Functions.doGrayColor(bitmap);
					bitmap.alpha = 0.5;
				}
				
				sprite.addChild(bitmap);
				bitmap.x = 210 + coords[i].x;
				bitmap.y = 125 + coords[i].y;
				bitmap.rotation = coords[i].rot;
				
			}
			
			return sprite;
		}
		
		private function getHelpBattery():Sprite
		{
			const sprite:Sprite = new Sprite();
			var tf:TextBox;
			tf = new TextBox(280, 30, 22, 0x433C2C, "", "Radar Battery", "center", true);
			sprite.addChild(tf);
			tf.x = 15;
			tf.y = 20;
			
			tf = new TextBox(280, 30, 14, 0x433C2C, "", Behavior.shopDescriptions[2], "center", false);
			sprite.addChild(tf);
			tf.x = 15;
			tf.y = 55;
			
			tf = new TextBox(280, 30, 16, 0x333C2C, "", "", "left", false);
			sprite.addChild(tf);
			tf.htmlText = 'Number:  <b>' + _progress.batteryNumber[_progress.batteryLevel] + ' <FONT COLOR="#429C00">(' + _progress.batteryNumber[_progress.batteryLevel + 1] + ')</FONT></b>';
			tf.x = 20;
			tf.y = 110;
			
			tf = new TextBox(280, 30, 16, 0x433C2C, "", "", "left", false);
			sprite.addChild(tf);
			tf.htmlText = 'Upgrade price:        <b>' + _progress.batteryCosts[_progress.batteryLevel + 1] + '</b>';
			tf.x = 20;
			tf.y = 140;
			
			const coin:Bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_COINS]);
			sprite.addChild(coin);
			coin.x = 170;
			coin.y = 139;
			
			return sprite;
		}
		
		private function setPositionButtons():void
		{
			_sound.x = 800 - _sound.width * 0.5 - 8;
			_sound.y = 8 + _sound.height * 0.5;
			
			_music.x = 800 - _music.width * 0.5 - 8;
			_music.y = _sound.height * 1.5 + 16;
			
			_money.x = 355;
			_money.y = 65;
			
			_levels.x = 400;
			_levels.y = 540;
			
			_back.x = _levels.x - 240;
			_back.y = _levels.y;
			
			_achievements.x = _levels.x + 240;
			_achievements.y = _levels.y;
		}
		
		private function createButtons():void
		{
			_money = new TextBox(150, 30, 32, 0xFEFF00, "", _progress.totalMoney.toString(), "left", true);
			addChild(_money);
			_money.mouseEnabled = false;
			
			_sound = new ButtonSoundImage(ImageRes.buttonImages[ImageRes.BUTTON_SOUND_ON], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_OFF], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_ON_HOVER], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_OFF_HOVER]);
			addChild(_sound);
			
			_music = new ButtonSoundImage(ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_ON], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_OFF], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_ON_HOVER], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_OFF_HOVER], true);
			addChild(_music);
			
			_back = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_BACK], ImageRes.buttonImages[ImageRes.BUTTON_BACK_HOVER], true);
			addChild(_back);
			
			_levels = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_LEVELS], ImageRes.buttonImages[ImageRes.BUTTON_LEVELS_HOVER], true);
			addChild(_levels);
			
			_achievements = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_ACHIEVE], ImageRes.buttonImages[ImageRes.BUTTON_ACHIEVE_HOVER], true);
			addChild(_achievements);
		}
		
		private function createBg():void
		{
			var bitmap:Bitmap = new Bitmap(ImageRes.backgrounds[ImageRes.LEVELS]);
			addChildAt(bitmap, 0);
			
			bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_SHOP_DECK]);
			addChildAt(bitmap, 1);
			bitmap.x = 800 - bitmap.width >> 1;
			bitmap.y = 50;
		}
		
		private function createUpgrades():void
		{
			var tf:TextBox;
			var bitmap:Bitmap;
			var i:int;
			
			//tnt
			tf = new TextBox(150, 30, 19, 0x3D3C2A, "", "Dynamite", "left", true);
			addChild(tf);
			tf.mouseEnabled = false;
			tf.x = 267;
			tf.y = 132;
			
			updateIcons(_tnt, _progress.tntLevel, 158);
			
			_tntCost = new ButtonCost(ImageRes.buttonImages[ImageRes.BUTTON_BUY], ImageRes.buttonImages[ImageRes.BUTTON_BUY_HOVER], true);
			addChild(_tntCost);
			
			_tntCost.x = 605;
			_tntCost.y = 177;
			if (_progress.tntLevel == _progress.tntCosts.length - 1)
			{
				_tntCost.isActive = false;
				_tntCost.updateCost(-1);
			}
			else
			{
				_tntCost.updateCost(_progress.tntCosts[_progress.tntLevel + 1]);
				_tntCost.addEventListener(MouseEvent.CLICK, tntBuyHandler);
			}
			
			_bonusTNT = new TextBox(80, 40, 18, 0x429C00, "", "+" + _progress.tntNumber[_progress.tntLevel], "left", true);
			addChild(_bonusTNT);
			_bonusTNT.x = tf.x - 80;
			_bonusTNT.y = tf.y - 0;
			_bonusTNT.mouseEnabled = false;
			if (_progress.tntLevel == 0)
				_bonusTNT.visible = false;
			
			//radar
			tf = new TextBox(150, 30, 19, 0x3D3C2A, "", "Radar", "left", true);
			addChild(tf);
			tf.mouseEnabled = false;
			tf.x = 267;
			tf.y = 244;
			
			updateIcons(_radar, _progress.radarLevel, 270);
			
			_radarCost = new ButtonCost(ImageRes.buttonImages[ImageRes.BUTTON_BUY], ImageRes.buttonImages[ImageRes.BUTTON_BUY_HOVER], true);
			addChild(_radarCost);
			_radarCost.x = 605;
			_radarCost.y = 289;
			if (_progress.radarLevel == _progress.radarCosts.length - 1)
			{
				_radarCost.isActive = false;
				_radarCost.updateCost(-1);
			}
			else
			{
				_radarCost.updateCost(_progress.radarCosts[_progress.radarLevel + 1]);
				_radarCost.addEventListener(MouseEvent.CLICK, radarBuyHandler);
			}
			
			updateRadarIcons();
			
			//battery
			tf = new TextBox(150, 30, 19, 0x3D3C2A, "", "Battery", "left", true);
			addChild(tf);
			tf.mouseEnabled = false;
			tf.x = 267;
			tf.y = 356;
			
			updateIcons(_battery, _progress.batteryLevel, 382);
			
			_batteryCost = new ButtonCost(ImageRes.buttonImages[ImageRes.BUTTON_BUY], ImageRes.buttonImages[ImageRes.BUTTON_BUY_HOVER], true);
			addChild(_batteryCost);
			_batteryCost.x = 605;
			_batteryCost.y = 401;
			if (_progress.batteryLevel == _progress.batteryCosts.length - 1)
			{
				_batteryCost.isActive = false;
				_batteryCost.updateCost(-1);
			}
			else
			{
				_batteryCost.updateCost(_progress.batteryCosts[_progress.batteryLevel + 1]);
				_batteryCost.addEventListener(MouseEvent.CLICK, batteryBuyHandler);
			}
			
			_bonusBattery = new TextBox(80, 40, 18, 0x429C00, "", "" + _progress.batteryNumber[_progress.batteryLevel], "left", true);
			addChild(_bonusBattery);
			_bonusBattery.x = tf.x - 100;
			_bonusBattery.y = tf.y + 0;
			_bonusBattery.mouseEnabled = false;
			if (_progress.batteryLevel == 0)
				_bonusBattery.visible = false;
		}
		
		private function updateRadarIcons():void
		{
			const coords:Array = [ //left, top, right, bottom
			{x: -21, y: 30, rot: 180}, //
			{x: -9, y: -14, rot: 270}, //
			{x: 32, y: 0, rot: 0}, //
			{x: 21, y: 40, rot: 90}, //
			{x: -31, y: 30, rot: 180}, //
			{x: -9, y: -24, rot: 270}, //
			{x: 42, y: 0, rot: 0}, //
			{x: 21, y: 50, rot: 90}, //
			]; //
			
			for each (var icon:Bitmap in _radarRange)
			{
				removeChild(icon);
			}
			_radarRange.length = 0;
			
			var bitmap:Bitmap;
			var i:int;
			
			for (i = 0; i < coords.length; i++)
			{
				if (_progress.radarStates[_progress.radarLevel][i])
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_RADAR_RANGE_ACTIVE]);
				else
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_RADAR_RANGE]);
				
				_radarRange.push(bitmap);
				addChild(bitmap);
				bitmap.x = 140 + coords[i].x;
				bitmap.y = 270 + coords[i].y;
				bitmap.rotation = coords[i].rot;
			}
		}
		
		private function radarBuyHandler(e:MouseEvent):void
		{
			if (_progress.totalMoney < _progress.radarCosts[_progress.radarLevel + 1])
			{
				SoundManager.getInstance().playSFX(SoundRes.SFX_NO_TNT);
				addChild(new Reminder("need more money", Reminder.JUMP, 0.5, 0.9));
				return;
			}
			
			_progress.totalMoney -= _progress.radarCosts[_progress.radarLevel + 1];
			_money.text = _progress.totalMoney.toString();
			
			_progress.radarLevel++;
			if (_progress.radarLevel == _progress.radarCosts.length - 1)
			{
				_radarCost.isActive = false;
				_radarCost.updateCost(-1);
			}
			else
				_radarCost.updateCost(_progress.radarCosts[_progress.radarLevel + 1]);
			
			updateRadarIcons();
			
			updateIcons(_radar, _progress.radarLevel, 270);
		}
		
		private function tntBuyHandler(e:MouseEvent):void
		{
			if (_progress.totalMoney < _progress.tntCosts[_progress.tntLevel + 1])
			{
				SoundManager.getInstance().playSFX(SoundRes.SFX_NO_TNT);
				addChild(new Reminder("need more money", Reminder.JUMP, 0.5, 0.9));
				return;
			}
			
			_progress.totalMoney -= _progress.tntCosts[_progress.tntLevel + 1];
			_money.text = _progress.totalMoney.toString();
			
			_progress.tntLevel++;
			if (_progress.tntLevel == _progress.tntCosts.length - 1)
			{
				_tntCost.isActive = false;
				_tntCost.updateCost(-1);
			}
			else
				_tntCost.updateCost(_progress.tntCosts[_progress.tntLevel + 1]);
			
			_bonusTNT.text = "+" + _progress.tntNumber[_progress.tntLevel].toString();
			_bonusTNT.visible = true;
			
			updateIcons(_tnt, _progress.tntLevel, 158);
		}
		
		private function batteryBuyHandler(e:MouseEvent):void
		{
			if (_progress.totalMoney < _progress.batteryCosts[_progress.batteryLevel + 1])
			{
				SoundManager.getInstance().playSFX(SoundRes.SFX_NO_TNT);
				addChild(new Reminder("need more money", Reminder.JUMP, 0.5, 0.9));
				return;
			}
			
			_progress.totalMoney -= _progress.batteryCosts[_progress.batteryLevel + 1];
			_money.text = _progress.totalMoney.toString();
			
			_progress.batteryLevel++;
			if (_progress.batteryLevel == _progress.batteryCosts.length - 1)
			{
				_batteryCost.isActive = false;
				_batteryCost.updateCost(-1);
			}
			else
				_batteryCost.updateCost(_progress.batteryCosts[_progress.batteryLevel + 1]);
			
			_bonusBattery.text = "+" + _progress.batteryNumber[_progress.batteryLevel].toString();
			_bonusBattery.visible = true;
			
			updateIcons(_battery, _progress.batteryLevel, 382);
		}
		
		private function updateIcons(icons:Vector.<Bitmap>, level:int, yIcon:Number):void
		{
			outHandler();
			
			if (_progress.batteryLevel + _progress.tntLevel + _progress.radarLevel == 15)
				AchievementController.getInstance().addParam(AchievementController.BOUGHT_ALL);
			
			for each (var icon:Bitmap in icons)
			{
				removeChild(icon);
			}
			icons.length = 0;
			
			var bitmap:Bitmap;
			var i:int;
			
			for (i = 0; i < 5; i++)
			{
				if (level > i)
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_UPGRADE_MARK_ACTIVE]);
				else
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_UPGRADE_MARK]);
				
				icons.push(bitmap);
				addChild(bitmap);
				bitmap.x = 270 + i * (bitmap.width + 5);
				bitmap.y = yIcon;
			}
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			while (numChildren)
				removeChildAt(0);
			
			_progress = null;
			_levels = null;
			_back = null;
			_achievements = null;
			_sound = null;
			_music = null;
			_money = null;
			_bonusTNT = null;
			_bonusBattery = null;
			
			_tnt.length = 0;
			_tnt = null;
			_battery.length = 0;
			_battery = null;
			_radar.length = 0;
			_radar = null;
		}
		
		public function get sound():ButtonSoundImage
		{
			return _sound;
		}
		
		public function get back():ButtonImage
		{
			return _back;
		}
		
		public function get achievements():ButtonImage
		{
			return _achievements;
		}
		
		public function get levels():ButtonImage
		{
			return _levels;
		}
	}

}