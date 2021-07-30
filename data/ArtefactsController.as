package data
{
	import caurina.transitions.Tweener;
	import event.GameEvent;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.phys.Body;
	import sound.SoundManager;
	import sound.SoundRes;
	import units.States;
	import utils.Analytics;
	import utils.BitmapClip;
	import utils.Functions;
	import view.Game;
	import view.hints.Reminder;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class ArtefactsController
	{
		private var _data:Model;
		private var _game:Game;
		
		public function ArtefactsController(game:Game)
		{
			_data = Controller.model;
			_game = game;
			
			init();
		}
		
		private function init():void
		{
			//for each (var body:Body in _data.arts)
			//{
				//Controller.juggler.add(body.userData.view);
			//}
			
			playAnimationArt();
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_ARTEFACT, Model.BODY_HERO_BASE, toArtHandler));
		}
		
		private function gameCompleteHandler():void
		{
			Tweener.addTween(_game.parent, {_tintBrightness: 0, time: 0.3, transition: "linear"});
			_game.dispatchEvent(new GameEvent(GameEvent.GAME_COMPLETE));
		}
		
		private function playAnimationArt():void
		{
			Controller.juggler.removeCall(playAnimationArt);
			if (_data.arts.length == 0)
				return;
			
			const delayNextPlay:int = int(Math.random() * 60) + 30;
			
			const index:uint = uint(Math.random() * _data.arts.length);
			const body:Body = _data.arts[index];
			const clip:BitmapClip = body.userData.view as BitmapClip;
			
			if (body.cbTypes.has(Model.BODY_IDOL))
				clip.play(AnimationRes.IDOL, false);
			else
				clip.play(AnimationRes.ARTIFACT, false);
				
			Controller.juggler.addCall(playAnimationArt, delayNextPlay/60);
		}
		
		private function toArtHandler(cb:InteractionCallback):void
		{
			const bitmap:Bitmap = cb.int1.castBody.userData.view as Bitmap;
			
			if (cb.int1.castBody.cbTypes.has(Model.BODY_IDOL))
			{
				_data.hero.states.changeState(States.IDLE_X);
				Tweener.addTween(_game.parent, {_tintBrightness: 1, time: 0.4, transition: "easeInQuart", onComplete: gameCompleteHandler});
				return;
			}
			else
				addEffectGetting(bitmap);
			
			bitmap.parent.removeChild(bitmap);
			cb.int1.castBody.userData.view = null;
			cb.int1.castBody.space = null;
			
			const index:uint = _data.arts.indexOf(cb.int1.castBody);
			_data.arts.splice(index, 1);
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_GET_ART);
			
			//if (_data.progress.artToLevels.indexOf(_data.progress.currentLevel) == -1)
			//{
				//_data.progress.artToLevels.push(_data.progress.currentLevel);
				//AchievementController.getInstance().addParam(AchievementController.GETING_ART);
				//
				//_game.addChild(new Reminder("found a hidden artifact", Reminder.GET_UP, 2));
				//Analytics.pushPage(Analytics.GET_ART);
				//
				//ApiKG.sendArt(_data.progress.artToLevels.length); //+1
			//}
		}
		
		private function addEffectGetting(gemClip:Bitmap):void
		{
			const bitmap:BitmapClip = new BitmapClip(new <uint>[AnimationRes.ARTIFACT_GET], new <Array>[null], new Rectangle(0, 0, 64, 64));
			bitmap.play(AnimationRes.ARTIFACT_GET, false);
			bitmap.x = gemClip.x - 16;
			bitmap.y = gemClip.y - 32;
			
			//Controller.juggler.add(bitmap);
			
			_game.levelLayer.addChild(bitmap);
			bitmap.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
		}
		
		private function completeHandler(e:Event):void
		{
			const bitmap:BitmapClip = e.currentTarget as BitmapClip;
			//Controller.juggler.remove(bitmap);
			
			bitmap.removeEventListener(Event.COMPLETE, completeHandler);
			_game.levelLayer.removeChild(bitmap);
		}
		
		public function destroy():void
		{
			Controller.juggler.removeCall(playAnimationArt);
			
			//for each (var body:Body in _data.arts)
			//{
				//Controller.juggler.remove(body.userData.view);
			//}

			_game = null;
			_data = null;
		}
	}

}