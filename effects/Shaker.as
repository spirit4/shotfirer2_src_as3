package effects
{
	import flash.display.DisplayObject;
	import utils.RandUtils;
	import view.Game;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Shaker
	{
		private var _object:DisplayObject;
		private var _game:Game;
		
		private var _counter:uint;
		private var _currentStep:uint;
		private var _radius:Number;
		private var _number:uint;
		
		public function Shaker(object:DisplayObject, game:Game, radius:Number = 4, number:Number = 10)
		{
			_game = game;
			_object = object;
			_number = number;
			_radius = radius;
			
			_game.activeShakers.push(this);
		}
		
		public function update():void
		{
			if (_counter % 2 == 0 && _currentStep < _number)
				shake();
			else if (_currentStep >= _number)
				destroy();
			
			_counter++
		}
		
		private function destroy():void
		{
			_game.activeShakers[_game.activeShakers.indexOf(this)] = null;
			
			_object.x = 0;
			_object.y = 0;
			_object = null;
			_game = null;
		}
		
		private function shake():void
		{
			_object.x = RandUtils.getFloat(-_radius, _radius);
			_object.y = RandUtils.getFloat(-_radius, _radius);
			_currentStep++;
		}
	}

}