package units
{
	import data.Model;
	import event.GameEvent;
	import event.WindowEvent;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import nape.space.Space;
	import sound.SoundManager;
	import units.Hero;
	import utils.Statistics;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class HeroController
	{
		private var _stage:Stage;
		private var _space:Space;
		private var _hero:Hero;
		
		private var _leftKeyDown:Boolean;
		private var _upKeyDown:Boolean;
		private var _rightKeyDown:Boolean;
		private var _downKeyDown:Boolean;
		private var _spaceKeyDown:Boolean;
		
		public var isFail:Boolean;
		
		private var _isToExit:Boolean;
		private var _isSetTNT:Boolean;
		private var _isToStairs:Boolean;
		private var _isToGround:Boolean;
		private var _isTopToStairs:Boolean;
		private var _isTopToGround:Boolean;
		
		private var _isTouchingGround:Boolean;
		private var _isTouchingBox:Boolean;
		
		public function HeroController(stage:Stage, space:Space, hero:Hero)
		{
			_stage = stage;
			_space = space;
			_hero = hero;
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
		}
		
		private function isExit():Boolean
		{
			if (_isToExit)
			{
				_hero.states.changeState(States.GO_OFF);
				_hero.view.addEventListener(Event.COMPLETE, exitHandler);
				
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
				_stage.removeEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
				
				return true;
			}
			return false;
		}
		
		private function exitHandler(e:Event):void
		{
			_hero.view.removeEventListener(Event.COMPLETE, exitHandler);
			_hero.view.visible = false;
			
			_hero.dispatchEvent(new GameEvent(GameEvent.HERO_TO_EXIT, true));
		}
		
		private function checkKeysDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ESCAPE)
			{
				//_stage.dispatchEvent(new WindowEvent(WindowEvent.RETURN_TO_EDITING));
				_stage.dispatchEvent(new WindowEvent(WindowEvent.RETURN_TO_MENU));
				return;
			}
			
			if (e.keyCode == Keyboard.R)
			{
				_hero.dispatchEvent(new GameEvent(GameEvent.HERO_DEAD, true));
				return;
			}
			
			if (e.keyCode == Keyboard.M)
			{
				SoundManager.getInstance().isMusic = !SoundManager.getInstance().isMusic;
				SoundManager.getInstance().isSFX = !SoundManager.getInstance().isSFX;
				return;
			}
			
			if (e.keyCode == Keyboard.P || e.keyCode == 19)
			{
				_hero.dispatchEvent(new WindowEvent(WindowEvent.PAUSE, true));
				return;
			}
			
			CONFIG::debug
			{
				if (e.keyCode == Keyboard.Q)
					Model.isDebug = !Model.isDebug;
			}
			
			if (Model.isDebug && e.keyCode == Keyboard.C)
					Model.console.visible = !Model.console.visible;
			
			
			if (e.keyCode == 37 || e.keyCode == 65) //left---------
				_leftKeyDown = true;
			
			if (e.keyCode == 39 || e.keyCode == 68) //right---------
				_rightKeyDown = true;
			
			if (e.keyCode == 38 || e.keyCode == 87) //up---------
			{
				_upKeyDown = true;
				
				if (isExit())
					return;
			}
			
			if (e.keyCode == 40 || e.keyCode == 83) //down---------
				_downKeyDown = true;
			
			if (e.keyCode == Keyboard.Z || e.keyCode == Keyboard.SPACE || e.keyCode == Keyboard.CONTROL)
			{
				if (e.keyCode == Keyboard.Z)
					Statistics.tntZ++;
				else if (e.keyCode == Keyboard.SPACE)
					Statistics.tntSpace++;
				else if (e.keyCode == Keyboard.CONTROL)
					Statistics.tntCtrl++;
				
				_spaceKeyDown = true;
			}
			
			_hero.states.keyStates = {left: _leftKeyDown, right: _rightKeyDown, up: _upKeyDown, down: _downKeyDown, space: _spaceKeyDown};
			
			checkSetTNT();
		}
		
		private function checkKeysUp(e:KeyboardEvent):void
		{
			if (e.keyCode == 37 || e.keyCode == 65) //left---------
				_leftKeyDown = false;
			
			if (e.keyCode == 39 || e.keyCode == 68) //right---------
				_rightKeyDown = false;
			
			if (e.keyCode == 38 || e.keyCode == 87) //up---------
				_upKeyDown = false;
			
			if (e.keyCode == 40 || e.keyCode == 83) //down---------
				_downKeyDown = false;
			
			if (e.keyCode == Keyboard.Z || e.keyCode == Keyboard.SPACE || e.keyCode == Keyboard.CONTROL)
			{
				_isSetTNT = false;
				_spaceKeyDown = false;
			}
			
			_hero.states.keyStates = {left: _leftKeyDown, right: _rightKeyDown, up: _upKeyDown, down: _downKeyDown, space: _spaceKeyDown};
		}
		
		private function checkSetTNT():void
		{
			var ev:GameEvent;
			
			if (!_isSetTNT && _spaceKeyDown)
			{
				ev = new GameEvent(GameEvent.SET_DYNAMITE);
				
				_isSetTNT = true;
				if (_hero.states.currentState == States.SIT || _hero.states.currentState == States.SIT_AT_ONCE)
				{
					ev.index = 0;
					_hero.dispatchEvent(ev);
				}
				else if (_hero.states.currentState == States.ARM_UP || _hero.states.currentState == States.LYING_UP)
				{
					ev.index = _hero.states.directionTNT;
					_hero.dispatchEvent(ev);
				}
			}
		
		}
		
		//======================================================================================================================
		public function update():void
		{
			if (_hero)
				_hero.update();
			
			if (isFail)
			{
				_hero.dispatchEvent(new GameEvent(GameEvent.HERO_DEAD, true));
				isFail = false;
			}
		}
		
		public function set isToStairs(value:Boolean):void
		{
			if (_isToStairs == value)
				return;
			_isToStairs = value;
			
			_hero.states.isToStairs = _isToStairs;
		}
		
		public function set isTopToStairs(value:Boolean):void
		{
			if (_isTopToStairs == value)
				return;
			_isTopToStairs = value;
			
			_hero.states.isTopToStairs = _isTopToStairs;
		}
		
		public function set isTopToGround(value:Boolean):void
		{
			if (_isTopToGround == value)
				return;
			_isTopToGround = value;
			
			_hero.states.isTopToGround = _isTopToGround;
		}
		
		public function set isToGround(value:Boolean):void
		{
			if (_isToGround == value)
				return;
			_isToGround = value;
			
			_hero.states.isToGround = _isToGround;
		}
		
		public function set isTouchingBox(value:Boolean):void
		{
			if (_isTouchingBox == value)
				return;
			_isTouchingBox = value;
			
			_hero.states.isTouchingBox = _isTouchingBox;
		}
		
		public function set isTouchingGround(value:Boolean):void
		{
			
			if (_isTouchingGround == value)
				return;
				
			_isTouchingGround = value;
			//trace("[set] isTouchingGround: ", value, _isTouchingGround);
			_hero.states.isTouchingGround = _isTouchingGround;
		}
		
		public function set isToExit(value:Boolean):void 
		{
			if (_isToExit == value)
				return;
			_isToExit = value;
			
			_hero.states.isToExit = _isToExit;
		}
		
		public function destroy():void
		{
			if (_hero.view)
				_hero.view.removeEventListener(Event.COMPLETE, exitHandler);
			
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
			_stage = null;
			_space = null;
			_hero = null;
		}
	}

}