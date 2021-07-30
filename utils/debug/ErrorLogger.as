package utils.debug
{
	import flash.events.UncaughtErrorEvent;
	import flash.system.Capabilities;
	import flash.utils.getTimer;
	import utils.convert.DateFormat;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class ErrorLogger
	{
		private static var _instance:ErrorLogger;
		private static var _allowInstance:Boolean = false;
		
		private var _errorsCount:int = 0;
		
		private const ERRORS_URL:String = "";
		private var _statusLoaded:String = "unknown status";
		
		public function ErrorLogger()
		{
			if (!_allowInstance)
			{
				throw new Error("Error: Use ErrorLogger.getInstance() instead of the new keyword.");
			}
		}
		
		static public function getInstance():ErrorLogger
		{
			if (!_instance)
			{
				_allowInstance = true;
				_instance = new ErrorLogger();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function errorHandler(e:UncaughtErrorEvent):void
		{
			//trace("111");
			e.preventDefault();
			//trace("222");
			
			if (!e.error.getStackTrace()) //ErrorEvent
				return;
			
			sendError(e.error as Error);
		}
		
		public function sendError(error:Error):void
		{
			var date:Date = new Date();
			date.setHours(date.getHours() + date.getTimezoneOffset() / 60); //UTC
			date.setHours(date.getHours() + 3); //MSK
			const time:String = DateFormat.formatDate("H:i d.m.Y", date);
			var message:String = Capabilities.os + "\r" //
				+ Capabilities.version + "\r" //
				+ "Flash-player type: " + (Capabilities.isDebugger ? "[DEBUG]\r" : "[RELEASE]\r") //
				+ time + "\r" //
				+ "The time from beginning of session: [" + (int(getTimer() * 0.01) * 0.1) + " seconds]\r" //
				+ "The number of errors for session: [" + (_errorsCount + 1) + "]\r" //
				+ "Status game: [" + _statusLoaded + "]\r \r" //
				+ error.getStackTrace(); //
			
			_errorsCount++;
			
			trace("3: ================================================================");
			trace(message);
			trace("3: ================================================================");
			
			CONFIG::release
			{
				try
				{
					//var variables:URLVariables = new URLVariables();
					//variables['errno'] = error.errorID;
					//variables['uid'] = _id > 0 ? _id : 0;
					//variables['message'] = message;
					//
					//var request:URLRequest = new URLRequest();
					//request.url = ERRORS_URL;
					//request.method = URLRequestMethod.POST;
					//request.data = variables;
					//
					//var loader:URLLoader = new URLLoader();
					//loader.load(request);
				}
				catch (error:Error)
				{
					trace(error);
				}
			}
		}
		
		public function set statusLoaded(value:String):void
		{
			_statusLoaded = value;
		}
	}

}