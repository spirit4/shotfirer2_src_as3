package view
{
	import data.Branding;
	import data.Model;
	//import editor.Editor;
	import event.WindowEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import utils.Analytics;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Window extends Sprite
	{
		static public const NONE:uint = 0;
		static public const EDITOR_SCREEN:uint = 1;
		static public const MAIN_SCREEN:uint = 2;
		static public const GUI_SCREEN:uint = 3;
		static public const INTRO_SCREEN:uint = 4;
		
		static public const LEVELS_SCREEN:uint = 5;
		static public const ACHIEVEMENTS_SCREEN:uint = 6;
		static public const END_SCREEN:uint = 7;
		static public const SHOP_SCREEN:uint = 8;
		
		static public const VICTORY_POPUP:uint = 9;
		static public const CREDITS_POPUP:uint = 10;
		
		//actions
		static public const NEXT_LEVEL:uint = 1;
		static public const RESET_LEVEL:uint = 2;
		static public const PAUSE:uint = 3;
		
		private var _viewSprite:Sprite;
		private var _data:Model;
		
		private var _nextWindow:Dictionary = new Dictionary();
		private var _nextAction:Dictionary = new Dictionary();
		private var _nextLevel:Dictionary = new Dictionary();
		
		private var _type:int;
		private var _stateKeys:Object;
		
		public function Window(type:int, data:Model)
		{
			_type = type; //for trace check
			_data = data;
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addView(_type);
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function addView(type:uint):void
		{
			switch (type)
			{
				//case EDITOR_SCREEN: 
					//const win:Editor = new Editor(_data);
					//_viewSprite = win;
					//break;
				
				case MAIN_SCREEN: 
					const main:MainMenu = new MainMenu();
					_viewSprite = main;
					
					_nextWindow[main.play] = INTRO_SCREEN;

					_nextWindow[main.credits] = CREDITS_POPUP;
					break;
				
				case GUI_SCREEN: 
					const gui:GUI = new GUI(_data.progress);
					_viewSprite = gui;
					
					_nextAction[gui.pause] = PAUSE;
					_nextAction[gui.reset] = RESET_LEVEL;
					_nextWindow[gui.menu] = SHOP_SCREEN;
					break;
				
				case CREDITS_POPUP: 
					const cre:Credits = new Credits();
					_viewSprite = cre;
					break;
				
				case INTRO_SCREEN: 
					const intro:Story = new Story();
					_viewSprite = intro;
					
					_nextWindow[intro.next] = LEVELS_SCREEN;
					_viewSprite.addEventListener(WindowEvent.INTRO_DONE, introDoneHandler);
					break;
				
				case LEVELS_SCREEN: 
					const lvl:Levels = new Levels(_data.progress, _nextLevel);
					_viewSprite = lvl;
					
					_nextWindow[lvl.back] = MAIN_SCREEN;
					_nextWindow[lvl.shop] = SHOP_SCREEN;
					_nextWindow[lvl.achievements] = ACHIEVEMENTS_SCREEN;
					break;
					
				case SHOP_SCREEN: 
					const shop:Shop = new Shop(_data.progress);
					_viewSprite = shop;
					
					_nextWindow[shop.back] = MAIN_SCREEN;
					_nextWindow[shop.levels] = LEVELS_SCREEN;
					_nextWindow[shop.achievements] = ACHIEVEMENTS_SCREEN;
					break;
				
				case ACHIEVEMENTS_SCREEN: 
					const ach:Achievements = new Achievements(_data.progress);
					_viewSprite = ach;
					
					_nextWindow[ach.back] = MAIN_SCREEN;
					_nextWindow[ach.levels] = LEVELS_SCREEN;
					_nextWindow[ach.shop] = SHOP_SCREEN;
					break;
				
				case END_SCREEN: 
					const end:TheEnd = new TheEnd(_data.progress);
					_viewSprite = end;
					
					_nextWindow[end.back] = MAIN_SCREEN;
					break;
				
				case VICTORY_POPUP: 
					const vic:Victory = new Victory(_data.progress);
					_viewSprite = vic;
					
					_nextWindow[vic.shop] = SHOP_SCREEN;
					_nextAction[vic.reset] = RESET_LEVEL;
					_nextAction[vic.next] = NEXT_LEVEL;
					
					listenKeyboard();
					break;
				
				default: 
					throw new Error("unknow window");
			}
			
			addChild(_viewSprite);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function introDoneHandler(e:WindowEvent):void
		{
			var ev:WindowEvent;
			ev = new WindowEvent(WindowEvent.GO_TO_WINDOW);
			ev.window = LEVELS_SCREEN;
			dispatchEvent(ev);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			if (Branding.isShowingAds)
				return;
			
			stage.focus = stage;
			
			if (_nextWindow[e.target])
				chooseWindow(e.target as DisplayObject);
			else if (_nextAction[e.target])
				chooseAction(e.target as DisplayObject);
			else if (_nextLevel[e.target])
				chooseLevel(e.target as DisplayObject);
		}
		
		private function chooseAction(object:DisplayObject):void
		{
			var ev:WindowEvent;
			if (_nextAction[object] == RESET_LEVEL)
			{
				//Analytics.pushPage(Analytics.CLICK_RESET);
				
				ev = new WindowEvent(WindowEvent.RESET_LEVEL);
				dispatchEvent(ev);
			}
			else if (_nextAction[object] == NEXT_LEVEL)
			{
				ev = new WindowEvent(WindowEvent.NEXT_LEVEL);
				dispatchEvent(ev);
			}
			else if (_nextAction[object] == PAUSE)
			{
				//Analytics.pushPage(Analytics.CLICK_PAUSE);
				
				ev = new WindowEvent(WindowEvent.PAUSE, true);
				dispatchEvent(ev);
			}
		}
		
		private function chooseLevel(object:DisplayObject):void
		{
			const ev:WindowEvent = new WindowEvent(WindowEvent.SELECT_LEVEL);
			ev.window = _nextLevel[object] - 1; //0 dont be
			
			dispatchEvent(ev);
		}
		
		private function chooseWindow(object:DisplayObject):void
		{
			var ev:WindowEvent;
			if (_nextWindow[object] < VICTORY_POPUP)
			{
				ev = new WindowEvent(WindowEvent.GO_TO_WINDOW);
				ev.window = _nextWindow[object];
				dispatchEvent(ev);
			}
			else
			{
				ev = new WindowEvent(WindowEvent.GO_TO_POPUP);
				ev.window = _nextWindow[object];
				dispatchEvent(ev);
			}
		}
		
		private function listenKeyboard():void
		{
			_stateKeys = new Object();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
		}
		
		private function checkKeysDown(e:KeyboardEvent):void
		{
			if (Branding.isShowingAds)
				return;
			
			if (e.keyCode == Keyboard.R)
			{
				if (!_stateKeys[Keyboard.R])
				{
					_stateKeys[Keyboard.R] = true;
					dispatchEvent(new WindowEvent(WindowEvent.RESET_LEVEL));
					return;
				}
			}
			if (e.keyCode == Keyboard.ESCAPE)
			{
				if (!_stateKeys[Keyboard.ESCAPE])
				{
					_stateKeys[Keyboard.ESCAPE] = true;
					
					var ev:WindowEvent;
					ev = new WindowEvent(WindowEvent.GO_TO_WINDOW);
					ev.window = LEVELS_SCREEN;
					dispatchEvent(ev);
					
					return;
				}
			}
			if (e.keyCode == Keyboard.SPACE || e.keyCode == Keyboard.Z || e.keyCode == Keyboard.CONTROL || e.keyCode == Keyboard.ENTER)
			{
				if (!_stateKeys[Keyboard.SPACE])
				{
					//if ((_data.progress.currentLevel) % 6 == 0 && _data.progress.currentLevel < 30) //ads
					//{
					(_viewSprite as Victory).nextClickhandler();
					return;
					//}
					
					_stateKeys[Keyboard.SPACE] = true;
					dispatchEvent(new WindowEvent(WindowEvent.NEXT_LEVEL));
					return;
				}
			}
		}
		
		private function checkKeysUp(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.R)
				_stateKeys[Keyboard.R] = false;
			
			if (e.keyCode == Keyboard.ESCAPE)
				_stateKeys[Keyboard.ESCAPE] = false;
			
			if (e.keyCode == Keyboard.SPACE || e.keyCode == Keyboard.Z || e.keyCode == Keyboard.CONTROL || e.keyCode == Keyboard.ENTER)
				_stateKeys[Keyboard.SPACE] = false;
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListener(MouseEvent.CLICK, clickHandler);
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
			
			graphics.clear();
			
			removeChild(_viewSprite);
			
			_stateKeys = null;
			_nextWindow = null;
			_nextAction = null;
			_nextLevel = null;
			
			_viewSprite = null;
			_data = null;
		}
		
		public function get type():int
		{
			return _type;
		}
	}

}