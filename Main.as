package
{
	import data.Model;
	import data.PreloaderRes;
	import effects.TransitionRockfall;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.geom.Rectangle;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import utils.debug.ErrorLogger;
	
	/**
	 * ...
	 * @author spirit2
	 */
	
	CONFIG::release
	{
		[Frame(factoryClass="Preloader")]
	}
	[SWF(backgroundColor="#787878",frameRate="60",width="800",height="600")]
	
	public class Main extends Sprite
	{
		//[Embed(source="../swf/FG_splashscreen_as3-v1_3_18a-shotfirer.swf",mimeType="application/octet-stream")]
		//public static var Splash:Class;
		
		//private var _ads:MovieClip;
		//private var _loader:Loader;
		private var _controller:Controller;
		private var _preloaderDestroyCallback:Function;
		
		public function Main(callback:Function=undefined):void
		{
			_preloaderDestroyCallback = callback;
			//Security.allowDomain("*");
			//Security.allowInsecureDomain("*");
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//CONFIG::release
			//{
				//_loader = new Loader();
				//_loader.loadBytes(new Splash() as ByteArray);
				//_loader.contentLoaderInfo.addEventListener(Event.INIT, onSwfLoaded);
				//addChild(_loader);
			//}
			//CONFIG::debug
			//{
				gameInit();
			//}
		}
		
		//private function onSwfLoaded(e:Event):void
		//{
			//_loader.contentLoaderInfo.removeEventListener(Event.INIT, onSwfLoaded);
			//
			//var mc:MovieClip = _loader.content as MovieClip;
			//addChild(mc)
			//_ads = mc;
			//
			///////////////////DONT EDIT///////////////////////
			//var adManagerUrlArray:Array = ['http://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/1015413/AShotfirer&ciu_szs&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=[referrer_url]&correlator=[timestamp]', 'http://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/1015413/BShotfirer&ciu_szs&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=[referrer_url]&correlator=[timestamp]', 'http://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/1015413/CShotfirer&ciu_szs&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=[referrer_url]&correlator=[timestamp]', 'http://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/1015413/DShotfirer&ciu_szs&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=[referrer_url]&correlator=[timestamp]'];
			//
			//var targetingOptions:Object = {};
			//targetingOptions.adtype = "preroll";
			//
			//var stageWidthPrm = stage.stageWidth;
			//var stageHeightPrm = stage.stageHeight;
			//var gameName = "shotfirer";
			//var gameID = 21545;
			////var mochibotCode = "no_mochibot";
			//var playButtonOn = false;
			//var onTibacoNetworkOverride = false;
			//
			//var adsFooterBackgroundColor = "0x75653e";
			//var clickableAfterSeconds = 20;
			////////////////////////////////////////////////
			//
			//mc.initSplashScreen(stageWidthPrm, stageHeightPrm, adManagerUrlArray, targetingOptions, adsFooterBackgroundColor, clickableAfterSeconds, gameName, gameID, playButtonOn, onTibacoNetworkOverride, gameInit);
		//
		//}
		
		private function gameInit():void
		{
			_controller = new Controller();
			
			CONFIG::debug
			{
				//trace("gameInit] ", loaderInfo);
				loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, ErrorLogger.getInstance().errorHandler);
				
				addChildAt(_controller.view, 0);
				return;
			}
			
			addChild(new TransitionRockfall(-1, gameStart)); //callback

		}
		
		private function gameStart():void
		{
			PreloaderRes.destroy();
			_preloaderDestroyCallback();
			addChildAt(_controller.view, 0);
			
			CONFIG::release
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.showDefaultContextMenu = false;
				this.scrollRect = new Rectangle(0, 0, 800, 600);
				
				//controller.view.y = -480;
				//Tweener.addTween(controller.view, { y: 0, time: 0.8, transition: "easeOutQuart", onComplete: hideSplash } );
				//hideSplash();
			}
		}
		
		//private function hideSplash():void
		//{
			//this.parent.removeChildAt(0); //remove preloaderBg
			//_ads.stop();
			//removeChild(_ads);
			//removeChild(_loader)
			//_ads = null;
			//_loader = null;
		//}
	}

}