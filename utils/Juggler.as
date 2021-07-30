package utils
{
	import data.Model;
	import flash.utils.getTimer;
	
	/**
	 *
	 * @author spirit2
	 */
	public class Juggler
	{
		private var _delayedCalls:Vector.<Function>; //only for check what one instance DelayedCall
		
		private var _objects:Vector.<IUpdatable>;
		private var _deltaTimes:Vector.<Number>; //sync _objects
		private var _nextUpdateTimes:Vector.<Number>; //sync _objects
		private var _lastTick:Number; //seconds
		//private var _pauseDelay:Number; //seconds
		//private var _pauseLast:Number; //seconds
		
		public function Juggler()
		{
			_objects = new Vector.<IUpdatable>();
			_delayedCalls = new Vector.<Function>();
			_deltaTimes = new Vector.<Number>();
			_nextUpdateTimes = new Vector.<Number>();
			
			_lastTick = getTimer() * 0.001;
			//_pauseDelay = _pauseLast = 0;
		}
		
		/**
		 * only one call in Model
		 */
		public function pause(state:int):void
		{
			//if (state == Model.GLOBAL_GAME && _pauseLast != 0)
				//_pauseDelay += getTimer() * 0.001 - _pauseLast;
			//else if(state == Model.GLOBAL_PAUSE)
				//_pauseLast = getTimer() * 0.001;
			//else if(state == Model.GLOBAL_IDLE)
				//_pauseDelay = _pauseLast = 0;
			
			//trace("pause",_pauseDelay,state, _objects.length);	
		}
		
		/**
		 * only one call in Controller
		 */
		public function update():void
		{
			//trace("[juggler update] ",_lastTick);
			_lastTick = getTimer() * 0.001;// - _pauseDelay;
			
			var len:int = _objects.length;
			var object:IUpdatable;
			for (var i:int = 0; i < len; i++)
			{
				object = _objects[i];
				if (object && _nextUpdateTimes[i] <= _lastTick)
				{
					object.update();
					_nextUpdateTimes[i] += _deltaTimes[i];
				}
				else if (!object)
				{
					_objects.splice(i, 1);
					_deltaTimes.splice(i, 1);
					_nextUpdateTimes.splice(i, 1);
					i--;
					len--;
				}
			}
		}
		
		/**
		 * add any IUpdatable for update
		 * deltaTime (second)
		 */
		public function add(object:IUpdatable, deltaTime:Number = 0):void
		{
			const index:int = _objects.indexOf(object);
			if (index == -1)
			{
				_objects.push(object);
				_deltaTimes.push(deltaTime);
				_nextUpdateTimes.push(deltaTime + _lastTick);
			}
		}
		
		/**
		 * remove any IUpdatable for stop of update
		 */
		public function remove(object:IUpdatable):void
		{
			const index:int = _objects.indexOf(object);
			if (index != -1)
				_objects[index] = null;
		}
		
		/**
		 * add callback with the delay
		 * NECESSARILY remove after call
		 * delay (second)
		 */
		public function addCall(callback:Function, delay:Number = 1):void
		{
			const index:int = _delayedCalls.indexOf(callback);
			if (index == -1)
			{
				_objects.push(new DelayedCall(callback));
				_deltaTimes.push(delay);
				_nextUpdateTimes.push(delay + _lastTick);
				_delayedCalls.push(callback);
			}
		}
		
		/**
		 * remove callback after it will be called!
		 */
		public function removeCall(callback:Function):void
		{
			const index:int = _delayedCalls.indexOf(callback);
			if (index != -1)
			{
				_delayedCalls.splice(index, 1);
				
				const len:int = _objects.length;
				for (var i:int = 0; i < len; i++)
				{
					if (_objects[i] is DelayedCall && (_objects[i] as DelayedCall).callback == callback)
					{
						_objects[i] = null;
						break;
					}
				}
			}
		}
		
		/**
		 * delay (second)
		 */
		public function changeCallDelay(callback:Function, delay:Number = 1):void
		{
			const index:int = _delayedCalls.indexOf(callback);
			if (index != -1)
			{
				const len:int = _objects.length;
				for (var i:int = 0; i < len; i++)
				{
					if (_objects[i] is DelayedCall && (_objects[i] as DelayedCall).callback == callback)
					{
						_deltaTimes[i] = delay;
						_nextUpdateTimes[i] = delay + _lastTick;
						break;
					}
				}
			}
		}
		
		public function isCallback(callback:Function):Boolean
		{
			const index:int = _delayedCalls.indexOf(callback);
			if (index != -1)
				return true;
				
			return false;
		}
	}
}