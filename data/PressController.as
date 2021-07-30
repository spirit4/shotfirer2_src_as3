package data
{
	import flash.events.Event;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.callbacks.OptionType;
	import nape.phys.Body;
	import sound.SoundManager;
	import sound.SoundRes;
	import units.ActiveBody;
	import utils.BitmapClip;
	import view.Game;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class PressController
	{
		private var _data:Model;
		private var _game:Game;
		
		public function PressController(game:Game)
		{
			_data = Controller.model;
			_game = game;
			
			init();
		}
		
		private function init():void
		{
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_PRESS, new OptionType([Model.BODY_HERO_BASE, Model.BODY_NORMAL_BOX, Model.BODY_TNT_BOX, Model.BODY_TNT, Model.BODY_ENEMY]), toPressHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.SENSOR, Model.BODY_PRESS, new OptionType([Model.BODY_HERO_BASE, Model.BODY_NORMAL_BOX, Model.BODY_TNT_BOX, Model.BODY_TNT, Model.BODY_ENEMY]), fromPressHandler));
		}
		
		private function toPressHandler(cb:InteractionCallback):void
		{
			if (cb.int2.castShape.cbTypes.has(Model.BODY_PARROT_ATTACK_SENSOR))
				return;
			
			const body:Body = cb.int1.castShape.body;
			body.userData.counter++;
			
			if (body.userData.counter > 1)
				return;
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_PRESS_ON);
			
			body.userData.isPressing = true;
			
			//trace("[toPressHandler]", body.userData.ao);
			const ao:Array = body.userData.ao;
			for each (var activeBody:ActiveBody in ao)
			{
				activeBody.turnOnOff(body.space);
			}
			
			if (cb.int2.castShape.body.userData.type == ImageRes.TROLLEY)
			{
				const buttons:Array = cb.int2.castShape.body.userData.buttonsArray;
				if (buttons.indexOf(cb.int1.castShape.body) == -1)
					buttons.push(cb.int1.castShape.body);
				
				if (buttons.length == 2)
					AchievementController.getInstance().addParam(AchievementController.TROLLEY_TOUCH_2_BUTTONS);
					
				//trace("press who:", buttons);
			}
			
			
			const bitmap:BitmapClip = body.userData.view as BitmapClip;
			//bitmap
			bitmap.play(body.userData.colorType, false);
			
			//Controller.juggler.add(bitmap);
			bitmap.addEventListener(Event.COMPLETE, pressCompleteHandler, false, 0, true);
		}
		
		private function fromPressHandler(cb:InteractionCallback):void
		{
			if (cb.int2.castShape.cbTypes.has(Model.BODY_PARROT_ATTACK_SENSOR))
				return;
			
			const body:Body = cb.int1.castShape.body;
			body.userData.counter--;
			
			if (body.userData.counter > 0)
				return;
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_PRESS_OFF);
			
			body.userData.isPressing = false;
			
			const ao:Array = body.userData.ao;
			for each (var activeBody:ActiveBody in ao)
			{
				activeBody.turnOnOff(body.space);
			}
			
			const bitmap:BitmapClip = body.userData.view as BitmapClip;
			Controller.juggler.add(bitmap);
			
			bitmap.play(body.userData.colorType, false, false, true);
			bitmap.addEventListener(Event.COMPLETE, pressCompleteHandler, false, 0, true);
		}
		
		private function pressCompleteHandler(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, pressCompleteHandler);
			//Controller.juggler.remove(e.currentTarget as BitmapClip);
		}
		
		public function destroy():void
		{
			_game = null;
			_data = null;
		}
	}

}