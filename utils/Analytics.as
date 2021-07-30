package utils
{
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Analytics implements IUpdatable
	{
		private const KEY_GA:String = "UA-47047774-7";
		
		CONFIG::release
		{
			static public var analyticsIsEnabled:Boolean = true;
		}
		
		CONFIG::debug
		{
			static public var analyticsIsEnabled:Boolean = false;
		}
		
		static public const NUMBER_VERSION:String = "2.0.6";
		static public const RETAIL_VERSION:String = "R";
		static public const EXCLUSIVE_VERSION:String = "E";
		static public const TEST_VERSION:String = "Ts";
		static public const FGL_VERSION:String = "F";
		static public const LOCAL_VERSION_OR_WTF:String = "W";
		
		CONFIG::release
		{
			public var gameVersion:String = "";
		}
		
		CONFIG::debug
		{
			public var gameVersion:String = NUMBER_VERSION + TEST_VERSION;
		}
		
		static public const PING:String = "/Ping";
		static public const INIT:String = "/GUI/Init";
		static public const LOADED:String = "/GUI/Loaded";
		static public const PRELOADER_PLAY:String = "/GUI/ToMenuAndDomen/";
		static public const SOUND_ON:String = "/GUI/SoundOn";
		static public const SOUND_OFF:String = "/GUI/SoundOff";
		static public const MUSIC_ON:String = "/GUI/MusicOn";
		static public const MUSIC_OFF:String = "/GUI/MusicOff";
		
		//static public const CLICK_HIGHSCORES:String = "/GUI/highscoreS";
		//static public const CLICK_WALKTHROUGH:string = "/GUI/walkthroUGH";
		//static public const CLICK_CREDITS:String = "/GUI/credits";
		static public const CLICK_RESET_PROGRESS:String = "/GUI/ResetProgress";
		//static public const CLICK_PAUSE:String = "/GUI/pause";
		//static public const CLICK_MAP:String = "/GUI/map";
		
		static public const GAME_START:String = "/Game/Start";
		static public const GAME_END:String = "/Game/End";
		static public const LEVEL_START:String = "/Game/Level/Start/LVL-"; //add number level
		static public const LEVEL_END:String = "/Game/Level/End/LVL-"; //add number level
		static public const GET_TREASURE:String = "/Game/Get/Treasure/Type-";//add type
		static public const GET_RUBIN:String = "/Game/Get/Rubin";
		static public const GET_TNT:String = "/Game/Get/TntBox";
		static public const GET_BATTERY:String = "/Game/Get/Battery";
		static public const GET_LOGO:String = "/Game/Get/Logo";
		static public const GET_ACHIEV:String = "/Game/Get/Achievement/a-"; //add number achievement
		static public const HERO_DEATH:String = "/Game/Hero/Death/From-"; //add from
		static public const MONSTER_DEATH:String = "/Game/Hero/Kill/"; //add to
		
		static public const JUMP_AUTO:String = "jump_auto";
		static public const CRAWL_AUTO:String = "crawl_auto";
		static public const CRAWL_BUTTON:String = "crawl_button";
		static public const TNT_SET_SPACE:String = "tnt_set_space";
		static public const TNT_SET_CTRL:String = "tnt_set_ctrl";
		static public const TNT_SET_Z:String = "tnt_set_z";
		static public const TNT_PER_LVL:String = "tnt_per_lvl";
		static public const LVL_RETRIES:String = "lvl_retries";
		//static public const BONUS_ARROWS:String = "bonus_arrows";
		//static public const BONUS_MOUSE:String = "bonus_arrows";
		static public const QUEUE_PAGES:String = "queue_pages";
		static public const QUEUE_EVENTS:String = "queue_events";
		
		static private var _instance:Analytics;
		
		private var _ga:AnalyticsTracker;
		private var _lastTime:uint;
		
		private var _queuePages:Vector.<String>;
		private var _queueEvents:Vector.<Object>;
		
		private var _delayPage:uint = 5000;
		private const DELAY_EVENT:uint = 1500;
		private const DELAY_PING:uint = 60000;
		
		public function Analytics()
		{
		
		}
		
		public function init(object:DisplayObject):void
		{
			const domens:Array = [//
				"kongregate.com",//
				"newgrounds.com",//
				"uploads.ungrounded.net",//
				];//
				
			//if (Functions.isUrl(domens))
				//gameVersion = NUMBER_VERSION + EXCLUSIVE_VERSION;
			//else
				//gameVersion = NUMBER_VERSION + RETAIL_VERSION;
				
			if (Functions.isUrl(["fgl.com","flashgamelicense.com"]))
				gameVersion = NUMBER_VERSION + FGL_VERSION;
			else if (Functions.isUrl(["testovy.ru"]))
				gameVersion = NUMBER_VERSION + TEST_VERSION;
			else
				gameVersion = NUMBER_VERSION + LOCAL_VERSION_OR_WTF;//wtf!!!
			
			_queuePages = new Vector.<String>();
			_queueEvents = new Vector.<Object>();
			
			
			
			if (analyticsIsEnabled)
			{
				_ga = new GATracker(object, KEY_GA, "AS3", false);
				
				_lastTime = getTimer();
				
				pushPage(INIT);
				sendPage();
			}
		}
		
		public function update():void
		{
			const time:uint = getTimer();
			if (_queuePages.length > 0 && time - _lastTime > _delayPage)
			{
				//trace("sendPage", time)
				sendPage();
				_lastTime = time;
				return;
			}
			
			if (_queueEvents.length > 0 && time - _lastTime > DELAY_EVENT)
			{
				//trace("sendEvent", time)
				sendEvent();
				_lastTime = time;
				return;
			}
			
			if (time - _lastTime > DELAY_PING)
			{
				//trace("sendPing", time)
				pushPage(PING);
			}
		}
		
		static public function pushPage(page:String, value:String = ""):void
		{
			if (!analyticsIsEnabled)
				return;
				
			_instance.addPage(page, value);
		}
		
		static public function pushEvent(action:String, label:String, value:Number):void
		{
			if (!analyticsIsEnabled)
				return;
				
			_instance.addEvent(action, label, value);
		}
		
		static public function forcePage():void
		{
			if (_instance._queuePages.length > 0)
				_instance.sendPage();
		}
		
		private function addPage(page:String, value:String = ""):void
		{
			_queuePages.push(gameVersion + page + value);
			
			if (_queuePages.length < 4)
				_delayPage = 5000;
			else
				_delayPage = 2200;
				
			//if (page == LEVEL_END)
			//{
				//pushEvent(QUEUE_PAGES, "queue-", _queuePages.length);
				//pushEvent(QUEUE_EVENTS, "queue-", _queueEvents.length);
			//}
		}
		
		private function addEvent(action:String, label:String, value:Number):void
		{
			_queueEvents.push({"action": action, "label": label, "value": value});
		}
		
		private function sendPage():void
		{
			const page:String = _queuePages.shift();
			
			try
			{
				_ga.trackPageview(page);
			}
			catch (e:Error)
			{
				_queuePages.unshift(page);
				trace(e);
			}
		}
		
		private function sendEvent():void
		{
			const event:Object = _queueEvents.shift();
			
			try
			{
				_ga.trackEvent("LevelResults-", event.action, event.label + "_value-" + event.value, event.value);
			}
			catch (e:Error)
			{
				_queueEvents.unshift(event);
				trace(e);
			}
		}
		
		static public function get instance():Analytics
		{
			if (!_instance)
				_instance = new Analytics();
			
			return _instance;
		}
	}

}