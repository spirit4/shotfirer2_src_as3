package utils
{
	import data.AnimationRes;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Arrow extends Sprite
	{
		private var _clip:BitmapClip;
		private var _callbackShoot:Function;
		private var _callbackForce:Function;
		
		public function Arrow(f1:Function, f2:Function)
		{
			_callbackShoot = f1;
			_callbackForce = f2;
			
			//_clip = new BitmapClip(new <uint>[AnimationRes.ARROW], new <Array>[null], new Rectangle(0, 0, 100, 40));
			//_clip.play(AnimationRes.ARROW, false);
			//_clip.stop();
			//addChild(_clip);
			//_clip.y = -20;
			//_clip.smoothing = true;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}
		
		private function moveHandler(e:MouseEvent):void
		{
			if (e.target is ButtonImage || e.target is ButtonSoundImage)
				return;
			
			const dx:Number = this.x - e.localX;
			const dy:Number = this.y - e.localY;
			this.rotation = Math.atan2(dy, dx) * 180 / Math.PI - 180;
			
			if (this.rotation < -91)
				this.rotation = -91;
			else if (this.rotation > 1)
				this.rotation = 1;
			
			const frame:uint = int(15 * Math.sqrt(dx * dx + dy * dy) / 450);
			_clip.goToAndStop(frame);
			_callbackForce(frame + 1)
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			if (e.target is ButtonImage || e.target is ButtonSoundImage)
				return;
			
			if (this.rotation > 0 || this.rotation < -90)
				return;
			
			Statistics.bonusMouse++;
			_callbackShoot();
		}
		
		public function setForce(percent:uint):void
		{
			const frames:Number = 15;
			_clip.goToAndStop(int(percent * 15 / 100));
		}
		
		public function turnOff():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}
		
		public function destroy():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			
			removeChild(_clip);
			_clip = null;
		}
	}

}