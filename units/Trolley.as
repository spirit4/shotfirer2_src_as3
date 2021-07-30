package units
{
	import data.AchievementController;
	import data.AnimationRes;
	import data.ImageRes;
	import data.Model;
	import effects.PhysicalBurst;
	import effects.Shaker;
	import event.GameEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nape.phys.Body;
	import nape.shape.Shape;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.BitmapClip;
	import utils.Functions;
	import utils.Tile;
	import view.Game;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Trolley extends Box
	{
		private var _leftWheelView:Sprite;
		private var _rightWheelView:Sprite;
		private var _leftWheel:Body;
		private var _rightWheel:Body;
		
		public function Trolley(body:Body, sensor:Shape, boxes:Vector.<Box>, levelLayer:Sprite)
		{
			super(body, sensor, boxes, levelLayer);
			_leftWheelView = body.userData.wheelLeftView;
			_rightWheelView = body.userData.wheelRightView;
			_leftWheel = body.userData.wheelRight;
			_rightWheel = body.userData.wheelRight;
		}
		
		//override protected function detonateHandler(e:GameEvent):void
		//{
//
		//}
		//
		//override public function touchHandler(body:Body):void
		//{
//
		//}
		
		override protected function detonateHandler(e:GameEvent):void
		{
			e.currentTarget.removeEventListener(GameEvent.DETONATED_DYNAMITE, detonateHandler);
			e.currentTarget.removeEventListener(GameEvent.HERO_DEAD, tntKillHeroHandler);
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_STONE_TNT);
			
			_isDynamite = false;
			//removeBox();
		}
		
		override public function removeBox():void
		{
			//trace("joints1", _body.constraints.length);
			_body.constraints.at(1).space = null
			_body.constraints.at(0).space = null
			_body.constraints.clear();
			//trace("joints2", _body.constraints.length)
			super.removeBox();
		}

		override public function update():void
		{
			if (_body.userData.view)
			{
				this.x = _body.position.x - 15;
				this.y = _body.position.y - 19;
				_leftWheelView.rotation = _leftWheel.rotation * 180 / Math.PI;
				_rightWheelView.rotation = _rightWheel.rotation * 180 / Math.PI;
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

		
		override public function destroy():void
		{
			super.destroy();
		}
	}

}