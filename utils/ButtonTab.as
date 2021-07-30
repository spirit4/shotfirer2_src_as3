package utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import sound.SoundManager;
	import sound.SoundRes;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class ButtonTab extends Sprite
	{
		private var _tf:TextBox;
		private var _isActive:Boolean;
		
		public function ButtonTab(text:String, w:Number, h:Number, isActive:Boolean = false)
		{
			buttonMode = true;
			mouseChildren = false;
			
			_isActive = isActive;
			
			_tf = new TextBox(w, h, 26, 0x504731, "", text, "center", true);
			addChild(_tf);
			
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
			addEventListener(MouseEvent.ROLL_OVER, overHandler);
			addEventListener(MouseEvent.ROLL_OUT, outHandler);
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			if (_isActive)
			{
				_isActive = false;
				overHandler();
				_isActive = true;
			}
		}
		
		protected function clickHandler(e:MouseEvent):void
		{
			SoundManager.getInstance().playSFX(SoundRes.SFX_MOUSE_CLICK);
		}
		
		protected function outHandler(e:MouseEvent = null):void
		{
			if (!_isActive)
				_tf.changeTextFormat(false, 0x504731);
		}
		
		protected function overHandler(e:MouseEvent = null):void
		{
			if (!_isActive)
				_tf.changeTextFormat(false, 0xffffff);
		}
		
		protected function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListener(MouseEvent.ROLL_OVER, overHandler);
			removeEventListener(MouseEvent.ROLL_OUT, outHandler);
			removeEventListener(MouseEvent.CLICK, clickHandler);
			
			removeChild(_tf);
			_tf = null;
		}
		
		public function set isActive(value:Boolean):void
		{
			if (value)
				overHandler();
			else
			{
				_isActive = value;
				outHandler();
			}
			
			_isActive = value;
		}
	}

}