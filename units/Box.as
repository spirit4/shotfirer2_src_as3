package units
{
	import data.AchievementController;
	import data.AnimationRes;
	import data.Model;
	import effects.PhysicalBurst;
	import event.GameEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.shape.Shape;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.BitmapClip;
	import view.Game;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Box extends Sprite
	{
		protected var _isVelocityPhysicalBurst:Boolean = false;
		protected var _isVelocityDown:Boolean;
		protected var _isSoundPlaying:Boolean;
		
		protected var _body:Body;
		protected var _sensor:Shape;
		protected var _boxes:Vector.<Box>;
		protected var _levelLayer:Sprite;
		protected var _boom:BitmapClip;
		
		protected var _isTouch:Boolean;
		
		protected var _callbackKillHero:Function;
		protected var _isDynamite:Boolean;
		
		public function Box(body:Body, sensor:Shape, boxes:Vector.<Box>, levelLayer:Sprite)
		{
			_body = body;
			_sensor = sensor;
			_boxes = boxes;
			_levelLayer = levelLayer;
		}
		
		public function tntSetHandler(callbackKillHero:Function):void
		{
			_isDynamite = true;
			_callbackKillHero = callbackKillHero;
			const game:Game = _levelLayer.parent as Game;
			
			var type:int = Dynamite.STONE;
			if (_sensor.cbTypes.has(Model.BODY_TNT_BOX))
				type = Dynamite.BOX_TNT;
			
			const tnt:Dynamite = new Dynamite(game, 2, type);
			
			tnt.addEventListener(GameEvent.HERO_DEAD, tntKillHeroHandler);
			tnt.addEventListener(GameEvent.DETONATED_DYNAMITE, detonateHandler);
			
			tnt.body.position.setxy(_body.position.x, _body.position.y - 25);
			tnt.view.x = tnt.body.position.x - tnt.view.width / 2;
			tnt.view.y = tnt.body.position.y - 22;
			tnt.countdown.x = tnt.body.position.x - tnt.countdown.width / 2;
			tnt.countdown.y = tnt.body.position.y + 8;
			
			tnt.addRange();
		}
		
		protected function tntKillHeroHandler(e:GameEvent):void
		{
			e.currentTarget.removeEventListener(GameEvent.HERO_DEAD, tntKillHeroHandler);
			//_callbackKillHero = null;
			_callbackKillHero();
		}
		
		protected function detonateHandler(e:GameEvent):void
		{
			e.currentTarget.removeEventListener(GameEvent.DETONATED_DYNAMITE, detonateHandler);
			e.currentTarget.removeEventListener(GameEvent.HERO_DEAD, tntKillHeroHandler);
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_BONUS_TNT);
			
			removeBox();
		}
		
		//GameController for walls
		public function removeBox():void
		{
			trace("[removeBox]");
			if (_body.userData.view)
				_levelLayer.removeChild(this);	
				
			_body.userData.view = null;
			
			_boxes.splice(_boxes.indexOf(this), 1);
			_body.space = null;
			
			destroy();
		}
		
		//trolley or removed box
		public function boomHandler():void
		{
			//trace("[BOOM3]: ", _body.userData.index);
			if (this is Trolley)
			{
				//_body.applyImpulse(Vec2.weak(0, -15000));
				return;
			}
			
			_boom = new BitmapClip(new <uint>[AnimationRes.BONUS_BOOM], new <Array>[null], new Rectangle(0, 0, 128, 128));
			_boom.play(AnimationRes.BONUS_BOOM, false);
			_levelLayer.addChild(_boom);
			_boom.x = _body.position.x - 64;
			_boom.y = _body.position.y - 64;
			
			//Controller.juggler.add(_boom);
			_boom.addEventListener(Event.COMPLETE, boomCompleteHandler);
			
			const burst:PhysicalBurst = new PhysicalBurst(_levelLayer.parent as Game, _body.space, 2, PhysicalBurst.BOX);
			burst.startBurst(_body.position.x, _body.position.y, 15, 6);
			
			if(_body.userData.view)
				_body.userData.view.visible = false;
		}
		
		private function boomCompleteHandler(e:Event):void
		{
			if ((e.currentTarget as BitmapClip).parent)
				(e.currentTarget as BitmapClip).parent.removeChild(e.currentTarget as BitmapClip);

			e.currentTarget.removeEventListener(Event.COMPLETE, boomCompleteHandler);
			
			//Controller.juggler.remove(_boom);
			//_levelLayer.removeChild(_boom);
			_boom = null;
			
			//blow by another box
			if(_boxes)
				removeBox();
		}
		
		public function touchHandler(body:Body, callbackKillHero:Function):void
		{
			_callbackKillHero = callbackKillHero;
			//trace("touchHandler", body.userData.bodyClass.states.currentState);
			
			if (body.userData.bodyClass == null) //already died
				return;
			
			if (_body.velocity.y < 50)
				return;
			
			if (body.userData.bodyClass is Hero)
			{
				if(body.userData.bodyClass.states.currentState != States.DEATH_0)
				{
					_callbackKillHero();
					SoundManager.getInstance().playSFX(SoundRes.SFX_BOX_ON_MONSTER);
				}
					
				return;
			}
				
			var type:int = PhysicalBurst.GOLLUM;
			if (body.userData.bodyClass is Parrot)
				type = PhysicalBurst.PARROT;
			else if (body.userData.bodyClass is Crab)
				type = PhysicalBurst.CRAB;
			const burst:PhysicalBurst = new PhysicalBurst(_levelLayer.parent as Game, _body.space, 2, type);
			burst.startBurst(body.position.x, body.position.y, 10, 9);
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_BOX_ON_MONSTER);
			
			const ev:GameEvent = new GameEvent(GameEvent.ENEMY_DIED);
			ev.body = body;
			_levelLayer.dispatchEvent(ev);
			
			AchievementController.getInstance().addParam(AchievementController.ENEMY_DEATH_BOX);
		}
		
		public function update():void
		{
			if (_body.userData.view)
			{
				_body.userData.view.x = _body.position.x - 15;
				_body.userData.view.y = _body.position.y - 16;
			}
			
			if (_body && _isSoundPlaying && Math.abs(_body.velocity.y) < 5)
				_isVelocityDown = false;
			
			if (_body && !_isVelocityDown && _body.velocity.y > 100)
			{
				_isSoundPlaying = false;
				_isVelocityDown = true;
			}
			
			if (!_isSoundPlaying && _body && _isVelocityDown && isSoundCollisionCheck(_body.space.bodiesInShape(_sensor)))
			{
				SoundManager.getInstance().playSFX(SoundRes.SFX_BOX_DOWN);
				_isSoundPlaying = true;
			}
		}
		
		protected function isSoundCollisionCheck(list:BodyList):Boolean
		{
			var types:Array = [Model.BODY_BOX, Model.BODY_GROUND, Model.BODY_SPIKE];
			var body:Body;
			
			for (var i:int = 0; i < list.length; i++)
			{
				body = list.at(i);
				for each (var type:CbType in types)
				{
					if (body.cbTypes.has(type))
					{
						if (type == Model.BODY_BOX)
						{
							if (body == _body)
								continue;
							else
								return true;
						}
						
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function destroy():void
		{
			//trace("[destroy common box]", this);
			if (_boom)
			{
				_boom.removeEventListener(Event.COMPLETE, boomCompleteHandler);
				if(_boom.parent)
					_boom.parent.removeChild(_boom);
			}
			
			_body.userData.bodyClass = null;
			_body.userData.view = null;
			
			_callbackKillHero = null;
			_body = null;
			_sensor = null;
			_boxes = null;
			_levelLayer = null;
			_boom = null;
		}
		
		public function get isDynamite():Boolean
		{
			return _isDynamite;
		}
		
		public function get body():Body 
		{
			return _body;
		}
	}

}