package utils.debug
{
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import utils.TextBox;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Console extends Sprite
	{
		private var _tf:TextBox;
		private var _chatId:int = -1;
		
		public function Console(w:Number)
		{
			super();
			
			_tf = new TextBox(w, 280, 12, 0xFFFFFF, "Courier", ">>", TextFieldAutoSize.NONE, false, false, null, TextFieldType.INPUT, true, true, 0x222222);
			addChild(_tf);
			_tf.alpha = 0.5;
			//_tf.x = 20;
			//_tf.y = 10;
		}
		
		public function checkInput(keyCode:int):void
		{
			//trace(_tf.getLineText(_tf.numLines - 1));
			//const str:String = _tf.getLineText(_tf.numLines - 1);
			////trace(str.substr(0, 12), str.substr(13, 1));
			//if (str.substr(0, 12) == "connect chat")
			//{
			//_chatId = int(str.substr(14, 1));
			//return;
			//}
			//
			//if (_chatId != -1)
			//{
			//if (str.substr(0, 6) == "update")
			//requestChat();
			//else
			//sendMessage(str);
			//}
		}
		
		public function get tf():TextBox
		{
			return _tf;
		}
	}

}