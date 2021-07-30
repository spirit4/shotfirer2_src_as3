package view
{
	import caurina.transitions.Tweener;
	import data.ImageRes;
	import data.Progress;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import utils.ButtonImage;
	import utils.ButtonLevelImage;
	import utils.ButtonSoundImage;
	import utils.ScoreBox;
	import utils.TextBox;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Levels extends Sprite
	{
		private var _money:ScoreBox;
		
		private var _back:ButtonImage;
		private var _shop:ButtonImage;
		private var _achievements:ButtonImage;
		
		private var _left:ButtonImage;
		private var _right:ButtonImage;
		
		private var _sound:ButtonSoundImage;
		private var _music:ButtonSoundImage;
		
		private var _progress:Progress;
		private var _levels:Vector.<ButtonImage>;
		
		private var _container:Sprite;
		private var _innerWidth:Number;
		private var _width:Number;
		private var _delta:Number;
		
		public function Levels(progress:Progress, lvls:Dictionary)
		{
			_progress = progress;
			
			createButtons(lvls);
			Controller.juggler.addCall(doInNextFrame, 0);
			
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
			
			createBg();
		}
		
		private function setPositionButtons():void
		{
			_sound.x = 800 - _sound.width * 0.5 - 8;
			_sound.y = 8 + _sound.height * 0.5;
			
			_music.x = 800 - _music.width * 0.5 - 8;
			_music.y = _sound.height * 1.5 + 16;
			
			_money.x = 30;
			_money.y = 10;
			
			_shop.x = 400;
			_shop.y = 540;
			
			_back.x = _shop.x - 240;
			_back.y = _shop.y;
			
			_achievements.x = _shop.x + 240;
			_achievements.y = _shop.y;
			
			_left.x = 32;
			_left.y = 280;
			
			_right.x = 800 - 31;
			_right.y = _left.y;
			
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
		
		private function createButtons(lvls:Dictionary):void
		{
			_money = new ScoreBox();
			addChild(_money);
			_money.updateScore(_progress.totalMoney);
			
			_sound = new ButtonSoundImage(ImageRes.buttonImages[ImageRes.BUTTON_SOUND_ON], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_OFF], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_ON_HOVER], ImageRes.buttonImages[ImageRes.BUTTON_SOUND_OFF_HOVER]);
			addChild(_sound);
			
			_music = new ButtonSoundImage(ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_ON], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_OFF], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_ON_HOVER], ImageRes.buttonImages[ImageRes.BUTTON_MUSIC_OFF_HOVER], true);
			addChild(_music);
			
			_back = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_BACK], ImageRes.buttonImages[ImageRes.BUTTON_BACK_HOVER], true);
			addChild(_back);
			
			_shop = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_SHOP], ImageRes.buttonImages[ImageRes.BUTTON_SHOP_HOVER], true);
			addChild(_shop);
			
			_achievements = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_ACHIEVE], ImageRes.buttonImages[ImageRes.BUTTON_ACHIEVE_HOVER], true);
			addChild(_achievements);
			
			_left = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_LEFT], ImageRes.buttonImages[ImageRes.BUTTON_LEFT_HOVER], true);
			addChild(_left);
			_left.addEventListener(MouseEvent.CLICK, leftHandler);
			
			_right = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_RIGHT], ImageRes.buttonImages[ImageRes.BUTTON_RIGHT_HOVER], true);
			addChild(_right);
			_right.addEventListener(MouseEvent.CLICK, rightHandler);
			
			_container = new Sprite();
			addChildAt(_container, 2);
			
			_levels = new Vector.<ButtonImage>(_progress.levelsCompleted);
			var lock:Bitmap;
			var lvl:ButtonImage;
			var col:int;
			var row:int;
			var col2:int;
			var row2:int;
			var title:String;
			
			for (var i:int = 0; i < _progress.numberLevels; i++)
			{
				col = i % 5;
				row = (i - col) / 5;
				col2 = i % 15;
				row2 = (i - col2) / 15;
				//trace(col2, row2 );
				
				title = (i + 1).toString();
				
				if (i < _progress.levelsCompleted)
				{
					lvl = new ButtonLevelImage(_progress.starToLevels[i], title, ImageRes.buttonImages[ImageRes.BUTTON_LEVEL], ImageRes.buttonImages[ImageRes.BUTTON_LEVEL_HOVER], true)
					
					_container.addChild(lvl);
					lvl.x = col * (lvl.width + 45) + lvl.width * 0.5 + 3 + row2 * ((lvl.width + 45) * 5);
					lvl.y = row * (lvl.height + 33) + lvl.height * 0.5 + 3 - row2 * ((lvl.height + 33) * 3);
					
					lvls[lvl] = i + 1;
					_levels[i] = lvl;
				}
				else
				{
					lock = new Bitmap(ImageRes.elementImages[ImageRes.EL_LEVEL_LOCK]);
					_container.addChild(lock);
					lock.x = col * (lock.width + 45) + 3 + row2 * ((lvl.width + 45) * 5);
					lock.y = row * (lock.height + 33) + 3 - row2 * ((lvl.height + 33) * 3);
				}
			}
			
			_width = (lvl.width + 45) * 5 - lvl.width * 0.5 - 3;
			_delta = (lvl.width + 45) * 5;
			_innerWidth = _container.width + 6;
			
			_container.mouseEnabled = false;
			_container.scrollRect = new Rectangle(0, 0, _width, (lvl.height + 33) * 3 - lvl.height * 0.5 + 9);
			_container.x = 130;
			_container.y = 144;
			//_container.graphics.beginFill(0, 0.2);
			//_container.graphics.drawRect(0, 0, _width, (lvl.height + 33) * 3 - lvl.height * 0.5 + 9);
			//_container.graphics.endFill();
			
			move(-1);//hide arrow
		}
		
		private function rightHandler(e:MouseEvent):void
		{
			move(1);
		}
		
		private function leftHandler(e:MouseEvent):void
		{
			move(-1);
		}
		
		private function move(direction:int):void
		{
			//trace("==moveFixed",_innerWidth, _width)
			if (_innerWidth < _width)
			{
				_left.visible = false;
				_right.visible = false;
				return;
			}
			
			var dx:Number = _container.scrollRect.x;
			dx += _delta * direction;
			
			_left.visible = true;
			_right.visible = true;
			if (dx < 1)
			{
				_left.visible = false;
				dx = 0;
			}
			else if (dx > _innerWidth - _width - 1)
			{
				_right.visible = false;
				dx = _innerWidth - _width;
			}
			
			Tweener.addTween(_container, {_scrollRect_x: dx, time: 0.4, transition: "easeOutQuart"});
		}
		
		private function createBg():void
		{
			const tf:TextBox = new TextBox(300, 40, 35, 0xFFFFFF, "", "Level Select", "center", true);
			addChild(tf);
			tf.x = 250;
			tf.y = 69;
			tf.mouseEnabled = false;
			
			var bitmap:Bitmap = new Bitmap(ImageRes.backgrounds[ImageRes.LEVELS]);
			addChildAt(bitmap, 0);
			
			bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_LEVELS_DECK]);
			addChildAt(bitmap, 1);
			bitmap.x = 800 - bitmap.width >> 1;
			bitmap.y = 50;
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			while (numChildren)
				removeChildAt(0);
			
			_progress = null;
			_levels.length = 0;
			_levels = null;
			_back = null;
			_shop = null;
			_achievements = null;
			_sound = null;
			_music = null;
			_money = null;
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
		
		public function get shop():ButtonImage
		{
			return _shop;
		}
	}

}