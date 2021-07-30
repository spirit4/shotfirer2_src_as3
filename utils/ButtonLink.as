package utils
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import sound.SoundManager;
	import sound.SoundRes;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class ButtonLink extends Sprite
	{
		private var _tf:TextBox;
		protected var _color:int;
		private var _colorHover:int;
		private var _handler:Function;
		
		public var userData:Object = new Object();
		
		public function ButtonLink(text:String, size:int, color:int = 0xFFFFFF, colorHover:int = 0xDDDDDD, align:String = "left", handler:Function = null)
		{
			this.mouseChildren = false;
			this.buttonMode = true;
			
			_color = color;
			
			if (colorHover)
				_colorHover = colorHover;
			else
				_colorHover = _color;
			
			_tf = new TextBox(text.length * 18 + 20, 30, size, _color, "", text, align, false, false);
			this.addChild(_tf);
			if (align == "center")
				_tf.x = -tf.width / 2 - 2;
			
			this.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			this.addEventListener(MouseEvent.CLICK, clickHandler);
			
			if (handler !== null)
			{
				_handler = handler;
				this.addEventListener(MouseEvent.CLICK, _handler);
			}
			
			_tf.changeTextFormat(false, _color);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			SoundManager.getInstance().playSFX(SoundRes.SFX_MOUSE_CLICK);
		}
		
		private function outHandler(e:MouseEvent = null):void
		{
			_tf.changeTextFormat(false, _color);
		}
		
		private function overHandler(e:MouseEvent):void
		{
			_tf.changeTextFormat(false, _colorHover);
		}
		
		public function changeText(text:String, handler:Function = null):void
		{
			_tf.htmlText = text;
			_tf.changeTextFormat(true);
			
			if (handler !== null)
			{
				this.removeEventListener(MouseEvent.CLICK, _handler);
				_handler = handler;
				this.addEventListener(MouseEvent.CLICK, _handler);
			}
		}
		
		public function get tf():TextBox
		{
			return _tf;
		}
	
	}

}