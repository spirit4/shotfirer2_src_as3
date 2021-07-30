package event
{
	
	import flash.events.Event;
	import nape.phys.Body;
	
	public class GameEvent extends Event
	{
		public static const LEVEL_INIT:String = "levelInit";
		
		public static const GAME_COMPLETE:String = "gameComplete";
		
		public static const HERO_TO_EXIT:String = "heroToExit";
		public static const HERO_DEAD:String = "heroDead";
		public static const HERO_SIT:String = "heroSit";
		public static const SET_DYNAMITE:String = "setDynamite";
		public static const DETONATED_DYNAMITE:String = "detonatedDynamite";
		
		public static const CHANGE_LEVEL:String = "changeLevel";
		public static const CHANGE_CAPACITY:String = "changeCapacity";
		
		public static const ENEMY_DIED:String = "enemyDied";
		
		/**
		 * -1 left, 1 right, 0 down
		 */
		public var index:int;
		public var body:Body;
		
		public function GameEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var e:GameEvent = new GameEvent(type, bubbles, cancelable);
			e.index = index;
			e.body = body;
			return e;
		}
	}
}