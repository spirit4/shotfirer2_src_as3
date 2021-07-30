package data
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	import utils.Functions;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class ApiKG
	{
		static private var _callbackConnect:Function;
		static private var _kongregate:*;
		
		public function ApiKG()
		{
		
		}
		
		static public function connect(stage:Stage, callback:Function):void
		{
			_callbackConnect = callback;
			
			var paramObj:Object = LoaderInfo(stage.loaderInfo).parameters;
			var apiPath:String = paramObj.kongregate_api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
			Security.allowDomain(apiPath);
			
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.load(request);
			stage.addChild(loader);
		}
		
		static private function loaderIOErrorHandler(e:IOErrorEvent):void
		{
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
			e.currentTarget.removeEventListener(Event.COMPLETE, completeHandler);
			trace(e);
		}
		
		static private function completeHandler(e:Event):void
		{
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
			e.currentTarget.removeEventListener(Event.COMPLETE, completeHandler);
			
			_kongregate = e.target.content;
			
			try
			{
				_kongregate.services.connect();
			}
			catch (e:Error)
			{
				trace(e);
				_callbackConnect(false);
				return;
			}
			
			_callbackConnect(true);
		}
		
		static public function sendScore(score:uint):void
		{
			_kongregate.stats.submit("Score", score);
		}
		
		static public function sendAchievement(type:uint):void
		{
			_kongregate.stats.submit("AchievementsEarned", 1);//plus one achievement
		}
		
		static public function sendLevels(levels:uint):void
		{
			if (Branding.isConnectedKGorNG && Functions.isUrl(["kongregate.com"]))
				_kongregate.stats.submit("LevelsCompleted", levels);
		}
		
		static public function sendRubies(stars:uint):void
		{
			if (Branding.isConnectedKGorNG && Functions.isUrl(["kongregate.com"]))
				_kongregate.stats.submit("RubiesEarned", stars);
		}
		
		static public function sendArt(value:uint):void
		{
			if (Branding.isConnectedKGorNG && Functions.isUrl(["kongregate.com"]))
				_kongregate.stats.submit("ArtefactsEarned", value);
		}
		
		static public function sendCompleteGame():void
		{
			if (Branding.isConnectedKGorNG && Functions.isUrl(["kongregate.com"]))
				_kongregate.stats.submit("game_completed", 1);
		}
		
		static public function sendEnemyKilled():void
		{
			if (Branding.isConnectedKGorNG && Functions.isUrl(["kongregate.com"]))
				_kongregate.stats.submit("killed_enemies ", 1);
		}
	}

}