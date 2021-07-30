package view
{
	import caurina.transitions.Tweener;
	import data.AchievementController;
	import data.ApiKG;
	import data.Branding;
	import data.ImageRes;
	import data.Model;
	import effects.TransitionRockfall;
	import event.GameEvent;
	import event.WindowEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.Analytics;
	import utils.debug.Console;
	import utils.Statistics;
	import utils.TextBox;
	import view.hints.Tooltip;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class View extends Sprite
	{
		private var _data:Model;
		
		private var _currentWindow:Window;
		private var _currentPopup:Window;
		private var _game:Game;
		
		private var _pauseScreen:Sprite;
		private var _musicBeforePause:Boolean;
		
		private var _nextWindow:int = -1;
		private var _isRestart:Boolean;
		
		public function View()
		{
			_data = Controller.model;
		}
		
		public function init():void
		{
			Tooltip.getInstance().stage = stage;
			AchievementController.getInstance().init(stage, _data.progress);
			_data.ac = AchievementController.getInstance();
			stage.addEventListener(Event.DEACTIVATE, deactivateHandler);
			
			Branding.stage = stage;
			Tooltip.getInstance().stage = stage;
			
			SoundManager.getInstance().setLocation(SoundRes.THEME_MENU);
			
			if (Model.isDebug)
			{
				Model.console = new Console(800);
				stage.addChild(Model.console);
			}
			
			
			CONFIG::release
			{
				//addWindow(Window.LEVELS_SCREEN);
				addWindow(Window.MAIN_SCREEN);
				//startGame();
			}
			CONFIG::debug
			{
				//addWindow(Window.LEVELS_SCREEN);
				//addWindow(Window.MAIN_SCREEN);
				startGame();
			}
			
			//addEventListener(WindowEvent.FINISHED_EDITING, finishedEditingHandler);
		}
		
		//private function finishedEditingHandler(e:WindowEvent):void
		//{
			//e.stopPropagation();
			//
			//startGame();
		//}
		
		private function returnEditingHandler(e:WindowEvent):void
		{
			//stopGame();
			//addWindow(Window.EDITOR_SCREEN);
			stopGame();
			addWindow(Window.EDITOR_SCREEN);
			
		}
		
		private function deactivateHandler(e:Event = null):void
		{
			if (_data.globalState == Model.GLOBAL_PAUSE)
				return;
			
			stage.removeEventListener(Event.DEACTIVATE, deactivateHandler);
			
			addPauseScreen();
			//stage.addEventListener(WindowEvent.RETURN_TO_EDITING, returnEditingHandler);
			
			stage.addEventListener(Event.ACTIVATE, activateHandler);
		}
		
		private function addPauseScreen():void
		{
			_data.globalState = Model.GLOBAL_PAUSE;
			
			_musicBeforePause = SoundManager.getInstance().isMusic;
			if (_musicBeforePause)
				SoundManager.getInstance().isMusic = !SoundManager.getInstance().isMusic;
			
			_pauseScreen = new Sprite()
			addChild(_pauseScreen);
			_pauseScreen.alpha = 0;
			
			_pauseScreen.graphics.beginFill(0x1D1C10, 0.8);
			_pauseScreen.graphics.drawRect(0, 0, 800, 600);
			_pauseScreen.graphics.endFill();
			
			const textBox:Sprite = new Sprite();
			_pauseScreen.addChild(textBox);
			var tf:TextBox = new TextBox(250, 100, 48, 0xFFFFFF, "", "Pause", "center", true);
			textBox.addChild(tf);
			tf.changeKerning(0.4);
			tf = new TextBox(250, 100, 17, 0xFFFFFF, "", "click to continue", "center", true);
			textBox.addChild(tf);
			tf.x = -1;
			tf.y = 51;
			
			textBox.x = _pauseScreen.width - textBox.width >> 1;
			textBox.y = -100;
			
			Tweener.addTween(textBox, {y: 250, time: 0.3, transition: "easeInQuart"});
			Tweener.addTween(_pauseScreen, {alpha: 1, time: 0.3, transition: "linear"});
			
			_pauseScreen.addEventListener(MouseEvent.CLICK, clickClosePauseHandler);
		}
		
		private function clickClosePauseHandler(e:MouseEvent):void
		{
			hidePauseScreen();
		}
		
		private function hidePauseScreen():void
		{
			stage.focus = stage;
			
			if (_game)
				_data.globalState = Model.GLOBAL_GAME;
			else
				_data.globalState = Model.GLOBAL_IDLE;
			
			if (_pauseScreen)
			{
				if (_musicBeforePause)
					SoundManager.getInstance().isMusic = !SoundManager.getInstance().isMusic;
				
				_pauseScreen.removeEventListener(MouseEvent.CLICK, clickClosePauseHandler);
				
				Tweener.addTween(_pauseScreen.getChildAt(0), {y: -100, time: 0.3, transition: "easeInQuart", onComplete: removePauseScreen, onCompleteParams: [_pauseScreen]});
				Tweener.addTween(_pauseScreen, {alpha: 0, time: 0.3, transition: "linear"});
			}
		}
		
		private function removePauseScreen(object:DisplayObject):void
		{
			if (object.parent)
			{
				removeChild(object);
				
				if (object == _pauseScreen)
					_pauseScreen = null;
			}
		}
		
		private function activateHandler(e:Event = null):void
		{
			stage.removeEventListener(Event.ACTIVATE, activateHandler);
			
			hidePauseScreen();
			
			stage.addEventListener(Event.DEACTIVATE, deactivateHandler);
		}
		
		private function addWindow(type:uint, index:int = -1):void
		{
			_currentWindow = new Window(type, _data);
			
			if (index == -1)
				addChild(_currentWindow);
			else
				addChildAt(_currentWindow, index);
			
			_currentWindow.addEventListener(WindowEvent.GO_TO_WINDOW, goToWindowHandler);
			_currentWindow.addEventListener(WindowEvent.GO_TO_POPUP, goToPopup);
			_currentWindow.addEventListener(WindowEvent.SELECT_LEVEL, selectLevelHandler);
			_currentWindow.addEventListener(WindowEvent.RESET_LEVEL, restartGameHandler);
		}
		
		private function addPopup(type:uint):void
		{
			_currentPopup = new Window(type, _data);
			addChild(_currentPopup);
			_currentPopup.addEventListener(WindowEvent.GO_TO_WINDOW, goToWindowHandler);
			_currentPopup.addEventListener(WindowEvent.RESET_LEVEL, restartGameHandler);
			_currentPopup.addEventListener(WindowEvent.NEXT_LEVEL, nextLevelHandler);
		}
		
		private function selectLevelHandler(e:WindowEvent):void
		{
			_data.progress.currentLevel = e.window;
			
			removeHandlers();
			parent.addChild(new TransitionRockfall(e.window, startGame, _data)); //callback
		}
		
		private function nextLevelHandler(e:WindowEvent):void
		{
			removeHandlers();
			parent.addChild(new TransitionRockfall(_data.progress.currentLevel, goToNextLevel, _data)); //callback
		}
		
		private function goToNextLevel():void
		{
			_isRestart = true;
			
			removePopup();
			stopGame();
			
			removeWindow(_currentWindow);
			_currentWindow = null;
			
			startGame();
		}
		
		//-------------------------------
		public function update():void
		{
			if (_game)
				_game.update();
		}
		
		//-------------------------------
		
		private function startGame(e:WindowEvent = null):void
		{
			_data.progress.currentStar = 0;
			_data.progress.moneyAtLevel = 0;
			
			if (!_isRestart)
				SoundManager.getInstance().setLocation(SoundRes.THEME_GAME);
			
			_isRestart = false;
			
			Analytics.pushPage(Analytics.LEVEL_START, (_data.progress.currentLevel + 1).toString());
			
			removeHandlers();
			if (_currentWindow)
				removeWindow(_currentWindow);
			_currentWindow = null;
			
			_game = new Game();
			
			addChildAt(_game, 0);
			_game.addEventListener(GameEvent.HERO_TO_EXIT, levelCompleteHandler);
			_game.addEventListener(GameEvent.HERO_DEAD, levelFailedHandler);
			
			addWindow(Window.GUI_SCREEN, 1);
			
			//stage.addEventListener(WindowEvent.RETURN_TO_EDITING, returnEditingHandler);
			stage.addEventListener(WindowEvent.RETURN_TO_MENU, returnMenuHandler);
			
			//if (_data.progress.currentLevel == 29)//temp!!!!!!!!!!
				_game.addEventListener(GameEvent.GAME_COMPLETE, gameCompleteHandler);
			
			dispatchEvent(new GameEvent(GameEvent.CHANGE_LEVEL, true));
			
			addEventListener(WindowEvent.PAUSE, pauseClickHandler);
			
			_data.globalState = Model.GLOBAL_GAME;
		}
		
		private function pauseClickHandler(e:WindowEvent):void
		{
			e.stopPropagation();
			
			deactivateHandler();
		}
		
		private function gameCompleteHandler(e:GameEvent):void
		{
			removeHandlers();
			removeWindow(_currentWindow);
			_currentWindow = null;
			
			stopGame();
			
			_data.progress.isGameComplete = true;
			addWindow(Window.END_SCREEN);
			
			ApiKG.sendCompleteGame();
		}
		
		private function returnMenuHandler(e:WindowEvent):void
		{
			stage.removeEventListener(WindowEvent.RETURN_TO_MENU, returnMenuHandler);
			_nextWindow = Window.LEVELS_SCREEN;
			removeHandlers();
			parent.addChild(new TransitionRockfall(-1, goToWindow)); //callback
		}
		
		private function levelFailedHandler(e:GameEvent):void
		{
			restartGameHandler();
		}
		
		private function restartGameHandler(e:WindowEvent = null):void
		{
			if (_currentPopup && _currentPopup.type == Window.VICTORY_POPUP)
			{
				_data.progress.currentLevel--;
			}
			
			Statistics.lvlRetries++; //!!!!---------
			Statistics.jumpAuto = 0;
			Statistics.bonusArrows = 0;
			Statistics.bonusMouse = 0;
			Statistics.crawlAuto = 0;
			Statistics.crawlButton = 0;
			Statistics.tntCtrl = 0;
			Statistics.tntPerLvl = 0;
			Statistics.tntSpace = 0;
			Statistics.tntZ = 0;
			
			//trace("2: Statistics.lvlRetries",Statistics.lvlRetries)
			removeHandlers();
			parent.addChild(new TransitionRockfall(_data.progress.currentLevel, restartGame, _data)); //callback
		}
		
		private function restartGame():void
		{
			if (_currentPopup)
				removePopup();
			
			_isRestart = true;
			
			stopGame();
			startGame();
		}
		
		private function levelCompleteHandler(e:GameEvent):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			removeHandlers();
			
			addPopup(Window.VICTORY_POPUP);
			
			Controller.juggler.addCall(doSaveInNextFrame, 0);
		}
		
		private function doSaveInNextFrame():void
		{
			Controller.juggler.removeCall(doSaveInNextFrame);
			_data.goToNextLevel();
		}
		
		private function stopGame():void
		{
			_data.globalState = Model.GLOBAL_IDLE;
			
			if (!_isRestart)
				SoundManager.getInstance().setLocation(SoundRes.THEME_MENU);
			
			removeEventListener(WindowEvent.PAUSE, pauseClickHandler);
			stage.removeEventListener(WindowEvent.RETURN_TO_MENU, returnMenuHandler);
			
			_data.destroyLevel();
			
			removeChild(_game);
			_game = null;
		}
		
		private function removeWindow(window:Window):void
		{
			removeChild(window);
		}
		
		private function removePopup():void
		{
			removeChild(_currentPopup);
			_currentPopup = null;
		}
		
		private function goToWindowHandler(e:WindowEvent):void
		{
			_nextWindow = e.window;
			
			removeHandlers();
			trace("goToWindow")
			parent.addChild(new TransitionRockfall(-1, goToWindow)); //callback
		}
		
		private function goToWindow():void
		{
			if (_currentPopup)
				removePopup();
			
			if (_nextWindow == _currentWindow.type)
				return;
			
			removeWindow(_currentWindow);
			_currentWindow = null;
			
			if (_game) //close game
				stopGame();
			
			addWindow(_nextWindow);
		}
		
		private function goToPopup(e:WindowEvent):void
		{
			if (e.window == Window.CREDITS_POPUP)
			{
				addPopup(e.window);
				_currentPopup.removeEventListener(WindowEvent.GO_TO_WINDOW, goToWindowHandler);
				_currentPopup.removeEventListener(WindowEvent.RESET_LEVEL, restartGameHandler);
				_currentPopup.removeEventListener(WindowEvent.NEXT_LEVEL, nextLevelHandler);
				_currentPopup = null;
				return;
			}
			
			if (_currentPopup)
				removePopup();
			else
				addPopup(e.window);
		}
		
		private function removeHandlers():void
		{
			if (_currentWindow)
			{
				_currentWindow.removeEventListener(WindowEvent.GO_TO_WINDOW, goToWindowHandler);
				_currentWindow.removeEventListener(WindowEvent.GO_TO_POPUP, goToPopup);
				_currentWindow.removeEventListener(WindowEvent.SELECT_LEVEL, selectLevelHandler);
				_currentWindow.removeEventListener(WindowEvent.RESET_LEVEL, restartGameHandler);
			}
			
			if (_currentPopup)
			{
				_currentPopup.removeEventListener(WindowEvent.GO_TO_WINDOW, goToWindowHandler);
				_currentPopup.removeEventListener(WindowEvent.RESET_LEVEL, restartGameHandler);
				_currentPopup.removeEventListener(WindowEvent.NEXT_LEVEL, nextLevelHandler);
			}
			if (_game)
			{
				_game.removeEventListener(GameEvent.HERO_TO_EXIT, levelCompleteHandler);
				_game.removeEventListener(GameEvent.HERO_DEAD, levelFailedHandler);
				_game.removeEventListener(GameEvent.GAME_COMPLETE, gameCompleteHandler);
			}
		}
	
	}

}