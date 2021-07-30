package sound
{
	import flash.media.SoundChannel;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class WrapperSoundChannel
	{
		private var _typeSound:int = -1;
		private var _channel:SoundChannel;
		
		public function WrapperSoundChannel(type:int, channel:SoundChannel)
		{
			_typeSound = type;
			_channel = channel;
		}
		
		public function get channel():SoundChannel 
		{
			return _channel;
		}
		
		public function get typeSound():int 
		{
			return _typeSound;
		}
	}
	
}