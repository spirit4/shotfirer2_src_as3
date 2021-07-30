package units
{
	import data.AchievementController;
	import data.AnimationRes;
	import data.Model;
	import event.GameEvent;
	import flash.events.Event;
	import nape.geom.Vec2;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.Statistics;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class States
	{
		static public const IDLE_X:int = 0;
		static public const IDLE_Y:int = 1;
		static public const MOVE_X:int = 2;
		static public const MOVE_Y:int = 3;
		static public const SIT:int = 4;
		static public const RISE:int = 5;
		static public const IDLE_CREEP:int = 6;
		static public const CREEP:int = 7;
		static public const JUMP_UP:int = 8;
		static public const JUMP_IDLE:int = 9;
		static public const JUMP_DOWN:int = 10;
		static public const PUSH:int = 11;
		static public const ARM_UP:int = 12;
		static public const ARM_DOWN:int = 13;
		static public const LYING_UP:int = 14;
		static public const LYING_DOWN:int = 15;
		static public const SIT_AT_ONCE:int = 16;
		static public const DEATH_0:int = 17;
		static public const GO_OFF:int = 18;
		
		private var _actionStates:Vector.<Function> = new Vector.<Function>(GO_OFF + 1)
		private var _currentState:uint;
		
		private var _directionTNT:int = 1;
		private var _directionX:int = 1;
		private var _directionY:int = -1;
		
		private var _isToGround:Boolean = true;
		private var _isToStairs:Boolean;
		
		private var _isTopToStairs:Boolean;
		private var _isTopToGround:Boolean;
		
		private var _isTouchingGround:Boolean;
		private var _isTouchingBox:Boolean;
		
		private var _isToExit:Boolean;
		
		private var _keyStates:Object /*Boolean*/;
		
		private var _hero:Hero;
		
		//private var _counterChangeDirection:uint;
		private var _ladderOff:Boolean;
		
		public function States(hero:Hero)
		{
			_hero = hero;
			
			_keyStates = new Object();
			_keyStates.up = false;
			_keyStates.down = false;
			_keyStates.left = false;
			_keyStates.right = false;
			_keyStates.space = false;
			
			_actionStates[IDLE_X] = stopX;
			_actionStates[IDLE_Y] = stopY;
			_actionStates[IDLE_CREEP] = stopCreep;
			_actionStates[MOVE_X] = startMoveX;
			_actionStates[MOVE_Y] = startMoveY;
			_actionStates[CREEP] = startCreep;
			_actionStates[PUSH] = startPushBox;
			_actionStates[JUMP_UP] = startJump;
			_actionStates[JUMP_IDLE] = midJump;
			_actionStates[JUMP_DOWN] = stopJump;
			_actionStates[SIT] = sit;
			_actionStates[SIT_AT_ONCE] = sitAtOnce;
			_actionStates[RISE] = rise;
			_actionStates[ARM_UP] = armUp;
			_actionStates[ARM_DOWN] = armDown;
			_actionStates[LYING_UP] = lyingArmUp;
			_actionStates[LYING_DOWN] = lyingArmDown;
			_actionStates[DEATH_0] = die0;
			_actionStates[GO_OFF] = goOff;
			
			_directionX = _hero.base.position.x < 320 ? 1 : -1;
		}
		
		public function changeState(type:int):void
		{
			var ev:GameEvent;
			if (_currentState == SIT || _currentState == SIT_AT_ONCE || _currentState == ARM_UP || _currentState == LYING_UP)
			{
				ev = new GameEvent(GameEvent.HERO_SIT);
				ev.index = -2; //clear
				_hero.dispatchEvent(ev);
			}
			
			stopSoundLoop();
			
			_currentState = type; //!!!----------------------------------	
			
			if (_actionStates[_currentState] == null)
			{
				trace("unknown action state");
				return;
			}
			//trace(_currentState)
			_actionStates[_currentState](); //---------------------
			
			if (_currentState == SIT || _currentState == SIT_AT_ONCE || _currentState == ARM_UP || _currentState == LYING_UP)
			{
				ev = new GameEvent(GameEvent.HERO_SIT);
				
				if (_currentState == SIT || _currentState == SIT_AT_ONCE)
					ev.index = 0;
				else if (_currentState == ARM_UP || _currentState == LYING_UP)
					ev.index = _directionTNT;
				
				_hero.dispatchEvent(ev);
			}
			
			//trace("-----bodies---",_hero.bottomSensor.body.space.bodies.length)
		}
		
		private function stopSoundLoop():void
		{
			if (_currentState == MOVE_X || _currentState == MOVE_Y || _currentState == PUSH || _currentState == CREEP)
				SoundManager.getInstance().stopLoop();
		}
		
		private function startMoveX():void
		{
			if (_hero.isDust)
				SoundManager.getInstance().playLoop(SoundRes.LOOP_MOVE_SOFT);
			else
				SoundManager.getInstance().playLoop(SoundRes.LOOP_MOVE_SOLID);
			
			_hero.playView(AnimationRes.HERO_RIGHT);
		}
		
		private function startMoveY():void
		{
			SoundManager.getInstance().playLoop(SoundRes.LOOP_MOVE_STAIR);
			
			_hero.setNullMass();
				
			_hero.takeStairs();
			//trace("1111",_currentState)
			if (_directionY == 1)
				_hero.playView(AnimationRes.HERO_UP_AND_DOWN, true, false, true);
			else
				_hero.playView(AnimationRes.HERO_UP_AND_DOWN);
		}
		
		private function startCreep():void
		{
			_hero.setCreep();
			SoundManager.getInstance().playLoop(SoundRes.LOOP_CREEP);
			
			_hero.playView(AnimationRes.HERO_CREEP_RIGHT);
		}
		
		private function startPushBox():void
		{
			SoundManager.getInstance().playLoop(SoundRes.LOOP_BOX_MOVE);
			
			_hero.playView(AnimationRes.HERO_BOX_RIGHT);
		}
		
		private function moveX():void
		{
			_hero.top.velocity.x = 170 * _directionX;
		}
		
		private function creep():void
		{
			_hero.top.velocity.x = 60 * _directionX;
		}
		
		private function pushBox():void
		{
			_hero.top.velocity.x = 90 * _directionX;
		}
		
		private function moveY():void
		{
			_hero.top.velocity.y = 130 * _directionY;
		}
		
		private function moveJump():void
		{
			_hero.top.velocity.x = 130 * _directionX;
		}
		
		private function stopX():void
		{
			horizStop();

			_hero.playView(AnimationRes.HERO_RIGHT_IDLE);
		}
		
		private function stopY():void
		{
			vertStop();
			_hero.view.stop();
		}
		
		private function stopCreep():void
		{
			horizStop();
			_hero.view.stop();
		}
		
		private function horizStop():void
		{
			_hero.base.angularVel = 0;
			_hero.base.velocity.x = 0;
			_hero.top.velocity.x = 0;
		}
		
		private function vertStop():void
		{
			_hero.base.velocity.y = 0;
			_hero.top.velocity.y = 0;
		}
		
		private function startJump():void
		{
			vertStop();
			_hero.top.applyImpulse(Vec2.weak(0, -950));
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_JUMP);
			
			_hero.playView(AnimationRes.HERO_RIGHT_JUMP_UP, false);
		}
		
		private function midJump():void
		{
			//_counterChangeDirection++;
			
			//if (_counterChangeDirection == 3)
				//AchievementController.getInstance().addParam(AchievementController.CHANGE_3_DIRECTION);
			
			_hero.playView(AnimationRes.HERO_RIGHT_JUMP_IDLE, false);
		}
		
		private function stopJump():void
		{
			_hero.view.addEventListener(Event.COMPLETE, stopJumpHandler);

			_hero.playView(AnimationRes.HERO_RIGHT_JUMP_DOWN, false);
		}
		
		private function stopJumpHandler(e:Event):void
		{
			_hero.view.removeEventListener(Event.COMPLETE, stopJumpHandler);
			
			if (_hero.isDust)
				SoundManager.getInstance().playSFX(SoundRes.SFX_JUMP_GROUND);
			else
				SoundManager.getInstance().playSFX(SoundRes.SFX_JUMP_STONE);
			
			if (!_isTopToGround)
				_hero.setNoCreep();
			
			if (_keyStates.up && !_isToStairs && !_isToExit)
			{
				changeState(JUMP_UP);
				Statistics.jumpAuto++;
				return;
			}
				
			changeState(IDLE_X);
			listenerUpKeys();
		}
		
		private function sit():void
		{
			horizStop();
			
			_hero.playView(AnimationRes.HERO_DOWN_RIGHT, false);
		}
		
		private function sitAtOnce():void
		{
			_hero.setNoCreep();
			horizStop();
			
			_hero.playView(AnimationRes.HERO_DOWN_RIGHT, false, false, true);
			
			_hero.stopView();
			_hero.view.goToAndStop(-1);
		}
		
		private function rise():void
		{
			_hero.setNoCreep();
			
			_hero.playView(AnimationRes.HERO_DOWN_RIGHT, false, false, true);
			
			_hero.view.addEventListener(Event.COMPLETE, riseHamdler);
		}
		
		private function riseHamdler(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, riseHamdler);
			if (_currentState == RISE)
				changeState(IDLE_X);
		}
		
		private function armUp():void
		{
			horizStop();
			
			_hero.playView(AnimationRes.HERO_TNT_RIGHT, false);
		}
		
		private function armDown():void
		{
			_hero.playView(AnimationRes.HERO_TNT_RIGHT, false, false, true);
			
			_hero.view.addEventListener(Event.COMPLETE, outArmHandler);
		}
		
		private function outArmHandler(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, outArmHandler);
			if (_currentState == ARM_DOWN)
				changeState(IDLE_X);
		}
		
		private function lyingArmUp():void
		{
			horizStop();
			
			_hero.playView(AnimationRes.HERO_SIT_TNT_RIGHT_IN, false);
		}
		
		private function lyingArmDown():void
		{
			_hero.playView(AnimationRes.HERO_SIT_TNT_RIGHT_OUT, false);
		}
		
		private function die0():void
		{
			horizStop();

			_hero.playView(AnimationRes.HERO_RIGHT_IDLE);
			_hero.view.goToAndStop(0);
			_hero.playDeath();
		}
		
		private function goOff():void
		{
			horizStop();
			_hero.takeExit();
			_hero.playView(AnimationRes.HERO_GO_OFF, false);
		}
		
		//------------------------------------------------------------------------------
		//------------------------------------------------------------------------------
		public function update():void
		{
			if (_currentState == MOVE_X)
				moveX();
			
			if (_currentState == CREEP)
				creep();
			
			if (_currentState == PUSH)
			{
				pushBox();
				_hero.x -= 4 * _directionX;
			}
			
			if (_currentState == MOVE_Y) //&& (!_isTopToStairs || _directionY == 1))
				moveY();
			
			if (_currentState == JUMP_UP || _currentState == JUMP_IDLE)
			{
				if (_keyStates.left || _keyStates.right)
					moveJump();
			}
			
			if (_currentState == JUMP_UP)
				checkVertVelocity();
		}
		
		private function checkTouchGround():void
		{
			if (_isToGround)
				changeState(JUMP_DOWN);
		}
		
		private function checkVertVelocity():void
		{
			if (_hero.top.velocity.y > 0)
			{
				changeState(JUMP_IDLE);
			}
		}
		
		private function listenerDownKeys(key:String):void
		{
			switch (key)
			{
				case "left": 
					_directionX = -1;
					
					if ((_directionX != _directionTNT || !_isTouchingGround) && (_currentState == IDLE_X || _currentState == MOVE_X || _currentState == MOVE_Y || _currentState == IDLE_Y || _currentState == RISE || _currentState == ARM_UP || _currentState == ARM_DOWN))
						changeState(MOVE_X);
					
					if (_currentState == JUMP_UP || _currentState == JUMP_IDLE)
						changeState(JUMP_IDLE);
					
					if ((!_isTouchingBox || _directionX == _directionTNT) && (_currentState == IDLE_CREEP || _currentState == CREEP || _currentState == SIT || _currentState == SIT_AT_ONCE || _currentState == LYING_UP || _currentState == LYING_DOWN))
						changeState(CREEP);
					
					if (_isTouchingBox && (_currentState == MOVE_X || _currentState == JUMP_UP || _currentState == JUMP_IDLE))
						changeState(PUSH);
					
					if (_isTouchingGround && _currentState == IDLE_X)
						changeState(ARM_UP);
					
					if (_isTouchingGround && _directionX == _directionTNT && (_currentState == IDLE_CREEP || _currentState == CREEP))
						changeState(LYING_UP);
					
					break;
				
				case "right": 
					_directionX = 1;
					
					if ((_directionX != _directionTNT || !_isTouchingGround) && (_currentState == IDLE_X || _currentState == MOVE_X || _currentState == MOVE_Y || _currentState == IDLE_Y || _currentState == RISE || _currentState == ARM_UP || _currentState == ARM_DOWN))
						changeState(MOVE_X);
					
					if (_currentState == JUMP_UP || _currentState == JUMP_IDLE)
						changeState(JUMP_IDLE);
					
					if ((!_isTouchingBox || _directionX == _directionTNT) && (_currentState == IDLE_CREEP || _currentState == CREEP || _currentState == SIT || _currentState == SIT_AT_ONCE || _currentState == LYING_UP || _currentState == LYING_DOWN))
						changeState(CREEP);
					
					if (_isTouchingBox && (_currentState == MOVE_X || _currentState == JUMP_UP || _currentState == JUMP_IDLE))
						changeState(PUSH);
					
					if (_isTouchingGround && _currentState == IDLE_X)
						changeState(ARM_UP);
					
					if (_isTouchingGround && _directionX == _directionTNT && (_currentState == IDLE_CREEP || _currentState == CREEP))
						changeState(LYING_UP);
					
					break;
				
				case "up": 
					_directionY = -1;
					
					if (_isToGround && !_isToStairs && (_currentState == IDLE_X || _currentState == MOVE_X || _currentState == RISE || _currentState == ARM_UP || _currentState == PUSH))
						changeState(JUMP_UP);
					else if (_isToStairs && (_currentState == IDLE_X || _currentState == IDLE_Y || _currentState == MOVE_Y || _currentState == RISE || _currentState == ARM_UP || _currentState == PUSH))
						changeState(MOVE_Y);
					else if (_isToGround && _isToStairs && (_currentState == MOVE_X))
					{
						_hero.setNormalMass();
						changeState(JUMP_UP);
					}
					
					if (_isTopToStairs && _currentState == IDLE_Y)
					{
						_hero.setNormalMass();
						vertStop();
						changeState(JUMP_UP);
					}
					
					break;
				
				case "down": 
					_directionY = 1;
					
					if (_isToStairs && !_isToGround && (_currentState == IDLE_Y || _currentState == MOVE_Y || _currentState == IDLE_X))
						changeState(MOVE_Y);
					
					if (_isToGround && (_currentState == IDLE_X || _currentState == RISE))
						changeState(SIT);
					
					if (_isToGround && _currentState == MOVE_X)
					{
						Statistics.crawlButton++;
						changeState(CREEP);
					}
					break;
				
				case "space": 
					break;
				default: 
					trace("unknown key");
			}
		}
		
		private function listenerUpKeys():void
		{
			if (!_keyStates.left && !_keyStates.right)
			{
				if (_currentState == MOVE_X || _currentState == PUSH)
					changeState(IDLE_X);
				
				if (_currentState == CREEP && _isTopToGround)
					changeState(IDLE_CREEP);
				else if (_currentState == CREEP && !_isTopToGround)
					changeState(SIT_AT_ONCE);
				
				if (_currentState == JUMP_UP || _currentState == JUMP_IDLE)
					horizStop();
				
				if (_currentState == ARM_UP)
					changeState(ARM_DOWN);
				
				if (_currentState == LYING_UP)
					changeState(LYING_DOWN);
				
				if (_isToStairs && !_isToGround && _currentState == IDLE_X)
					changeState(MOVE_Y);
			}
			
			if (!_keyStates.down)
			{
				if (!_isTopToGround && (_currentState == SIT || _currentState == SIT_AT_ONCE || _currentState == CREEP || _currentState == IDLE_CREEP || _currentState == LYING_DOWN))
					changeState(RISE);
			}
			
			if (!_keyStates.up && !_keyStates.down && _currentState == MOVE_Y)
			{
				//trace(_currentState, _keyStates.left, _keyStates.right)
				if (_keyStates.left || _keyStates.right)
					changeState(MOVE_X);
				else
					changeState(IDLE_Y);
			}
			
			if (_currentState == IDLE_X || _currentState == MOVE_X || _currentState == RISE)
			{
				if (_keyStates.left && !_keyStates.right && !_keyStates.down)
				{
					_directionX = -1;
					if (_isTouchingBox)
						changeState(PUSH);
					else
						changeState(MOVE_X);
				}
				else if (!_keyStates.left && _keyStates.right && !_keyStates.down)
				{
					_directionX = 1;
					if (_isTouchingBox)
						changeState(PUSH);
					else
						changeState(MOVE_X);
				}
			}
			if (_currentState == CREEP && (!_isTouchingBox || (_isTouchingBox && _directionX != _directionTNT)))
			{
				if (_keyStates.left && !_keyStates.right && !_keyStates.up && _keyStates.down)
				{
					_directionX = -1;
					changeState(CREEP);
				}
				else if (!_keyStates.left && _keyStates.right && !_keyStates.up && _keyStates.down)
				{
					_directionX = 1;
					changeState(CREEP);
				}
			}
			
			if (_currentState == IDLE_Y || _currentState == MOVE_Y)
			{
				if (!_keyStates.left && !_keyStates.right && _keyStates.up && !_keyStates.down)
				{
					_directionY = -1;
					changeState(MOVE_Y);
				}
				else if (!_keyStates.left && !_keyStates.right && !_keyStates.up && _keyStates.down)
				{
					_directionY = 1;
					changeState(MOVE_Y);
				}
			}
		}
		
		public function set keyStates(value: /*Boolean*/Object):void
		{
			for (var key:String in value)
			{
				if (_keyStates[key] == false && value[key] == true)
				{
					_keyStates[key] = true;
					listenerDownKeys(key);
					return;
				}
				else if (_keyStates[key] == true && value[key] == false)
				{
					_keyStates[key] = false;
					listenerUpKeys();
					return;
				}
			}
		}
		
		public function set isToGround(value:Boolean):void
		{
			//_counterChangeDirection = 0;
			_isToGround = value;
			
			if (_isToGround)
				_ladderOff = false;
			
			if (_currentState == JUMP_IDLE || _currentState == JUMP_UP)
				checkTouchGround();
			
			if (!_isToGround && !_isToStairs && (_currentState == MOVE_X || _currentState == IDLE_X || _currentState == CREEP))
			{
				if (_currentState == CREEP)
				{
					if (!_isTopToGround)
						changeState(JUMP_IDLE);
				}
				else
					changeState(JUMP_IDLE);
			}
			else if (!_isToGround && _isToStairs && (_currentState == IDLE_X || _currentState == CREEP || _currentState == IDLE_CREEP))
			{
				horizStop();
				changeState(MOVE_Y);
				listenerUpKeys();
			}
			
			if (_isToGround && (_currentState == MOVE_Y || _currentState == IDLE_Y))
				changeState(IDLE_X);
		}
		
		public function set isToStairs(value:Boolean):void
		{
			//_counterChangeDirection = 0;
			_isToStairs = value;
			
			if (!_isToStairs)
			{
				if (!_isToGround)
					_ladderOff = true;
				
				_hero.setNormalMass();
				if (!_isToGround && (_currentState == MOVE_X || _currentState == MOVE_Y))
				{
					
					changeState(JUMP_IDLE);
				}
			}
			else
			{
				if (_currentState != JUMP_DOWN)
					_hero.setNullMass();
				
				if (_ladderOff)
					AchievementController.getInstance().addParam(AchievementController.QUICK_STAIR);
				
				if (_currentState == JUMP_UP || _currentState == JUMP_IDLE) //!_isToGround && 
				{
					AchievementController.getInstance().addParam(AchievementController.JUMP_STAIR);
					
					horizStop();
					changeState(MOVE_Y);
					
					listenerUpKeys()
					
					if(_currentState == IDLE_Y)
						_hero.view.goToAndStop(0);
				}
				
				if (_currentState == MOVE_X && (_keyStates.down || _keyStates.up))
				{
					horizStop();
					changeState(MOVE_Y);
				}
			}
		}
		
		public function set isTopToStairs(value:Boolean):void
		{
			_isTopToStairs = value;
			
			if (_isTopToStairs && _currentState == MOVE_Y)
			{
				_hero.setNormalMass();
				vertStop();
				
				if (_directionY == -1)
					changeState(JUMP_UP);
				else if (_directionY == 1)
					changeState(JUMP_IDLE);
			}
		}
		
		public function set isTopToGround(value:Boolean):void
		{
			_isTopToGround = value;
			
			if (!_isTopToGround && _currentState == CREEP)
				listenerUpKeys()
			else if (_isTopToGround && _currentState == MOVE_Y)
				_hero.takeStairs();
			else if (_isTopToGround && _isToGround && !_isTouchingBox && _currentState == MOVE_X)
			{
				Statistics.crawlAuto++;
				changeState(CREEP);
			}
		}
		
		public function get currentState():uint
		{
			return _currentState;
		}
		
		public function set isTouchingBox(value:Boolean):void
		{
			_isTouchingBox = value;
			
			if (_isTouchingBox)
			{
				if ((_keyStates.left || _keyStates.right) && (_currentState == MOVE_X || _currentState == JUMP_UP || _currentState == JUMP_IDLE))
					changeState(PUSH);
				else if (_currentState == CREEP)
					changeState(IDLE_CREEP);
			}
			else if (!_isTouchingBox && (_currentState != JUMP_UP && _currentState != JUMP_IDLE))
			{
				if(_isTopToGround)
				{
					changeState(CREEP);
				}
				else
				{
					_hero.setNoCreep();
					changeState(MOVE_X);
				}
				
				listenerUpKeys();
			}
		}
		
		public function set isTouchingGround(value:Boolean):void
		{
			_isTouchingGround = value;
			
			if (_isTouchingGround)
			{
				horizStop();
				
				checkTouchWalls();
				
				if (_directionX == _directionTNT && _currentState == MOVE_X)
				{
					vertStop();
					changeState(ARM_UP);
				}
				else if (_directionX == _directionTNT && _currentState == CREEP)
					changeState(LYING_UP);
			}
		}
		
		public function get directionTNT():int
		{
			return _directionTNT;
		}
		
		public function get directionX():int
		{
			return _directionX;
		}
		
		public function get isTouchingBox():Boolean
		{
			return _isTouchingBox;
		}
		
		public function set directionTNT(value:int):void
		{
			_directionTNT = value;
		}

		public function set isToExit(value:Boolean):void 
		{
			_isToExit = value;
		}
		
		private function checkTouchWalls():void
		{
			if (_hero.top.position.x < 20 || _hero.top.position.x > (Model.WIDTH + 1) * Model.SIZE)
				_isTouchingGround = false;
		}
		
		public function destroy():void
		{
			_hero.view.removeEventListener(Event.COMPLETE, stopJumpHandler);
			_hero.view.removeEventListener(Event.COMPLETE, outArmHandler);
			_hero.view.removeEventListener(Event.COMPLETE, riseHamdler);
			
			_actionStates.length = 0;
			_actionStates = null;
			_keyStates = null;
			_hero = null;
		}
	}

}