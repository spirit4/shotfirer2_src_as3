package
{
	import data.AnimationRes;
	import data.ApiKG;
	import data.Branding;
	import data.ImageRes;
	import data.JSONRes;
	import data.Model;
	import data.PreloaderRes;
	import event.WindowEvent;
	import flash.events.Event;
	import nape.util.BitmapDebug;
	import sound.SoundRes;
	import utils.Analytics;
	import utils.Functions;
	import utils.Juggler;
	import view.View;
	
	import com.newgrounds.*;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Controller
	{
		private var _view:View;
		private var _data:Model;
		private var _juggler:Juggler;
		
		static private var _instance:Controller;
		
		public function Controller()
		{
			JSONRes.init();
			ImageRes.init();
			AnimationRes.init();
			SoundRes.init();
			
			_instance = this;
			
			_data = new Model();
			_view = new View();
			_juggler = new Juggler();
			
			if(Analytics.analyticsIsEnabled)
				_juggler.add(Analytics.instance); //for update
			
			if (_view.stage)
				init();
			else
				_view.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			_view.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_view.stage.addEventListener(Event.ENTER_FRAME, update);
			
			
			if (Functions.isUrl(["kongregate.com"]))
			{
				Branding.isKGorNG = true;
				ApiKG.connect(_view.stage, connectedApiKG);
			}
			
			if (Functions.isUrl(["newgrounds.com", "uploads.ungrounded.net"]))
			{
				Branding.isKGorNG = true;
				API.debugMode = API.RELEASE_MODE;
				API.addEventListener(APIEvent.API_CONNECTED, onAPIConnected);
				API.connect(_view.stage.getChildAt(0), "35610:0pDd85G2", "hjhuL3KrGk5phsis3XyN8wlictREpkTO");
			}
			
			_view.init();
		}
		
		private function connectedApiKG(isConnect:Boolean):void //if complete
		{
			Branding.isConnectedKGorNG = isConnect;
		}
		
		private function onAPIConnected(e:APIEvent):void 
		{
			if(e.success)
			{
				Branding.isConnectedKGorNG = true;
				trace("The API is connected and ready to use!");
			}
			else
				trace("Error connecting to the API: " + e.error);
		}
		
		private function update(e:Event):void 
		{
			if(_data.globalState == Model.GLOBAL_GAME)
			{
				_data.update();
				_view.update();
			}
				
			//if(_data.globalState != Model.GLOBAL_PAUSE)
				_juggler.update();
		}
		
		public function get view():View
		{
			return _view;
		}
		
		public function get model():Model
		{
			return _data;
		}
		
		public function get juggler():Juggler
		{
			return _juggler;
		}
		
		static public function get model():Model
		{
			return _instance.model;
		}
		
		static public function get juggler():Juggler
		{
			return _instance.juggler;
		}
		
	}

}