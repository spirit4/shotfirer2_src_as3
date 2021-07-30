package sound
{
	import flash.display.Sprite;
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class SoundRes
	{
		static public const THEME_MENU:int = 0;
		static public const THEME_GAME:int = 1;
		
		static public const SFX_ACHIEVEMENT:int = 0;
		static public const SFX_PRESS_OFF:int = 1;
		static public const SFX_PRESS_ON:int = 2;
		static public const SFX_MOUSE_CLICK:int = 3;
		static public const SFX_MOUSE_HOVER:int = 4;
		static public const SFX_BONUS_TNT:int = 5;
		static public const SFX_SET_TNT:int = 6;
		static public const SFX_STONE_TNT:int = 7;
		static public const SFX_BOX_GROUND_TNT:int = 8;
		static public const SFX_DYNAMITE:int = 9;
		static public const SFX_DYNAMITE_1:int = 10;
		static public const SFX_FUSE:int = 11;
		static public const SFX_GAME_COMPLETE:int = 12;
		static public const SFX_GET_ART:int = 13;
		static public const SFX_GET_TNT:int = 14;
		static public const SFX_GET_GEM:int = 15;
		static public const SFX_DEATH_GOLLUM:int = 16;
		static public const SFX_DEATH_PARROT:int = 17;
		static public const SFX_DEATH_SPIKE:int = 18;
		static public const SFX_DEATH_TNT:int = 19;
		static public const SFX_JUMP_STONE:int = 20;
		static public const SFX_JUMP_GROUND:int = 21;
		static public const SFX_LEVEL_COMPLETE:int = 22;
		static public const SFX_TRANSITION:int = 23;
		static public const SFX_BOX_ON_MONSTER:int = 24;
		static public const SFX_ATTACK_CRAB:int = 25;
		static public const SFX_ATTACK_PARROT:int = 26;
		static public const SFX_NO_TNT:int = 27;
		static public const SFX_SPIKE_ONOFF:int = 28;
		static public const SFX_STAIR_ONOFF:int = 29;
		static public const SFX_STONE_ON:int = 30;
		static public const SFX_STONE_OFF:int = 31;
		static public const SFX_JUMP:int = 32;
		static public const SFX_BOX_DOWN:int = 33;
		
		static public const LOOP_BOX_MOVE:int = 0;
		static public const LOOP_MOVE_SOLID:int = 1;
		static public const LOOP_MOVE_STAIR:int = 2;
		static public const LOOP_MOVE_SOFT:int = 3;
		static public const LOOP_CREEP:int = 4;
		
		static public var themes:Vector.<Vector.<Sound>> = new Vector.<Vector.<Sound>>();
		static public var sfxs:Vector.<Sound> = new Vector.<Sound>();
		static public var loops:Vector.<Sound> = new Vector.<Sound>();
		
		public function SoundRes()
		{
		
		}
		
		static public function init():void
		{
			themes[0] = new Vector.<Sound>();
			themes[1] = new Vector.<Sound>();
			themes[0].push(new MMenu());
			themes[1].push(new MGame2());
			themes[1].push(new MGame());
			
			sfxs.push(new SAch());
			sfxs.push(new SPressOff());
			sfxs.push(new SPressOn());
			sfxs.push(new SClick());
			sfxs.push(new SOver());
			sfxs.push(new SBonusDynamite());
			sfxs.push(new SSetTNT());
			sfxs.push(new STNT());
			sfxs.push(new SGroundTNT());
			sfxs.push(new SDynamite0());
			sfxs.push(new SDynamite1());
			sfxs.push(new SFuse());
			sfxs.push(new SGameComplete());
			sfxs.push(new SGetArt());
			sfxs.push(new SGetTNT());
			sfxs.push(new SGetGem());
			sfxs.push(new SDeathGollum());
			sfxs.push(new SDeathParrot());
			sfxs.push(new SDeathSpike());
			sfxs.push(new SDeathTNT());
			sfxs.push(new SJumpStone());
			sfxs.push(new SJumpGround());
			sfxs.push(new SLevelComplete());
			sfxs.push(new STransition());
			sfxs.push(new SBoxOnMonster());
			sfxs.push(new SCrabAttack());
			sfxs.push(new SParrotAttack());
			sfxs.push(new SNoTNT());
			sfxs.push(new SSpikeOnOff());
			sfxs.push(new SStairOnOff());
			sfxs.push(new SStoneOn());
			sfxs.push(new SStoneOff());
			sfxs.push(new SJump());
			sfxs.push(new SBoxDown());
			
			loops.push(new LBoxMove());
			loops.push(new LMoveSolid());
			loops.push(new LMoveStair());
			loops.push(new LMoveSoft());
			loops.push(new LCreep());
		}

	}
}