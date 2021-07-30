package event
{
	
	import flash.events.Event;
	
	public class WindowEvent extends Event
	{
		public static const GO_TO_WINDOW:String = "goToWindow";
		public static const GO_TO_POPUP:String = "goToPopup";
		
		//public static const FINISHED_EDITING:String = "finishedEditing";
		//public static const RETURN_TO_EDITING:String = "returnToEditing";

		public static const RETURN_TO_MENU:String = "returnToMenu";
		public static const SELECT_LEVEL:String = "selectLevel";
		public static const NEXT_LEVEL:String = "selectLevel";
		public static const RESET_LEVEL:String = "resetLevel";
		public static const PAUSE:String = "pause";
		public static const INTRO_DONE:String = "introDone";
		
		public var window:int = -1;
		
		public function WindowEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var e:WindowEvent = new WindowEvent(type, bubbles, cancelable);
			e.window = window;
			return e;
		}
	}
}