package data
{
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.Analytics;
	import utils.BitmapClip;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class AchievementController
	{
		public static const HERO_DEATH_TNT:int = 0;
		public static const HERO_DEATH_SPIKE:int = 1;
		public static const HERO_DEATH_ENEMY:int = 2;
		public static const HERO_DEATH_ABYSS:int = 3;
		public static const HERO_DEATH_WORM:int = 4; //kind of enemy
		public static const ENEMY_DEATH_TNT:int = 5;
		public static const ENEMY_DEATH_BOX:int = 6;
		public static const ENEMY_DEATH_ABYSS:int = 7;
		public static const CRAWL_TNT:int = 8;
		public static const TNT_UNDER_BOX_OR_TROLLEY:int = 9;
		
		public static const GETTING_GOLD:int = 10;
		public static const TOUCH_SPIKE_ALIVE:int = 11;
		public static const GETTING_LOGO:int = 12;
		public static const DISCHARGE_BATTERY:int = 13;
		public static const JUMP_STAIR:int = 14;
		public static const QUICK_STAIR:int = 15;
		public static const TROLLEY_TOUCH_2_BUTTONS:int = 16;
		public static const TNT_ON_STONE:int = 17;
		public static const ACTIVATE_STONE:int = 18;
		public static const ACTIVATE_STAIR:int = 19;
		
		public static const ACTIVATE_SPIKE:int = 20;
		public static const GET_TNT_CASE:int = 21;
		public static const GET_BATTERY_CASE:int = 22;
		public static const GET_A_FEW_EXITS:int = 23;
		public static const BLOW_3_FOR_5:int = 24;
		public static const COMPLETE_LVL:int = 25; //only first time
		public static const BLOW_GROUND:int = 26;
		public static const FIND_GOLD_RADAR_TOP:int = 27;
		public static const TEN_SECOND_LVL:int = 28;
		public static const BOUGHT_ALL:int = 29;
		
		public static const GETTING_RUBY:int = 30;
		
		//public static const UNDERMINE_TNT:int = 13;
		//public static const CHANGE_3_DIRECTION:int = 14;
		//public static const BURST_BOX_TNT:int = 5;
		//public static const GETTING_FLY_GEM:int = 16;
		//public static const FIVE_BONUS_ENEMY_DEATH:int = 17;
		//public static const BONUS_ENEMY_DEATH:int = 8;
		//public static const BONUS_COMPLETE_LVL_EMPTY:int = 9;
		//public static const COMPLETE_BONUS_LVL:int = 21;
		
		private static var _instance:AchievementController;
		private static var _allowInstance:Boolean = false;
		
		private var _progress:Progress;
		private var _ach:Sprite;
		private var _bg:BitmapClip;
		private var _icon:Bitmap;
		
		private var _counterSpentTNT:int;
		private var _currentParam:int = -1;
		
		private var _params:Vector.<uint> = new <uint>[ //
		0, //
		0, //
		0, //
		0, //
		0, //4
		0, //
		0, //
		0, //
		0, //
		0, //9
		0, //
		0, //
		0, //
		0, //
		0, //14
		0, //
		0, //
		0, //
		0, //
		0, //19
		0, //
		0, //
		0, //
		0, //
		0, //24
		0, //
		0, //
		0, //
		0, //
		0, //29
		0, //
		]; //
		
		public function AchievementController()
		{
			if (!_allowInstance)
			{
				throw new Error("Error: Use AchievementController.getInstance() instead of the new keyword.");
			}
		}
		
		public static function getInstance():AchievementController
		{
			if (!_instance)
			{
				_allowInstance = true;
				_instance = new AchievementController();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function addParam(type:int):void
		{
			_params[type]++;
			
			if (type == COMPLETE_LVL)
				_counterSpentTNT += Behavior.tntToLevels[_progress.currentLevel] - _progress.currentTNT;
			
			_currentParam = type;
			
			//trace("[added param type: ]", type);
			incrementAchCounter(type);
			
			sendTrackerMessage(type);
			checkAchievements(type);
		}
		
		public function incrementAchCounter(type:int):void
		{
			if (type == GETTING_GOLD)
				_progress.achievements[ImageRes.A_PROSPECTOR]++;
			
			if (type == HERO_DEATH_SPIKE)
				_progress.achievements[ImageRes.A_LOVER_SHARP]++;
			
			if (type == ENEMY_DEATH_ABYSS || type == ENEMY_DEATH_BOX || type == ENEMY_DEATH_TNT)
				_progress.achievements[ImageRes.A_FIGHTER]++;
			
			if (type == HERO_DEATH_ENEMY)
				_progress.achievements[ImageRes.A_VICTIM]++;
			
			if (type == BLOW_GROUND)
				_progress.achievements[ImageRes.A_SHOTFIRER]++;
		}
		
		private function sendTrackerMessage(type:int):void
		{
			var typeEvent:String = "";
			switch (type)
			{
				case HERO_DEATH_ENEMY: 
					typeEvent = "ENEMY";
					break;
				case HERO_DEATH_SPIKE: 
					typeEvent = "SPIKE";
					break;
				case HERO_DEATH_TNT: 
					typeEvent = "TNT";
					break;
				case HERO_DEATH_ABYSS: 
					typeEvent = "ABYSS";
					break;
				case HERO_DEATH_WORM: 
					typeEvent = "WORM";
					break;
			}
			
			if (typeEvent != "")
				Analytics.pushPage(Analytics.HERO_DEATH, typeEvent);
		}
		
		private function checkAchievements(currentEvent:uint):void
		{
			const achs:Vector.<int> = _progress.achievements;
			for (var i:int = 0; i < achs.length; i++)
			{
				if (achs[i] >= 777)
					continue;
				
				switch (i)
				{
					case ImageRes.A_ACCIDENTAL_DEATH: 
						if (_params[HERO_DEATH_TNT] + _params[HERO_DEATH_SPIKE] + _params[HERO_DEATH_ENEMY] + _params[HERO_DEATH_ABYSS] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_FIRST_BLOOD: 
						if (_params[ENEMY_DEATH_ABYSS] + _params[ENEMY_DEATH_BOX] + _params[ENEMY_DEATH_TNT] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_LUCKY: 
						if (_params[GETTING_GOLD] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_DODGER: 
						if (_params[CRAWL_TNT] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_ACROBAT: 
						if (_params[JUMP_STAIR] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_CHECK_BOTTOM: 
						if (_params[HERO_DEATH_ABYSS] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_MINER: 
						if (_params[TNT_UNDER_BOX_OR_TROLLEY] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_AVOID_A_TRAP: 
						if (_params[TOUCH_SPIKE_ALIVE] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_MY_PRECIOUS: 
						if (_params[GETTING_LOGO] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_FEED_A_PET: 
						if (_params[HERO_DEATH_WORM] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_PROSPECTOR: 
						if (_params[GETTING_GOLD] >= 10)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_LOVER_SHARP: 
						if (_params[HERO_DEATH_SPIKE] >= 10)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_FIGHTER: 
						if (_params[ENEMY_DEATH_ABYSS] + _params[ENEMY_DEATH_BOX] + _params[ENEMY_DEATH_TNT] >= 10)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_CRAZY_DIGGER: 
						if (_params[DISCHARGE_BATTERY] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_ENTRAP: 
						if (_params[ENEMY_DEATH_ABYSS] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_QUICK_SOLUTION: 
						if (_params[QUICK_STAIR] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_USEFUL_TROLLEY: 
						if (_params[TROLLEY_TOUCH_2_BUTTONS] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_EXPERIMENTER: 
						if (_params[TNT_ON_STONE] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_EXPERT_OF_GEARS: 
						if (_params[ACTIVATE_SPIKE] > 0 && _params[ACTIVATE_STAIR] > 0 && _params[ACTIVATE_STONE] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_REFILL: 
						if (_params[GET_BATTERY_CASE] + _params[GET_TNT_CASE] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_COMPARE_THE_WAYS: 
						if (_params[GET_A_FEW_EXITS] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_CRAZY_BLASTER: 
						if (_params[BLOW_3_FOR_5] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_BUMMER: 
						if (_currentParam == COMPLETE_LVL && _progress.currentStar == 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_SCROOGE: 
						if (_currentParam == COMPLETE_LVL && _params[COMPLETE_LVL] >= 10 && _progress.radarLevel + _progress.batteryLevel + _progress.tntLevel == 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_VICTIM: 
						if (_params[HERO_DEATH_ENEMY] >= 10)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_SHOTFIRER: 
						if (_params[BLOW_GROUND] >= 99)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_SKILLED_DIGGER: 
						if (_params[FIND_GOLD_RADAR_TOP] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_SPRINTER: 
						if (_params[TEN_SECOND_LVL] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_EQUIPPED: 
						if (_params[BOUGHT_ALL] > 0)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
					case ImageRes.A_COLLECTOR: 
						if (_params[GETTING_RUBY] > 0 && _progress.allStar + _progress.currentStar == _progress.maxStar)
						{
							achs[i] = 777;
							letAchievement(i);
						}
						break;
					
						//default: 
						//trace("unknown achievement");
				}
			}
		}
		
		private function letAchievement(type:int):void
		{
			SoundManager.getInstance().playSFX(SoundRes.SFX_ACHIEVEMENT);
			
			if (Branding.isConnectedKGorNG)
				Branding.submitAchievement(type);
			
			Analytics.pushPage(Analytics.GET_ACHIEV, (type + 1).toString());
			
			if (_ach.visible)
				removeAchievement();
			
			_icon = new Bitmap(ImageRes.achAlphaImages[type]);
			_ach.addChild(_icon);
			_icon.x = -_icon.width + 2 >> 1;
			_icon.y = -_icon.height + 2 >> 1;
			
			_ach.alpha = 0;
			_ach.scaleX = _ach.scaleY = 1.2;
			_ach.visible = true;
			
			//Controller.juggler.add(_bg);
			_bg.play(AnimationRes.ACHIEVEMENT);
			Controller.juggler.addCall(hideAchievement, 110 / 60);
			Tweener.addTween(_ach, {scaleX: 1, scaleY: 1, alpha: 1, time: 0.4, transition: "easeInBack"});
		}
		
		private function hideAchievement():void
		{
			Tweener.addTween(_ach, {scaleX: 1.2, scaleY: 1.2, alpha: 0, time: 0.4, transition: "easeOutBack", onComplete: removeAchievement});
		}
		
		public function removeAchievement():void
		{
			if (!_ach.visible)
				return;
			
			Controller.juggler.removeCall(hideAchievement);
			
			_ach.removeChild(_icon);
			_icon = null;
			
			_ach.visible = false;
		
			//Controller.juggler.remove(_bg);
		}
		
		public function init(stage:Stage, progress:Progress):void
		{
			_progress = progress;
			
			//_params[GETING_ART] = _progress.artToLevels.length;
			_params[COMPLETE_LVL] = _progress.levelsCompleted;
			
			_ach = new Sprite();
			stage.addChild(_ach);
			_ach.x = 70;
			_ach.y = 100;
			
			_bg = new BitmapClip(new <uint>[AnimationRes.ACHIEVEMENT], new <Array>[null], new Rectangle(0, 0, 160, 160));
			_bg.stop();
			_ach.addChild(_bg);
			_bg.x = -80;
			_bg.y = -80;
			
			_ach.visible = false;
		}
	}

}