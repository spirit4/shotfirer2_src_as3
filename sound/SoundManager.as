package sound
{
	import flash.events.Event;
	import flash.media.SoundChannel;
	import utils.Analytics;
	import utils.ButtonSoundImage;
	import utils.Functions;
	
	public class SoundManager
	{
		public static var _instance:SoundManager;
		public static var _allowInstance:Boolean = false;
		
		private const MAX_NUMBER_CHANNELS:int = 8;
		
		CONFIG::release
		{
			private var _isSFX:Boolean = true;
			private var _isMusic:Boolean = true;
		}
		CONFIG::debug
		{
			private var _isSFX:Boolean = false;
			private var _isMusic:Boolean = false;
		}
		
		private var _currentMusicButton:ButtonSoundImage;
		private var _currentSoundButton:ButtonSoundImage;
		private var _currentLocation:int = -1; //menu or game
		
		private var _currentLoopType:int;
		private var _currentLoop:SoundChannel;
		
		private var _SFXChannels:Vector.<WrapperSoundChannel> = new Vector.<WrapperSoundChannel>(); //queue
		
		private var _musicChannels:Vector.<SoundChannel> = new Vector.<SoundChannel>(SoundRes.themes.length);
		private var _musicPositions:Vector.<Number> = new Vector.<Number>(SoundRes.themes.length);
		private var _currentTypes:Vector.<uint> = new Vector.<uint>(SoundRes.themes.length);
		
		public function SoundManager()
		{
			if (!_allowInstance)
			{
				throw new Error("Error: Use SoundManager.getInstance() instead of the new keyword.");
			}
			init();
		}
		
		private function init():void
		{
			for (var i:int = 0; i < _musicPositions.length; i++)
			{
				_musicPositions[i] = 0;
				_currentTypes[i] = 0;
			}
		}
		
		public static function getInstance():SoundManager
		{
			if (_instance == null)
			{
				_allowInstance = true;
				_instance = new SoundManager();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function isThisSFX(type:int):Boolean
		{
			for (var i:int = 0; i < _SFXChannels.length; i++) 
			{
				if (_SFXChannels[i].typeSound == type)
					return true;
			}
			
			return false;
		}
		
		public function playSFX(type:int):SoundChannel
		{
			if (!_isSFX)
				return null;//for stairs
			
			var typeSound:int = type;
			
			if (type == SoundRes.SFX_DYNAMITE)
			{
				if (Math.random() > 0.5)
					typeSound++; //second sound
			}
			
			if (_SFXChannels.length >= MAX_NUMBER_CHANNELS)
			{
				const channel:SoundChannel = _SFXChannels.shift().channel;
				channel.stop();
			}
			
			const sChannel:SoundChannel = SoundRes.sfxs[typeSound].play();
			const sfxChannel:WrapperSoundChannel = new WrapperSoundChannel(typeSound, sChannel);
			sfxChannel.channel.addEventListener(Event.SOUND_COMPLETE, sfxCompleteHandler);
			_SFXChannels.push(sfxChannel);
			
			return sChannel;
		}
		
		public function stopSFX(channel:SoundChannel):void
		{
			for (var i:int = 0; i < _SFXChannels.length; i++) 
			{
				if (_SFXChannels[i].channel == channel)
				{
					channel.removeEventListener(Event.SOUND_COMPLETE, sfxCompleteHandler);
					channel.stop();
					
					_SFXChannels.splice(i, 1);
					break;
				}
			}
		}
		
		private function sfxCompleteHandler(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.SOUND_COMPLETE, sfxCompleteHandler);
			const sfxChannel:SoundChannel = e.currentTarget as SoundChannel;
			for (var i:int = 0; i < _SFXChannels.length; i++) 
			{
				if (_SFXChannels[i].channel == sfxChannel)
				{
					_SFXChannels.splice(i, 1);
					break;
				}
			}
		}
		
		public function playLoop(type:int):void
		{
			if (!_isSFX)
				return;
			
			_currentLoopType = type;
			
			if (_currentLoop)
			{
				_currentLoop.removeEventListener(Event.SOUND_COMPLETE, loopCompleteHandler);
				_currentLoop.stop();
				_currentLoop = null;
			}
			
			_currentLoop = SoundRes.loops[_currentLoopType].play();
			_currentLoop.addEventListener(Event.SOUND_COMPLETE, loopCompleteHandler);
		}
		
		public function stopLoop():void
		{
			if (_currentLoop)
			{
				_currentLoop.removeEventListener(Event.SOUND_COMPLETE, loopCompleteHandler);
				_currentLoop.stop();
				_currentLoop = null;
			}
		}
		
		private function loopCompleteHandler(e:Event = null):void
		{
			_currentLoop.removeEventListener(Event.SOUND_COMPLETE, loopCompleteHandler);
			_currentLoop = SoundRes.loops[_currentLoopType].play();
			_currentLoop.addEventListener(Event.SOUND_COMPLETE, loopCompleteHandler);
		}
		
		public function setLocation(type:uint):void
		{
			if (_isMusic)
			{
				if (type != _currentLocation)
				{
					stopMusicTrack();
					
					if (_currentLocation != -1)
						_musicPositions[_currentLocation] = 0;
					
					_currentLocation = type;
					playMusicTrack();
				}
			}
			else
				_currentLocation = type;
		}
		
		private function playMusicTrack():void
		{
			const type:uint = _currentTypes[_currentLocation];
			_musicChannels[_currentLocation] = SoundRes.themes[_currentLocation][type].play(_musicPositions[_currentLocation]);
			_musicChannels[_currentLocation].addEventListener(Event.SOUND_COMPLETE, musicCompleteHandler);
		}
		
		private function stopMusicTrack():void
		{
			if (_currentLocation == -1)
				return;
			
			_musicChannels[_currentLocation].removeEventListener(Event.SOUND_COMPLETE, musicCompleteHandler);
			_musicPositions[_currentLocation] = _musicChannels[_currentLocation].position;
			_musicChannels[_currentLocation].stop();
		}
		
		private function musicCompleteHandler(e:Event):void
		{
			e.target.removeEventListener(Event.SOUND_COMPLETE, musicCompleteHandler);
			_musicPositions[_currentLocation] = 0;
			
			_currentTypes[_currentLocation]++;
			if (_currentTypes[_currentLocation] == SoundRes.themes[_currentLocation].length)
				_currentTypes[_currentLocation] = 0;
			
			playMusicTrack();
		}
		
		public function get isSFX():Boolean
		{
			return _isSFX;
		}
		
		public function set isSFX(value:Boolean):void
		{
			_isSFX = value;
			
			if(_isSFX)
				Analytics.pushPage(Analytics.SOUND_ON);
			else
				Analytics.pushPage(Analytics.SOUND_OFF);
				
			//if (_currentSoundButton)
				//_currentSoundButton.setState();
		}
		
		public function get isMusic():Boolean
		{
			return _isMusic;
		}
		
		public function set isMusic(value:Boolean):void
		{
			_isMusic = value;
			
			if(_isMusic)
				Analytics.pushPage(Analytics.MUSIC_ON);
			else
				Analytics.pushPage(Analytics.MUSIC_OFF);
			
			//if (_currentMusicButton)
				//_currentMusicButton.setState();
				
			if (_isMusic)
				playMusicTrack();
			else
				stopMusicTrack();
		}
		
		public function set currentMusicButton(value:ButtonSoundImage):void 
		{
			_currentMusicButton = value;
		}
		
		public function set currentSoundButton(value:ButtonSoundImage):void 
		{
			_currentSoundButton = value;
		}
		
		public function setSavingState(music:Boolean, sfx:Boolean):void
		{
			_isMusic = music;
			_isSFX = sfx;
		}

	}
}