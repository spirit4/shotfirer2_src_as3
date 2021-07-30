package utils
{
	
	/**
	 * DelayedCall can be called one time
	 * _callback:Function
	 * @author spirit2
	 */
	public class DelayedCall implements IUpdatable
	{
		private var _callback:Function;
		
		public function DelayedCall(callback:Function)
		{
			_callback = callback;
		}
		
		public function update():void
		{
			_callback();
		}
		
		public function get callback():Function
		{
			return _callback;
		}
	}

}