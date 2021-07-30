package units
{
	import data.AnimationRes;
	import data.Model;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.BitmapClip;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Crab extends Enemy
	{
		private var _directionSensors:Vector.<Shape>;
		private var _currentSensorStates:Vector.<Boolean>;
		private var _prevSensorStates:Vector.<Boolean>;
		private var _changedSensors:Vector.<Boolean>;
		
		private var _leftBottomSensor:Shape;
		private var _rightBottomSensor:Shape;
		
		private var _attackClip:BitmapClip;
		private var _directionGravity:Vec2 = Vec2.weak(0, 1);
		
		private var _isReverse:Boolean;
		
		private var _currentState:int = 1;
		
		static private const IDLE:int = 0;
		static private const MOVE:int = 1;
		static private const ATTACK:int = 2;
		static private const FALL:int = 3;
		
		static private const LEFT:int = 0;
		static private const TOP:int = 1;
		static private const RIGHT:int = 2;
		static private const BOTTOM:int = 3;
		
		public function Crab(isRight:Boolean)
		{
			_typeMove = AnimationRes.CRAB_MOVE;
			_typeAttack = AnimationRes.CRAB_ATTACK;
			_rect = new Rectangle(0, 0, 48, 48);
			
			super(isRight);
			if (isRight)
			{
				_isReverse = isRight;
				_view.scaleX = -1;
				_view.x = _view.width >> 1;
			}
			
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_directionY = 0;
			
			changeView();
		}
		
		override protected function createView():void
		{
			super.createView();
			_view.x = -_view.width >> 1;
			_view.y = -(_view.height >> 1) - 2;
		}
		
		private function changeView():void
		{
			if (_currentState == IDLE || _currentState == ATTACK)
			{
				_view.goToAndStop(0);
				_body.velocity.setxy(0, 0);
			}
			else if (_currentState == MOVE)
			{
				_view.goToAndPlay(0);
			}
		
			//_view.scaleX = -1;
		//_view.x = _view.width >> 1;
		//}
		//else
		//{
		//_view.scaleX = 1;
		//_view.x = -_view.width >> 1;
		//}
		//}
		//
		this.rotation = _body.rotation * 180 / Math.PI;
		}
		
		override protected function attack():void
		{
			_attackClip = new BitmapClip(new <uint>[_typeAttack], new <Array>[null], new Rectangle(0, 0, 64, 64));
			_attackClip.play(_typeAttack, false);
			_attackClip.x = _body.position.x - 32;
			_attackClip.y = _body.position.y - 32;
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_ATTACK_CRAB);
			
			_currentState = IDLE;
			parent.addChild(_attackClip);
			//Controller.juggler.add(_attackClip);
			_attackClip.addEventListener(Event.COMPLETE, attackCompleteHandler);
		}
		
		override protected function attackCompleteHandler(e:Event):void
		{
			if (_attackClip)
			{
				_attackClip.removeEventListener(Event.COMPLETE, attackCompleteHandler);
				parent.removeChild(_attackClip);
			}
			
			_attackClip = null;
			_isAttack = false;
		}
		
		override protected function createBody():void
		{
			_body = new Body();
			_body.allowRotation = false;
			_body.userData.bodyClass = this;
			
			var circle:Circle = new Circle(14, null, Material.ice());
			circle.body = _body;
			
			_sensor = new Polygon(Polygon.rect(-20, -10, 40, 20), null, Model.FILTER_FOR_CRAB);
			_sensor.sensorEnabled = true;
			_body.shapes.add(_sensor);
			
			_directionSensors = new Vector.<Shape>(4, true);
			_directionSensors[0] = new Polygon(Polygon.rect(-21, -2, 6, 4));
			_directionSensors[1] = new Polygon(Polygon.rect(-3, -27, 6, 13));
			_directionSensors[2] = new Polygon(Polygon.rect(15, -2, 6, 4));
			_directionSensors[3] = new Polygon(Polygon.rect( -3, 12, 6, 13));
			
			_leftBottomSensor = new Polygon(Polygon.rect(-25, 25, 4, 4));
			_rightBottomSensor = new Polygon(Polygon.rect(21, 25, 4, 4));
			_leftBottomSensor.sensorEnabled = true;
			_body.shapes.add(_leftBottomSensor);
			
			_rightBottomSensor.sensorEnabled = true;
			_body.shapes.add(_rightBottomSensor);
			
			for (var i:int = 0; i < _directionSensors.length; i++)
			{
				_directionSensors[i].sensorEnabled = true;
				_body.shapes.add(_directionSensors[i]);
			}
			
			_body.gravMass = 0;
			
			_body.setShapeFilters(Model.FILTER_ENEMY);
			
			_sensor.cbTypes.add(Model.BODY_DANGER);
			_sensor.cbTypes.add(Model.BODY_ENEMY);
		}
		
		override public function update():void
		{
			if (!_prevSensorStates)
			{
				_prevSensorStates = new Vector.<Boolean>(4, true);
				_currentSensorStates = new Vector.<Boolean>(4, true);
				_changedSensors = new Vector.<Boolean>(4, true);
				for (var i:int = 0; i < _directionSensors.length; i++)
				{
					_prevSensorStates[i] = isCollisionCheck(_body.space.bodiesInShape(_directionSensors[i]));
					_currentSensorStates[i] = _prevSensorStates[i];
					//trace("create", _prevSensorStates[i]);
				}
			}
			
			move();
			if (!_isAttack && _currentState == MOVE)
			{
				_body.velocity.x = 50 * _directionX;
				_body.velocity.y = 50 * _directionY;
			}
			
			if (_currentState == MOVE)
				applyGravity();
				
			this.x = _body.position.x;
			this.y = _body.position.y;
		}
		
		private function applyGravity():void
		{
			_body.force.x = _directionGravity.x * 500;
			_body.force.y = _directionGravity.y * 500;
		}
		
		override protected function move():void
		{
			if (isChangedStates())
				changeDirection();
			//trace("move---------------------------------------------------------------");
			
			if (!isGroundAround() && !_currentSensorStates[LEFT] && !_currentSensorStates[TOP] && !_currentSensorStates[RIGHT] && !_currentSensorStates[BOTTOM])
			{
				//trace("fallDown", isGroundAround);
				fallDown();// after all!!!
			}
		
		}
		
		private function isChangedStates():Boolean
		{
			_changedSensors[0] = false;
			_changedSensors[1] = false;
			_changedSensors[2] = false;
			_changedSensors[3] = false;
			var flag:Boolean;
			for (var i:int = 0; i < _directionSensors.length; i++)
			{
				_currentSensorStates[i] = isCollisionCheck(_body.space.bodiesInShape(_directionSensors[i]));
				_changedSensors[i] = _currentSensorStates[i] != _prevSensorStates[i];
				//trace("isChangedStates", _changedSensors[i]);
				
				if (_changedSensors[i])
					flag = true;
					
				_prevSensorStates[i] = _currentSensorStates[i];
			}
			//trace("-------------------");
			return flag;
		}
		
		private function isGroundAround():Boolean
		{
			if (isCollisionCheck(_body.space.bodiesInShape(_leftBottomSensor)) || isCollisionCheck(_body.space.bodiesInShape(_rightBottomSensor)))
				return true;
				
			return false;
		}
		
		private function changeDirection():void
		{
			const isGroundAround:Boolean = isGroundAround();
			if (_currentState == FALL && _changedSensors[BOTTOM] && _currentSensorStates[BOTTOM])
			{
				_body.gravMass = 0;
				_currentState = MOVE;
				//trace("fall ENDED");
			}
			
			//trace(_changedSensors, _currentSensorStates, isGroundAround, _directionGravity, _currentState);
			if (_currentSensorStates[LEFT] && _currentSensorStates[TOP] && _currentSensorStates[RIGHT] && _currentSensorStates[BOTTOM])
			{
				_currentState = IDLE;
			}
			else if (!_isReverse && _changedSensors[BOTTOM] && !_currentSensorStates[BOTTOM])
			{
				rotateClockwise();
			}
			else if (!_isReverse && (_changedSensors[LEFT] || _changedSensors[TOP] || _changedSensors[BOTTOM]) && _currentSensorStates[LEFT] && _currentSensorStates[BOTTOM])
			{
				rotateAnticlockwise();
			}
			else if (_isReverse && _changedSensors[BOTTOM] && !_currentSensorStates[BOTTOM])
			{
				rotateAnticlockwise();
			}
			else if (_isReverse && (_changedSensors[RIGHT] || _changedSensors[TOP] || _changedSensors[BOTTOM]) && _currentSensorStates[RIGHT] && _currentSensorStates[BOTTOM])
			{
				rotateClockwise();
			}
			else if (_currentState != FALL && !_currentSensorStates[BOTTOM] && (_changedSensors[LEFT] || _changedSensors[RIGHT]) && (_currentSensorStates[LEFT] || _currentSensorStates[RIGHT]))
			{
				fallDown();
				return;
			}
			
			
			
			changeView();
		}
		
		private function rotateClockwise():void
		{
			//trace("rotateClockwise1", _directionX, _directionY);
			
			var tempX:int;
			_body.rotation -= Math.PI / 2;
			if(!_isReverse)
			{
				_body.position.x += 12 * _directionX + 18 * _directionY;//-12
				_body.position.y += 12 * _directionY + 18 * -_directionX;//+18
			}
			else
			{
				_body.position.x += 2 * _directionY + 6 * _directionX;//-2
				_body.position.y += -2 * _directionY - 6 * _directionX;//+2
			}
			
			
			tempX = _directionX;
			_directionX = _directionY;
			_directionY = -tempX;

			_directionGravity.setxy(_directionGravity.y, -_directionGravity.x);
			//trace("rotateClockwise2", _directionX, _directionY);
		}
		
		private function rotateAnticlockwise():void
		{
			//trace("rotateANTIclockwise1", _directionX, _directionY);
			
			var tempX:int;
			_body.rotation += Math.PI / 2;
			if(!_isReverse)
			{
				_body.position.x += 2 * -_directionY + 6 * _directionX;//-2
				_body.position.y += -2 * -_directionY + 6 * _directionX;//+2
			}
			else
			{
				_body.position.x += 12 * _directionX + 18 * -_directionY;//-12
				_body.position.y += 12 * -_directionY + 18 * _directionX;//+18
			}
				
			_body.position.y += 2 * _directionX + 6 * _directionY;//6
			
			tempX = _directionX;
			_directionX = -_directionY;
			_directionY = tempX;

			_directionGravity.setxy( -_directionGravity.y, _directionGravity.x);
			//trace(_directionGravity)
			//_currentState = IDLE
			//trace("rotateANTIclockwise2", _directionX, _directionY);
		}
		
		private function fallDown():void
		{
			//trace("fallDown");
			_currentState = FALL;
			
			_body.gravMass = 2;
			_body.rotation = 0;

			_directionX = !_isReverse ? -1 : 1;
			_directionY = 0;

			_directionGravity.setxy(0, 1);
		}
		
		override public function destroy():void
		{
			if (_attackClip)
				_attackClip.removeEventListener(Event.COMPLETE, attackCompleteHandler);
			
			_attackClip = null;
			_directionGravity = null;
			
			super.destroy();
		
			//TODO sensors
		}
	
	}

}