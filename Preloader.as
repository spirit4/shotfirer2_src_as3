package
{
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.Tweener;
	import data.PreloaderRes;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.utils.getDefinitionByName;
	import utils.Analytics;
	import utils.ButtonImagePreloader;
	import utils.Functions;
	import utils.debug.ErrorLogger;
	import utils.SimpleAnimation;
	import utils.TextBox;
	
	public class Preloader extends MovieClip
	{
		private var _flame:SimpleAnimation;
		private var _hero:SimpleAnimation;
		private var _progress:Sprite;
		private var _percent:TextBox;
		private var _isComplete:Boolean;
		private var _prevDx:int;
		private var _fuse:Bitmap;
		
		[SWF(backgroundColor="#787878",frameRate="60",width="800",height="600")]
		
		public function Preloader():void
		{
			stop();
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, ErrorLogger.getInstance().errorHandler);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.showDefaultContextMenu = false;
			PreloaderRes.init();
			
			addChild(new Bitmap(PreloaderRes.preloaderImages[0]));
			
			_progress = new Sprite();
			_progress.y = 435;
			_progress.addChild(new Bitmap(PreloaderRes.preloaderImages[1]));
			_progress.scrollRect = new Rectangle(0, 0, 800, 14);
			
			const bitmap:Bitmap = new Bitmap(PreloaderRes.preloaderImages[2]);
			addChild(bitmap);
			bitmap.y = 435;
			_fuse = bitmap;
			
			addChild(_progress);
			
			_flame = new SimpleAnimation(PreloaderRes.preloaderImages[3], new Rectangle(0, 0, 64, 64));
			addChild(_flame);
			_flame.x = 0 - 32;
			_flame.y = 409;
			_flame.play();
			
			_hero = new SimpleAnimation(PreloaderRes.preloaderImages[6], new Rectangle(0, 0, 48, 64));
			addChild(_hero);
			_hero.x = 0 - 24 + 60;
			_hero.y = 380;
			_hero.play();
			
			_percent = new TextBox(300, 30, 20, 0xE6BF79, "", "0%", "center", true);
			_percent.x = 250;
			_percent.y = 465;
			addChild(_percent);
			
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			Analytics.instance.init(this);
		}
		
		private function completeHandler(event:Event = null):void
		{
			_isComplete = true;
			gotoAndStop(currentFrame + 1);
		}
		
		private function enterFrameHandler(e:Event):void
		{
			progressHandler();

			if (_flame)
			{
				_flame.update();
				_hero.update();
				
				const rect:Rectangle = _progress.scrollRect;
				rect.x = int(_flame.x + 32);
				rect.width = 808 - _flame.x;
				_progress.x = rect.x;
				_progress.scrollRect = rect;
			}
			
			//trace("[_isComplete]",_isComplete, _flame.x, currentFrame);
			if (_isComplete && _flame.x >= 768 && currentFrame >= 2)
			{
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				
				stop();
				
				removeChild(_flame);
				_flame = null;
				removeChild(_fuse);
				_fuse = null;
				removeChild(_hero);
				_hero = null;
				
				
				_percent.text = "Curiosity killed the cat";
				
				if (!Functions.isUrl(["fgl.com", "testovy.ru", "flashgamelicense.com"]))
				{
					return;
				}
				
				_percent.visible = false;
				
				addButtonPlay();
			}
			
			if (loaderInfo && loaderInfo.bytesLoaded == loaderInfo.bytesTotal)
				completeHandler();
		}
		
		private function addButtonPlay():void
		{
			Analytics.pushPage(Analytics.LOADED);
			Analytics.forcePage(); // before juggler
			
			ColorShortcuts.init();
			DisplayShortcuts.init();
			
			const button:ButtonImagePreloader = new ButtonImagePreloader(PreloaderRes.preloaderImages[4], PreloaderRes.preloaderImages[5], true);
			addChild(button);
			button.x = 800 - button.width >> 1;
			button.y = 390;
			button.addEventListener(MouseEvent.CLICK, downHandler);
		}
		
		private function downHandler(e:MouseEvent = null):void
		{
			e.currentTarget.removeEventListener(MouseEvent.CLICK, downHandler);
			
			const button:Sprite = e.currentTarget as Sprite;
			removeChild(button);
			
			_percent.text = "initialization...";
			_percent.changeSize(16);
			//_percent.y = 360;
			
			e.updateAfterEvent();
			
			_percent.addEventListener(Event.ENTER_FRAME, startInit);
		}
		
		private function startInit(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.ENTER_FRAME, startInit);
			
			const localDomainLC:LocalConnection = new LocalConnection();
			const url:String = localDomainLC.domain;
			const domain_parts:Array = url.split("://");
			
			if(domain_parts[1])
				Analytics.pushPage(Analytics.PRELOADER_PLAY, domain_parts[1].toString());
			else
				Analytics.pushPage(Analytics.PRELOADER_PLAY, domain_parts[0].toString());
			
			const main:Class = getDefinitionByName("Main") as Class;
			addChild(new main(destroy));
			
			//destroy();
		}
		
		private function destroy():void
		{
			Tweener.removeTweens(_flame);
			Tweener.removeTweens(_hero);
			
			while (numChildren > 2)//remain bg
				removeChildAt(1);
				
			_percent = null;
			_progress = null;
			_flame = null;
			_hero = null;
		}
		
		private function progressHandler():void
		{
			_percent.text = int(loaderInfo.bytesLoaded * 100 / loaderInfo.bytesTotal) + "%";
			//trace(loaderInfo.bytesLoaded,loaderInfo.bytesTotal);
			
			if (!_flame)
				return;
			
			const dx:int = int(loaderInfo.bytesLoaded * 800 / loaderInfo.bytesTotal);
			if (_prevDx == dx)
				return;
			
			const flameX:int = dx - 32;
			
			Tweener.addTween(_flame, {x: flameX, time: 0.2, transition: "linear"});
			Tweener.addTween(_hero, {x: flameX + 60, time: 0.2, transition: "linear"});
			_prevDx = dx;
		}
	
	}
}