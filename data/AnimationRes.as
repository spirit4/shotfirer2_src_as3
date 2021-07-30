package data
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class AnimationRes
	{
		//types
		public static const HERO_RIGHT:int = 0;
		public static const HERO_RIGHT_IDLE:int = 1;
		public static const HERO_UP_AND_DOWN:int = 2;
		public static const HERO_RIGHT_JUMP_UP:int = 3;
		public static const HERO_RIGHT_JUMP_IDLE:int = 4;
		public static const HERO_RIGHT_JUMP_DOWN:int = 5;
		public static const TNT_BOOM:int = 6;
		public static const TNT_FUSE:int = 7;
		public static const TNT_TIMER:int = 8;
		public static const GEM:int = 9;
		public static const HERO_DOWN_RIGHT:int = 10;
		public static const HERO_CREEP_RIGHT:int = 11;
		public static const HERO_BOX_RIGHT:int = 12;
		public static const HERO_TNT_RIGHT:int = 13;
		public static const HERO_SIT_TNT_RIGHT_IN:int = 14;
		public static const HERO_SIT_TNT_RIGHT_OUT:int = 15;
		public static const TNT_BOOM_SMALL:int = 16;
		public static const TNT_BOOM_BIG:int = 17;
		public static const GOLLUM_MOVE:int = 18;
		public static const LEVEL_RUBIN:int = 19;
		public static const LEVEL:int = 20;
		public static const BONUS_BOOM:int = 21;
		public static const TORCH:int = 22;
		public static const SAND:int = 23;
		public static const PRESS_0:int = 24;
		public static const PRESS_1:int = 25;
		public static const PRESS_2:int = 26;
		public static const SMOKE:int = 27;
		public static const DUST_RUN:int = 28;
		public static const GOLLUM_ATTACK:int = 29;
		public static const HERO_DEATH_RIGHT:int = 30;
		public static const GEM_GET:int = 31;
		public static const HERO_GO_OFF:int = 32;
		public static const ACHIEVEMENT:int = 33;
		public static const ARTIFACT:int = 34;
		public static const ARTIFACT_GET:int = 35;
		public static const IDOL:int = 36;
		public static const DUST_JUMP:int = 37;
		public static const CRAB_MOVE:int = 38;
		public static const CRAB_ATTACK:int = 39;
		public static const PARROT_MOVE:int = 40;
		public static const PARROT_ATTACK:int = 41;
		public static const TNT_GET:int = 42;
		public static const STAR:int = 43;
		public static const SPIT:int = 44;
		public static const WORM_IDLE:int = 45;
		public static const WORM_ATTACK:int = 46;
		public static const CASE_TNT:int = 47;
		public static const CASE_BATTERY:int = 48;
		public static const BATTERY_GET:int = 49;
		public static const COINS_0:int = 50;
		public static const COINS_0_GET:int = 51;
		public static const COINS_1:int = 52;
		public static const COINS_1_GET:int = 53;
		public static const COINS_2:int = 54;
		public static const COINS_2_GET:int = 55;
		public static const COINS_3:int = 56;
		public static const COINS_3_GET:int = 57;
		
		//keys
		public static const HERO_JUMP_UP:Array = [0, 7];
		public static const HERO_JUMP_IDLE:Array = [8, 12];
		public static const HERO_JUMP_DOWN:Array = [13, 14];
		
		public static const HERO_SIT_TNT_IN:Array = [0, 6];
		public static const HERO_SIT_TNT_OUT:Array = [7, 13];
		
		public static const WORM_IDLE_KEYS:Array = [0, 29];
		public static const WORM_ATTACK_KEYS:Array = [30, 44];
		
		static public var animReses:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		public function AnimationRes()
		{
		
		}
		
		public static function init():void
		{
			var anim:Sprite = new AnimationsResources() as Sprite;
			const len:int = anim.numChildren;
			for (var i:int = 0; i < len; i++)
			{
				animReses[i] = (anim.getChildAt(i) as Bitmap).bitmapData;
			}
		}
		
		public static function getSpriteList(type:int):BitmapData
		{
			return animReses[type];
		}
	}

}