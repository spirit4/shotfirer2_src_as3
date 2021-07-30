package data
{
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.properties.DisplayShortcuts;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import utils.RandUtils;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class ImageRes
	{
		public static const NONE:int = 0;
		
		//bodies
		public static const SPIKE:int = 1;
		public static const EXIT:int = 2;
		public static const GEM:int = 3;
		public static const GROUND:int = 4;
		public static const HERO:int = 5;
		public static const STAIRS:int = 6;
		public static const TROLLEY:int = 7;
		public static const BOX_TNT:int = 8;
		public static const TORCH:int = 9;
		public static const ARTEFACT:int = 10;
		public static const IDOL:int = 11;
		public static const CASE_TNT:int = 12;
		public static const CASE_BATTERY:int = 13;
		public static const LOGO_BODY:int = 14;
		public static const STONE:int = 20;
		public static const DECOR_STONE:int = 21;
		public static const DECOR_GRASS:int = 22;
		public static const DECOR_BOARD:int = 23;
		//public static const STONE_3H:int = 24;
		public static const PRESS_0:int = 30;
		public static const PRESS_1:int = 31;
		public static const PRESS_2:int = 32;
		public static const MARK_0:int = 40;
		public static const MARK_1:int = 41;
		public static const MARK_2:int = 42;
		public static const GOLLUM:int = 50;
		public static const CRAB:int = 51;
		public static const PARROT:int = 52;
		public static const WORM:int = 53;
		public static const WEB_0:int = 54;
		public static const WEB_1:int = 55;
		public static const WEB_2:int = 56;
		public static const WEB_3:int = 57;
		public static const WEB_4:int = 58;
		public static const WEB_5:int = 59;
		public static const BOND_0:int = 60;
		public static const BOND_1:int = 61;
		public static const BOND_2:int = 62;
		public static const BOND_3:int = 63;
		public static const ICICLE_0:int = 65;
		public static const ICICLE_1:int = 66;
		public static const ICICLE_2:int = 67;
		public static const ICICLE_3:int = 68;
		public static const ICICLE_4:int = 69;
		public static const HOLE_0:int = 70;
		public static const HOLE_1:int = 71;
		public static const HOLE_2:int = 72;
		public static const SPLIT_0:int = 73;
		public static const SPLIT_1:int = 74;
		public static const SPLIT_2:int = 75;
		public static const SPLIT_3:int = 76;
		public static const SPLIT_4:int = 77;
		public static const SPLIT_5:int = 78;
		public static const SPLIT_CROSS_0:int = 79;
		public static const SPLIT_CROSS_1:int = 80;
		public static const SPLIT_CROSS_2:int = 81;
		public static const SPLIT_CROSS_3:int = 82;
		public static const COIN_0:int = 83;
		public static const COIN_1:int = 84;
		public static const COIN_2:int = 85;
		public static const COIN_3:int = 86;
		public static const ROCK:int = 101;
		public static const ROCK_0:int = 102;
		public static const ROCK_1:int = 103;
		public static const ROCK_2:int = 104;
		public static const ROCK_2W_0:int = 105;
		public static const ROCK_2W_1:int = 106;
		public static const ROCK_2W_2:int = 107;
		public static const ROCK_3W_0:int = 108;
		public static const ROCK_3W_1:int = 109;
		public static const ROCK_3W_2:int = 110;
		public static const ROCK_2H_0:int = 111;
		public static const ROCK_2H_1:int = 112;
		public static const ROCK_2H_2:int = 113;
		public static const ROCK_3H_0:int = 114;
		public static const ROCK_3H_1:int = 115;
		public static const ROCK_3H_2:int = 116;
		
		static public const DECOR_RANGES:Object = {
			21 : [0, 10], //
			22 : [0, 15], //
			23 : [0, 3] //
		}
		
		static public const DECOR_PERCENTAGES:Object = {
			21 : 6, //
			22 : 15, //
			23 : 3 //
		}
		
		private static var percentTiles:Vector.<Vector.<int>> = new <Vector.<int>>[ //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[18, 7, 7, 11, 7, 50], //
			new <int>[100], //5
			new <int>[50, 50], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //10
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //15
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //20
			new <int>[25,25,25,25], //
			new <int>[35,35,30], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //25
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //	
			new <int>[100], //30
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //35
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //40
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //45
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //50
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //55
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //60
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //65
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //70
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //75
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //80
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //85
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //90
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //95
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //100
			new <int>[20, 20, 20, 7, 6, 6, 7, 7, 7], //
			]; //
		
		//only graphic
		public static const TOP_GROUND:int = 0;
		public static const RIGHT_GROUND:int = 1;
		public static const BOTTOM_GROUND:int = 2;
		public static const LEFT_GROUND:int = 3;
		public static const RUBIN_GROUND:int = 4;
		
		private static var percentImagesTile:Vector.<Vector.<int>> = new <Vector.<int>>[ ///
			new <int>[100], //
			new <int>[100],//new <int>[50, 50], //
			new <int>[100],//new <int>[50, 50], //
			new <int>[100],//new <int>[50, 50], //
			new <int>[100], //
			new <int>[100], //
			new <int>[100], //
			]; //
		
		//buttons
		public static const BUTTON_RESET:int = 0;
		public static const BUTTON_RESET_HOVER:int = 1;
		public static const BUTTON_PAUSE:int = 2;
		public static const BUTTON_PAUSE_HOVER:int = 3;
		public static const BUTTON_MENU:int = 4;
		public static const BUTTON_MENU_HOVER:int = 5;
		public static const BUTTON_SOUND_ON:int = 6;
		public static const BUTTON_SOUND_ON_HOVER:int = 7;
		public static const BUTTON_SOUND_OFF:int = 8;
		public static const BUTTON_SOUND_OFF_HOVER:int = 9;
		//public static const BUTTON_LOGO:int = 10;
		public static const BUTTON_PLAY:int = 11;
		public static const BUTTON_PLAY_HOVER:int = 12;
		public static const BUTTON_MORE:int = 13;
		public static const BUTTON_MORE_HOVER:int = 14;
		public static const BUTTON_CREDITS:int = 15;
		public static const BUTTON_CREDITS_HOVER:int = 16;
		//public static const BUTTON_BOARD:int = 17;
		//public static const BUTTON_BOARD_HOVER:int = 18;
		public static const BUTTON_ACHIEVE:int = 19;
		public static const BUTTON_ACHIEVE_HOVER:int = 20;
		public static const BUTTON_SHOP:int = 21;
		public static const BUTTON_SHOP_HOVER:int = 22;
		public static const BUTTON_BACK:int = 23;
		public static const BUTTON_BACK_HOVER:int = 24;
		public static const BUTTON_LEVEL:int = 25;
		public static const BUTTON_LEVEL_HOVER:int = 26;
		public static const BUTTON_LVL_RESTART:int = 27;
		public static const BUTTON_LVL_RESTART_HOVER:int = 28;
		//public static const BUTTON_LVL_NEXT:int = 29;
		//public static const BUTTON_LVL_NEXT_HOVER:int = 30;
		//public static const BUTTON_LVL_MENU:int = 31;
		//public static const BUTTON_LVL_MENU_HOVER:int = 32;
		public static const BUTTON_LEVELS:int = 33;
		public static const BUTTON_LEVELS_HOVER:int = 34;
		public static const BUTTON_BUY:int = 35;
		public static const BUTTON_BUY_HOVER:int = 36;
		//public static const BUTTON_MAP:int = 37;
		//public static const BUTTON_MAP_HOVER:int = 38;
		//public static const BUTTON_FINAL:int = 39;
		//public static const BUTTON_FINAL_HOVER:int = 40;
		//public static const BUTTON_FINAL_COMPLETE:int = 41;
		//public static const BUTTON_FINAL_COMPLETE_HOVER:int = 42;
		
		public static const BUTTON_OPTIONS:int = 61;
		public static const BUTTON_OPTIONS_HOVER:int = 62;
		public static const BUTTON_LEFT:int = 63;
		public static const BUTTON_LEFT_HOVER:int = 64;
		public static const BUTTON_RIGHT:int = 65;
		public static const BUTTON_RIGHT_HOVER:int = 66;
		
		//branding
		public static const BUTTON_DOWNLOAD:int = 43;
		public static const BUTTON_DOWNLOAD_HOVER:int = 44;
		public static const BUTTON_HIGHSCORE:int = 45;
		public static const BUTTON_HIGHSCORE_HOVER:int = 46;
		public static const BUTTON_SUBMIT:int = 47;
		public static const BUTTON_SUBMIT_HOVER:int = 48;
		public static const BUTTON_QUESTION:int = 49;
		public static const BUTTON_QUESTION_HOVER:int = 50;
		public static const BUTTON_WALKTHROUGH:int = 51;
		public static const BUTTON_WALKTHROUGH_HOVER:int = 52;
		public static const BUTTON_FACEBOOK:int = 53;
		public static const BUTTON_FACEBOOK_HOVER:int = 54;
		public static const BUTTON_TWITTER:int = 55;
		public static const BUTTON_TWITTER_HOVER:int = 56;
		public static const BUTTON_MUSIC_ON:int = 57;
		public static const BUTTON_MUSIC_ON_HOVER:int = 58;
		public static const BUTTON_MUSIC_OFF:int = 59;
		public static const BUTTON_MUSIC_OFF_HOVER:int = 60;
		
		//elements
		public static const EL_BOOM_PIECE_0:int = 0;
		public static const EL_BOOM_PIECE_1:int = 1;
		public static const EL_BOOM_PIECE_2:int = 2;
		public static const EL_BOOM_PIECE_3:int = 3;
		public static const EL_RUBIN:int = 4;
		public static const EL_RUBIN_BACK:int = 5;
		public static const EL_LEVEL_LOCK:int = 6;
		public static const EL_COMPLETE:int = 7;
		public static const EL_LEVEL_RUBY_SLOT:int = 8;
		public static const EL_ARROW:int = 9;
		public static const EL_MEAT_0:int = 10;
		public static const EL_MEAT_1:int = 11;
		public static const EL_MEAT_2:int = 12;
		public static const EL_MEAT_3:int = 13;
		public static const EL_MEAT_4:int = 14;
		public static const EL_MEAT_5:int = 15;
		public static const EL_TROLLEY_WHEEL:int = 16;
		public static const EL_HERO_MEAT_0:int = 17;
		public static const EL_HERO_MEAT_1:int = 18;
		public static const EL_HERO_MEAT_2:int = 19;
		public static const EL_ACH_BG:int = 20;
		public static const EL_ACH_ITEM:int = 21;
		public static const EL_ACH_BG_COUNTER:int = 22;
		public static const EL_LOGO_GUI:int = 23;
		public static const EL_ARC_GUI:int = 24;
		public static const EL_BATTERY_GUI:int = 25;
		public static const EL_INTRO_1:int = 26;
		public static const EL_INTRO_2:int = 27;
		public static const EL_INTRO_3:int = 28;
		public static const EL_INTRO_4:int = 29;
		public static const EL_BOX_0:int = 30;
		public static const EL_BOX_1:int = 31;
		public static const EL_BOX_2:int = 32;
		public static const EL_BOX_3:int = 33;
		public static const EL_GLOW:int = 34;
		public static const EL_PARROT_BULLET:int = 35;
		public static const EL_HELP_BG:int = 36;
		//public static const EL_MEAT_PARROT_1:int = 37;
		//public static const EL_MEAT_PARROT_2:int = 38;
		//public static const EL_MEAT_CRAB_0:int = 39;
		//public static const EL_MEAT_CRAB_1:int = 40;
		//public static const EL_MEAT_CRAB_2:int = 41;
		public static const EL_INTRO_EYES:int = 42;
		public static const EL_ROCKFALL_0:int = 43;
		public static const EL_ROCKFALL_1:int = 44;
		public static const EL_ROCKFALL_2:int = 45;
		public static const EL_ROCKFALL_3:int = 46;
		public static const EL_ROCKFALL_4:int = 47;
		public static const EL_CHECKMARK:int = 48;
		public static const EL_CROSSMARK:int = 49;
		public static const EL_QUESTION:int = 50;
		public static const EL_MAP_LINK:int = 51;
		public static const EL_BG_SCORE:int = 52;
		public static const EL_COINS:int = 53;
		public static const EL_NUM_TNT:int = 54;
		public static const EL_LEVELS_DECK:int = 55;
		public static const EL_LEVELS_IDOL:int = 56;
		public static const EL_LEVELS_IDOL_BACK:int = 57;
		public static const EL_SHOP_BUTTON_MARK:int = 58;
		public static const EL_SHOP_DECK:int = 59;
		public static const EL_UPGRADE_MARK:int = 60;
		public static const EL_UPGRADE_MARK_ACTIVE:int = 61;
		public static const EL_RADAR_RANGE:int = 62;
		public static const EL_RADAR_RANGE_ACTIVE:int = 63;
		public static const EL_VICTORY_RUBY_0_0:int = 64;
		public static const EL_VICTORY_RUBY_0_1:int = 65;
		public static const EL_VICTORY_RUBY_1_0:int = 66;
		public static const EL_VICTORY_RUBY_1_1:int = 67;
		public static const EL_VICTORY_RUBY_2_0:int = 68;
		public static const EL_VICTORY_RUBY_2_1:int = 69;
		public static const EL_VICTORY_RUBY_3_0:int = 70;
		public static const EL_VICTORY_RUBY_3_1:int = 71;
		
		
		//backgrounds
		public static const LEVEL_0:int = 0;
		public static const MAIN_MENU_0:int = 1;
		public static const MAIN_MENU_1:int = 2;
		public static const MAIN_MENU_2:int = 3;
		public static const CREDITS:int = 4;
		public static const LEVELS:int = 5;
		public static const COMPLETE:int = 6;
		
		//tooltips
		public static const HINT_LVL_1_1:int = 0;
		public static const HINT_LVL_1_2:int = 1;
		public static const HINT_LVL_1_3:int = 2;
		public static const HINT_LVL_2_1:int = 3;
		public static const HINT_LVL_3_1:int = 4;
		public static const HINT_LVL_3_2:int = 5;
		public static const HINT_LVL_4_1:int = 6;
		public static const HINT_LVL_4_2:int = 7;
		public static const HINT_LVL_5_1:int = 8;
		public static const HINT_LVL_6_1:int = 9;
		public static const HINT_LVL_7_1:int = 10;
		public static const HINT_LVL_8_1:int = 11;
		public static const HINT_LVL_9_1:int = 12;
		public static const HINT_LVL_10_1:int = 13;
		
		[Embed(source="../../images/tooltips/L1-Help1.png")]
		private static var Hint0:Class;
		[Embed(source="../../images/tooltips/L1-Help2.png")]
		private static var Hint1:Class;
		[Embed(source="../../images/tooltips/L1-Help3.png")]
		private static var Hint2:Class;
		[Embed(source="../../images/tooltips/L2-Help1.png")]
		private static var Hint3:Class;
		[Embed(source="../../images/tooltips/L3-Help1.png")]
		private static var Hint4:Class;
		[Embed(source="../../images/tooltips/L3-Help2.png")]
		private static var Hint5:Class;
		[Embed(source="../../images/tooltips/L4-Help1.png")]
		private static var Hint6:Class;
		[Embed(source="../../images/tooltips/L4-Help2.png")]
		private static var Hint7:Class;
		[Embed(source="../../images/tooltips/L5-Help1.png")]
		private static var Hint8:Class;
		[Embed(source="../../images/tooltips/L6-Help1.png")]
		private static var Hint9:Class;
		[Embed(source="../../images/tooltips/L7-Help1.png")]
		private static var Hint10:Class;
		[Embed(source="../../images/tooltips/L8-Help1.png")]
		private static var Hint11:Class;
		[Embed(source="../../images/tooltips/L9-Help1.png")]
		private static var Hint12:Class;
		[Embed(source="../../images/tooltips/L10-Help1.png")]
		private static var Hint13:Class;
		
		[Embed(source="../../images/bodies_tile/Spikes.png")]
		private static var Asset1:Class;
		
		[Embed(source="../../images/bodies_tile/exit.png")]
		private static var Asset2:Class;
		
		[Embed(source="../../images/bodies_tile/gem.png")]
		private static var Asset3:Class;
		
		[Embed(source="../../images/bodies_tile/Ground1.png")]
		private static var Asset4_0:Class;
		[Embed(source="../../images/bodies_tile/Ground2.png")]
		private static var Asset4_1:Class;
		[Embed(source="../../images/bodies_tile/Ground3.png")]
		private static var Asset4_2:Class;
		[Embed(source="../../images/bodies_tile/Ground4.png")]
		private static var Asset4_3:Class;
		[Embed(source="../../images/bodies_tile/Ground5.png")]
		private static var Asset4_4:Class;
		[Embed(source="../../images/bodies_tile/Ground.png")]
		private static var Asset4_5:Class;
		
		[Embed(source="../../images/bodies_tile/hero.png")]
		private static var Asset5:Class;
		
		[Embed(source="../../images/bodies_tile/Ladder1.png")]
		private static var Asset6_0:Class;
		[Embed(source="../../images/bodies_tile/Ladder2.png")]
		private static var Asset6_1:Class;
		
		[Embed(source="../../images/bodies_tile/Vagonetka.png")]
		private static var Asset7:Class;
		[Embed(source="../../images/bodies_tile/BoxTNT.png")]
		private static var Asset8:Class;
		
		[Embed(source="../../images/bodies_tile/Fakel.png")]
		private static var Asset9:Class;
		
		[Embed(source="../../images/bodies_tile/Artefact.png")]
		private static var Asset10:Class;
		
		[Embed(source="../../images/bodies_tile/Idol2.png")]
		private static var Asset11:Class;
		
		[Embed(source="../../images/bodies_tile/tnt.png")]
		private static var Asset12:Class;
		[Embed(source="../../images/bodies_tile/battery.png")]
		private static var Asset13:Class;
		
		[Embed(source="../../images/bodies_tile/Logo.png")]
		private static var Asset14:Class;
		
		[Embed(source="../../images/bodies_tile/Stone1.png")]
		private static var Asset20:Class;
		
		[Embed(source="../../images/bodies_tile/Kamen.png")]
		private static var Asset21_0:Class;
		[Embed(source="../../images/bodies_tile/Kamen2.png")]
		private static var Asset21_1:Class;
		[Embed(source="../../images/bodies_tile/Kamen3.png")]
		private static var Asset21_2:Class;
		[Embed(source="../../images/bodies_tile/Kamen4.png")]
		private static var Asset21_3:Class;
		[Embed(source="../../images/bodies_tile/Grass.png")]
		private static var Asset22_0:Class;
		[Embed(source="../../images/bodies_tile/Grass2.png")]
		private static var Asset22_1:Class;
		[Embed(source="../../images/bodies_tile/Grass3.png")]
		private static var Asset22_2:Class;
		[Embed(source="../../images/bodies_tile/Tablichka.png")]
		private static var Asset23:Class;
		//[Embed(source="../../images/bodies_tile/Stone2X-w2.png")]
		//private static var Asset21_1:Class;
		//[Embed(source="../../images/bodies_tile/Stone2X-w3.png")]
		//private static var Asset21_2:Class;
		//[Embed(source="../../images/bodies_tile/Stone3X-w1.png")]
		//private static var Asset22_0:Class;
		//[Embed(source="../../images/bodies_tile/Stone3X-w2.png")]
		//private static var Asset22_1:Class;
		//[Embed(source="../../images/bodies_tile/Stone3X-w3.png")]
		//private static var Asset22_2:Class;
		//[Embed(source="../../images/bodies_tile/Stone2X-h1.png")]
		//private static var Asset23_0:Class;
		//[Embed(source="../../images/bodies_tile/Stone2X-h2.png")]
		//private static var Asset23_1:Class;
		//[Embed(source="../../images/bodies_tile/Stone2X-h3.png")]
		//private static var Asset23_2:Class;
		//[Embed(source="../../images/bodies_tile/Stone3X-h1.png")]
		//private static var Asset24_0:Class;
		//[Embed(source="../../images/bodies_tile/Stone3X-h2.png")]
		//private static var Asset24_1:Class;
		//[Embed(source="../../images/bodies_tile/Stone3X-h3.png")]
		//private static var Asset24_2:Class;
		
		[Embed(source="../../images/bodies_tile/Button1.png")]
		private static var Asset30:Class;
		[Embed(source="../../images/bodies_tile/Button2.png")]
		private static var Asset31:Class;
		[Embed(source="../../images/bodies_tile/Button3.png")]
		private static var Asset32:Class;
		
		[Embed(source="../../images/bodies_tile/mark1.png")]
		private static var Asset40:Class;
		[Embed(source="../../images/bodies_tile/mark2.png")]
		private static var Asset41:Class;
		[Embed(source="../../images/bodies_tile/mark3.png")]
		private static var Asset42:Class;
		
		[Embed(source="../../images/bodies_tile/Gollum.png")]
		private static var Asset50:Class;
		[Embed(source="../../images/bodies_tile/Monstr2.png")]
		private static var Asset51:Class;
		[Embed(source="../../images/bodies_tile/Monstr3.png")]
		private static var Asset52:Class;
		[Embed(source="../../images/bodies_tile/worm.png")]
		private static var Asset53:Class;
		
		[Embed(source="../../images/bodies_tile/decor/spider1.png")]
		private static var Asset54:Class;
		[Embed(source="../../images/bodies_tile/decor/spider2.png")]
		private static var Asset55:Class;
		[Embed(source="../../images/bodies_tile/decor/spider3.png")]
		private static var Asset56:Class;
		[Embed(source="../../images/bodies_tile/decor/spider4.png")]
		private static var Asset57:Class;
		[Embed(source="../../images/bodies_tile/decor/spiderbig1.png")]
		private static var Asset58:Class;
		[Embed(source="../../images/bodies_tile/decor/spiderbig2.png")]
		private static var Asset59:Class;
		
		[Embed(source="../../images/bodies_tile/bond0.png")]
		private static var Asset60:Class;
		[Embed(source="../../images/bodies_tile/bond1.png")]
		private static var Asset61:Class;
		[Embed(source="../../images/bodies_tile/bond2.png")]
		private static var Asset62:Class;
		[Embed(source="../../images/bodies_tile/bond3.png")]
		private static var Asset63:Class;
		
		[Embed(source="../../images/bodies_tile/decor/Sosulya1.png")]
		private static var Asset65:Class;
		[Embed(source="../../images/bodies_tile/decor/Sosulya2.png")]
		private static var Asset66:Class;
		[Embed(source="../../images/bodies_tile/decor/Sosulya3.png")]
		private static var Asset67:Class;
		[Embed(source="../../images/bodies_tile/decor/Sosulya4.png")]
		private static var Asset68:Class;
		[Embed(source="../../images/bodies_tile/decor/Sosulya5.png")]
		private static var Asset69:Class;
		
		[Embed(source="../../images/bodies_tile/decor/hole1.png")]
		private static var Asset70:Class;
		[Embed(source="../../images/bodies_tile/decor/hole2.png")]
		private static var Asset71:Class;
		[Embed(source="../../images/bodies_tile/decor/hole3.png")]
		private static var Asset72:Class;
		
		[Embed(source="../../images/bodies_tile/decor/Shel1.png")]
		private static var Asset73:Class;
		[Embed(source="../../images/bodies_tile/decor/Shel2.png")]
		private static var Asset74:Class;
		[Embed(source="../../images/bodies_tile/decor/Shel3.png")]
		private static var Asset75:Class;
		[Embed(source="../../images/bodies_tile/decor/Shel4.png")]
		private static var Asset76:Class;
		[Embed(source="../../images/bodies_tile/decor/Shel5.png")]
		private static var Asset77:Class;
		[Embed(source="../../images/bodies_tile/decor/Shel6.png")]
		private static var Asset78:Class;
		
		[Embed(source="../../images/bodies_tile/decor/Krest1.png")]
		private static var Asset79:Class;
		[Embed(source="../../images/bodies_tile/decor/Krest2.png")]
		private static var Asset80:Class;
		[Embed(source="../../images/bodies_tile/decor/Tresh1.png")]
		private static var Asset81:Class;
		[Embed(source="../../images/bodies_tile/decor/Tresh2.png")]
		private static var Asset82:Class;
		
		[Embed(source="../../images/bodies_tile/coin1.png")]
		private static var Asset83:Class;
		[Embed(source="../../images/bodies_tile/coin2.png")]
		private static var Asset84:Class;
		[Embed(source="../../images/bodies_tile/coin3.png")]
		private static var Asset85:Class;
		[Embed(source="../../images/bodies_tile/coin4.png")]
		private static var Asset86:Class;
		
		[Embed(source="../../images/bodies_tile/rock/Stone1.png")]
		private static var Asset101_0:Class;
		[Embed(source="../../images/bodies_tile/rock/Stone2.png")]
		private static var Asset101_1:Class;
		[Embed(source="../../images/bodies_tile/rock/Stone3.png")]
		private static var Asset101_2:Class;
		[Embed(source="../../images/bodies_tile/rock/Stone4.png")]
		private static var Asset101_3:Class;
		[Embed(source="../../images/bodies_tile/rock/Stone5.png")]
		private static var Asset101_4:Class;
		[Embed(source="../../images/bodies_tile/rock/Stone6.png")]
		private static var Asset101_5:Class;
		[Embed(source="../../images/bodies_tile/rock/Stone7.png")]
		private static var Asset101_6:Class;
		[Embed(source="../../images/bodies_tile/rock/Stone8.png")]
		private static var Asset101_7:Class;
		[Embed(source="../../images/bodies_tile/rock/Stone9.png")]
		private static var Asset101_8:Class;
		
		[Embed(source="../../images/bodies_tile/rock/Block-red-1x.png")]
		private static var Asset102:Class;
		[Embed(source="../../images/bodies_tile/rock/Block-green-1x.png")]
		private static var Asset103:Class;
		[Embed(source="../../images/bodies_tile/rock/Block-violet-1x.png")]
		private static var Asset104:Class;
		
		[Embed(source="../../images/bodies_tile/rock/Block-red-2x-w.png")]
		private static var Asset105:Class;
		[Embed(source="../../images/bodies_tile/rock/Block-green-2x-w.png")]
		private static var Asset106:Class;
		[Embed(source="../../images/bodies_tile/rock/Block-violet-2x-w.png")]
		private static var Asset107:Class;
		[Embed(source="../../images/bodies_tile/rock/Block-red-3x-w.png")]
		private static var Asset108:Class;
		[Embed(source="../../images/bodies_tile/rock/Block-green-3x-w.png")]
		private static var Asset109:Class;
		[Embed(source="../../images/bodies_tile/rock/Block-violet-3x-w.png")]
		private static var Asset110:Class;
		
		[Embed(source="../../images/bodies_tile/rock/Block-red-2x-h.png")]
		private static var Asset111:Class;
		[Embed(source="../../images/bodies_tile/rock/Block-green-2x-h.png")]
		private static var Asset112:Class;
		[Embed(source="../../images/bodies_tile/rock/Block-violet-2x-h.png")]
		private static var Asset113:Class;
		[Embed(source="../../images/bodies_tile/rock/Block-red-3x-h.png")]
		private static var Asset114:Class;
		[Embed(source="../../images/bodies_tile/rock/Block-green-3x-h.png")]
		private static var Asset115:Class;
		[Embed(source="../../images/bodies_tile/rock/Block-violet-3x-h.png")]
		private static var Asset116:Class;
		
		//-----------------------------------------------
		
		[Embed(source="../../images/images_tile/GroundDown.png")]
		private static var GraphicTile0:Class;
		
		[Embed(source="../../images/images_tile/GroundRight1.png")]
		private static var GraphicTile1_0:Class;
		//[Embed(source="../../images/images_tile/GroundRight2.png")]
		//private static var GraphicTile1_1:Class;
		
		[Embed(source="../../images/images_tile/GroundUp1.png")]
		private static var GraphicTile2_0:Class;
		//[Embed(source="../../images/images_tile/GroundUp2.png")]
		//private static var GraphicTile2_1:Class;
		
		[Embed(source="../../images/images_tile/GroundLeft1.png")]
		private static var GraphicTile3_0:Class;
		//[Embed(source="../../images/images_tile/GroundLeft2.png")]
		//private static var GraphicTile3_1:Class;
		
		[Embed(source="../../images/images_tile/GroundRubin.png")]
		private static var GraphicTile4:Class;
		
		//-----------------------------------------------
		
		[Embed(source="../../images/elements/Part1.png")]
		private static var Element0:Class;
		[Embed(source="../../images/elements/Part2.png")]
		private static var Element1:Class;
		[Embed(source="../../images/elements/Part3.png")]
		private static var Element2:Class;
		[Embed(source="../../images/elements/Part4.png")]
		private static var Element3:Class;
		
		[Embed(source="../../images/elements/RubinSmall.png")]
		private static var Element4:Class;
		[Embed(source="../../images/elements/RubinSmallBlack.png")]
		private static var Element5:Class;
		[Embed(source="../../images/elements/ButLock.png")]
		private static var Element6:Class;
		[Embed(source="../../images/elements/Complete.png")]
		private static var Element7:Class;
		[Embed(source="../../images/elements/RubinEmpty.png")]
		private static var Element8:Class;
		[Embed(source="../../images/elements/Strelka.png")]
		private static var Element9:Class;
		
		[Embed(source="../../images/elements/bone1.png")]
		private static var Element10:Class;  
		[Embed(source="../../images/elements/bone2.png")]
		private static var Element11:Class;  
		[Embed(source="../../images/elements/bone3.png")]
		private static var Element12:Class;  
		[Embed(source="../../images/elements/bone4.png")]
		private static var Element13:Class;  
		[Embed(source="../../images/elements/bone5.png")]
		private static var Element14:Class;  
		[Embed(source="../../images/elements/bone6.png")]
		private static var Element15:Class;
		
		[Embed(source="../../images/elements/Vagonetka-koleso.png")]
		private static var Element16:Class;
		
		[Embed(source="../../images/elements/HeroMeat/Meat1.png")]//2 shoes
		private static var Element17:Class;
		[Embed(source="../../images/elements/HeroMeat/Meat2.png")]
		private static var Element19:Class;
		
		[Embed(source="../../images/elements/Achievements3.png")]
		private static var Element20:Class;
		[Embed(source="../../images/elements/Achievements2.png")]
		private static var Element21:Class;
		[Embed(source="../../images/elements/mini-Pla.png")]
		private static var Element22:Class;
		
		[Embed(source = "../../images/elements/LogoSponsor.png")]
		private static var Element23:Class;
		
		[Embed(source="../../images/elements/arc.png")]
		private static var Element24:Class;
		[Embed(source="../../images/elements/Battery.png")]
		private static var Element25:Class;
		
		[Embed(source="../../images/elements/Intro/Intro1.png")]
		private static var Element26:Class;
		[Embed(source="../../images/elements/Intro/Intro2.png")]
		private static var Element27:Class;
		[Embed(source="../../images/elements/Intro/Intro3.png")]
		private static var Element28:Class;
		[Embed(source="../../images/elements/Intro/Intro4.png")]
		private static var Element29:Class;
		
		[Embed(source="../../images/elements/BoxPartcle/Bp0.png")]
		private static var Element30:Class;
		[Embed(source="../../images/elements/BoxPartcle/Bp1.png")]
		private static var Element31:Class;
		[Embed(source="../../images/elements/BoxPartcle/Bp2.png")]
		private static var Element32:Class;
		[Embed(source="../../images/elements/BoxPartcle/Bp3.png")]
		private static var Element33:Class;
		
		[Embed(source="../../images/elements/SunLights.png")]
		private static var Element34:Class;
		
		[Embed(source="../../images/elements/Bluvota.png")]
		private static var Element35:Class;
		
		[Embed(source="../../images/elements/helpPla1.png")]
		private static var Element36:Class;
		
		//[Embed(source="../../images/elements/Monstr3Meat2.png")]
		//private static var Element37:Class;
		//[Embed(source="../../images/elements/Monstr3Meat3.png")]
		//private static var Element38:Class;
		//
		//[Embed(source="../../images/elements/Monstr2Meat1.png")]
		//private static var Element39:Class;
		//[Embed(source="../../images/elements/Monstr2Meat2.png")]
		//private static var Element40:Class;
		//[Embed(source="../../images/elements/Monstr2Meat3.png")]
		//private static var Element41:Class;
		
		[Embed(source="../../images/elements/Intro/Glaza.png")]
		private static var Element42:Class;
		
		[Embed(source="../../images/elements/Perehod/kamenbig1.png")]
		private static var Element43:Class;
		[Embed(source="../../images/elements/Perehod/kamenbig2.png")]
		private static var Element44:Class;
		[Embed(source="../../images/elements/Perehod/kamenbig3.png")]
		private static var Element45:Class;
		[Embed(source="../../images/elements/Perehod/kamenbig4.png")]
		private static var Element46:Class;
		[Embed(source="../../images/elements/Perehod/kamenbig5.png")]
		private static var Element47:Class;
		
		[Embed(source="../../images/elements/Galka.png")]
		private static var Element48:Class;
		[Embed(source="../../images/elements/Krest.png")]
		private static var Element49:Class;
		
		[Embed(source="../../images/buttons/sponsor/Vopros.png")]
		private static var Element50:Class;
		[Embed(source="../../images/buttons/sponsor/Link.png")]
		private static var Element51:Class;
		
		[Embed(source="../../images/buttons/sponsor/PlashkaOchki.png")]
		private static var Element52:Class;
		
		[Embed(source="../../images/elements/Coin.png")]
		private static var Element53:Class;
		[Embed(source="../../images/elements/Dinamite.png")]
		private static var Element54:Class;
		
		[Embed(source="../../images/elements/LevelSelectPlashka.png")]
		private static var Element55:Class;
		[Embed(source="../../images/elements/ButFinalIdolActiv.png")]
		private static var Element56:Class;
		[Embed(source="../../images/elements/ButFinalIdol.png")]
		private static var Element57:Class;
		[Embed(source="../../images/elements/Voscl.png")]
		private static var Element58:Class;
		
		[Embed(source="../../images/elements/ShopPlashka.png")]
		private static var Element59:Class;
		[Embed(source="../../images/elements/Cell.png")]
		private static var Element60:Class;
		[Embed(source="../../images/elements/CellActiv.png")]
		private static var Element61:Class;
		[Embed(source="../../images/elements/Volna.png")]
		private static var Element62:Class;
		[Embed(source="../../images/elements/VolnaActiv.png")]
		private static var Element63:Class;
		
		[Embed(source="../../images/elements/0rubin-1.png")]
		private static var Element64:Class;
		[Embed(source="../../images/elements/0rubin-2.png")]
		private static var Element65:Class;
		[Embed(source="../../images/elements/1rubin-1.png")]
		private static var Element66:Class;
		[Embed(source="../../images/elements/1rubin-2.png")]
		private static var Element67:Class;
		[Embed(source="../../images/elements/2rubin-1.png")]
		private static var Element68:Class;
		[Embed(source="../../images/elements/2rubin-2.png")]
		private static var Element69:Class;
		[Embed(source="../../images/elements/3rubin-1.png")]
		private static var Element70:Class;
		[Embed(source="../../images/elements/3rubin-2.png")]
		private static var Element71:Class;
		//-----------------------------------------------
		
		[Embed(source="../../images/buttons/ButRestart.png")]
		private static var Button0:Class;
		[Embed(source="../../images/buttons/ButRestartActiv.png")]
		private static var Button1:Class;
		
		[Embed(source="../../images/buttons/ButPause.png")]
		private static var Button2:Class;
		[Embed(source="../../images/buttons/ButPauseActiv.png")]
		private static var Button3:Class;
		
		[Embed(source="../../images/buttons/ButLevelSelect.png")]
		private static var Button4:Class;
		[Embed(source="../../images/buttons/ButLevelSelectActiv.png")]
		private static var Button5:Class;
		
		[Embed(source="../../images/buttons/ButSoundON.png")]
		private static var Button6:Class;
		[Embed(source="../../images/buttons/ButSoundActiv.png")]
		private static var Button7:Class;
		[Embed(source="../../images/buttons/ButSoundOFF.png")]
		private static var Button8:Class;
		[Embed(source="../../images/buttons/ButSoundOFFActiv.png")]
		private static var Button9:Class;
		
		//[Embed(source="../../images/buttons/LogoSponsor.png")]
		//private static var Button10:Class;
		
		//[Embed(source="../../images/buttons/ButPlay.png")]
		//private static var Button11:Class;
		//[Embed(source="../../images/buttons/ButPlayActiv.png")]
		//private static var Button12:Class;
		
		[Embed(source="../../images/buttons/ButMoreGames.png")]
		private static var Button13:Class;
		[Embed(source="../../images/buttons/ButMoreGamesActiv.png")]
		private static var Button14:Class;
		
		[Embed(source="../../images/buttons/ButtonCredits.png")]
		private static var Button15:Class;
		[Embed(source="../../images/buttons/ButtonCreditsActiv.png")]
		private static var Button16:Class;
		
		//[Embed(source="../../images/buttons/ButLeaderboard.png")]
		//private static var Button17:Class;
		//[Embed(source="../../images/buttons/ButLeaderboardActiv.png")]
		//private static var Button18:Class;
		
		[Embed(source="../../images/buttons/ButAchievements.png")]
		private static var Button19:Class;
		[Embed(source="../../images/buttons/ButAchievementsActiv.png")]
		private static var Button20:Class;
		
		[Embed(source="../../images/buttons/ButShop.png")]
		private static var Button21:Class;
		[Embed(source="../../images/buttons/ButShopActiv.png")]
		private static var Button22:Class;
		
		[Embed(source="../../images/buttons/ButBack.png")]
		private static var Button23:Class;
		[Embed(source="../../images/buttons/ButBackActiv.png")]
		private static var Button24:Class;
		
		[Embed(source="../../images/buttons/ButL.png")]
		private static var Button25:Class;
		[Embed(source="../../images/buttons/ButLActiv.png")]
		private static var Button26:Class;
		
		[Embed(source="../../images/buttons/ButRestartCom.png")]
		private static var Button27:Class;
		[Embed(source="../../images/buttons/ButRestartComActiv.png")]
		private static var Button28:Class;
		
		//[Embed(source="../../images/buttons/ButPlayCom.png")]
		//private static var Button29:Class;
		//[Embed(source="../../images/buttons/ButPlayComActiv.png")]
		//private static var Button30:Class;
		
		//[Embed(source="../../images/buttons/ButLevelSelectCom.png")]
		//private static var Button31:Class;
		//[Embed(source="../../images/buttons/ButLevelSelectComActiv.png")]
		//private static var Button32:Class;
		
		[Embed(source="../../images/buttons/ButLS.png")]
		private static var Button33:Class;
		[Embed(source="../../images/buttons/ButLSActiv.png")]
		private static var Button34:Class;
		
		[Embed(source="../../images/buttons/ButBay.png")]
		private static var Button35:Class;
		[Embed(source="../../images/buttons/ButBayActiv.png")]
		private static var Button36:Class;
		//
		//[Embed(source="../../images/buttons/ButtonMap.png")]
		//private static var Button37:Class;
		//[Embed(source="../../images/buttons/ButtonMapActiv.png")]
		//private static var Button38:Class;
		//
		//[Embed(source="../../images/buttons/ButFinal.png")]
		//private static var Button39:Class;
		//[Embed(source="../../images/buttons/ButFinalActiv.png")]
		//private static var Button40:Class;
		//[Embed(source="../../images/buttons/ButFinalIdol.png")]
		//private static var Button41:Class;
		//[Embed(source="../../images/buttons/ButFinalIdolActiv.png")]
		//private static var Button42:Class;
		
		[Embed(source="../../images/buttons/sponsor/ButtonDownload.png")]
		private static var Button43:Class;
		[Embed(source="../../images/buttons/sponsor/ButtonDownloadActiv.png")]
		private static var Button44:Class;
		
		[Embed(source="../../images/buttons/sponsor/ButtonHighscores.png")]
		private static var Button45:Class;
		[Embed(source="../../images/buttons/sponsor/ButtonHighscoresActiv.png")]
		private static var Button46:Class;
		
		[Embed(source="../../images/buttons/sponsor/ButtonSubmit.png")]
		private static var Button47:Class;
		[Embed(source="../../images/buttons/sponsor/ButtonSubmitActiv.png")]
		private static var Button48:Class;
		
		[Embed(source="../../images/buttons/sponsor/ButtonVopros.png")]
		private static var Button49:Class;
		[Embed(source="../../images/buttons/sponsor/ButtonVoprosActiv.png")]
		private static var Button50:Class;
		
		[Embed(source="../../images/buttons/sponsor/ButtonWalktrought.png")]
		private static var Button51:Class;
		[Embed(source="../../images/buttons/sponsor/ButtonWalktroughtActiv.png")]
		private static var Button52:Class;
		
		[Embed(source="../../images/buttons/sponsor/facebookBtn0001.png")]
		private static var Button53:Class;
		[Embed(source="../../images/buttons/sponsor/facebookBtn0002.png")]
		private static var Button54:Class;
		
		[Embed(source="../../images/buttons/sponsor/twitterBtn0001.png")]
		private static var Button55:Class;
		[Embed(source="../../images/buttons/sponsor/twitterBtn0002.png")]
		private static var Button56:Class;
		
		[Embed(source="../../images/buttons/Button-Music-On.png")]
		private static var Button57:Class;
		[Embed(source="../../images/buttons/Button-Music-On-Activ.png")]
		private static var Button58:Class;
		[Embed(source="../../images/buttons/Button-Music-Off.png")]
		private static var Button59:Class;
		[Embed(source="../../images/buttons/Button-Music-Off-Activ.png")]
		private static var Button60:Class;
		
		[Embed(source="../../images/buttons/ButOptions.png")]
		private static var Button61:Class;
		[Embed(source="../../images/buttons/ButOptionsActiv.png")]
		private static var Button62:Class;
		
		[Embed(source="../../images/buttons/ButStrelkaLeft.png")]
		private static var Button63:Class;
		[Embed(source="../../images/buttons/ButStrelkaLeftActiv.png")]
		private static var Button64:Class;
		[Embed(source="../../images/buttons/ButStrelkaRight.png")]
		private static var Button65:Class;
		[Embed(source="../../images/buttons/ButStrelkaRightActiv.png")]
		private static var Button66:Class;

		//---------------------------------------------------------
	
		//achievements
		public static const A_ACCIDENTAL_DEATH:int = 0;     
		public static const A_FIRST_BLOOD:int = 1;         
		public static const A_LUCKY:int = 2;               
		public static const A_DODGER:int = 3;              
		public static const A_ACROBAT:int = 4;             
		                                                   
		public static const A_CHECK_BOTTOM:int = 5;        
		public static const A_MINER:int = 6;               
		public static const A_AVOID_A_TRAP:int = 7;        
		public static const A_MY_PRECIOUS:int = 8;         
		public static const A_FEED_A_PET:int = 9;          
		                                                   
		public static const A_PROSPECTOR:int = 10;         
		public static const A_LOVER_SHARP:int = 11;        
		public static const A_FIGHTER:int = 12;            
		public static const A_CRAZY_DIGGER:int = 13;       
		public static const A_ENTRAP:int = 14;             
		                                                   
		public static const A_QUICK_SOLUTION:int = 15;     
		public static const A_USEFUL_TROLLEY:int = 16;     
		public static const A_EXPERIMENTER:int = 17;       
		public static const A_EXPERT_OF_GEARS:int = 18;    
		public static const A_REFILL:int = 19;             
		                                                   
		public static const A_COMPARE_THE_WAYS:int = 20;   
		public static const A_CRAZY_BLASTER:int = 21;      
		public static const A_BUMMER:int = 22;             
		public static const A_SCROOGE:int = 23;            
		public static const A_VICTIM:int = 24; 
		
		public static const A_SHOTFIRER:int = 25;          
		public static const A_SKILLED_DIGGER:int = 26;     
		public static const A_SPRINTER:int = 27;           
		public static const A_EQUIPPED:int = 28;           
		public static const A_COLLECTOR:int = 29;          
		
		[Embed(source="../../images/elements/alphaicons/1.png")]
		private static var AAch0:Class;
		[Embed(source="../../images/elements/alphaicons/2.png")]
		private static var AAch1:Class;
		[Embed(source="../../images/elements/alphaicons/3.png")]
		private static var AAch2:Class;
		[Embed(source="../../images/elements/alphaicons/4.png")]
		private static var AAch3:Class;
		[Embed(source="../../images/elements/alphaicons/5.png")]
		private static var AAch4:Class;
		[Embed(source="../../images/elements/alphaicons/6.png")]
		private static var AAch5:Class;
		[Embed(source="../../images/elements/alphaicons/7.png")]
		private static var AAch6:Class;
		[Embed(source="../../images/elements/alphaicons/8.png")]
		private static var AAch7:Class;
		[Embed(source="../../images/elements/alphaicons/9.png")]
		private static var AAch8:Class;
		[Embed(source="../../images/elements/alphaicons/10.png")]
		private static var AAch9:Class;
		[Embed(source="../../images/elements/alphaicons/11.png")]
		private static var AAch10:Class;
		[Embed(source="../../images/elements/alphaicons/12.png")]
		private static var AAch11:Class;
		[Embed(source="../../images/elements/alphaicons/13.png")]
		private static var AAch12:Class;
		[Embed(source="../../images/elements/alphaicons/14.png")]
		private static var AAch13:Class;
		[Embed(source="../../images/elements/alphaicons/15.png")]
		private static var AAch14:Class;
		[Embed(source="../../images/elements/alphaicons/16.png")]
		private static var AAch15:Class;
		[Embed(source="../../images/elements/alphaicons/17.png")]
		private static var AAch16:Class;
		[Embed(source="../../images/elements/alphaicons/18.png")]
		private static var AAch17:Class;
		[Embed(source="../../images/elements/alphaicons/19.png")]
		private static var AAch18:Class;
		[Embed(source="../../images/elements/alphaicons/20.png")]
		private static var AAch19:Class;
		[Embed(source="../../images/elements/alphaicons/21.png")]
		private static var AAch20:Class;
		[Embed(source="../../images/elements/alphaicons/22.png")]
		private static var AAch21:Class;
		[Embed(source="../../images/elements/alphaicons/23.png")]
		private static var AAch22:Class;
		[Embed(source="../../images/elements/alphaicons/24.png")]
		private static var AAch23:Class;
		[Embed(source="../../images/elements/alphaicons/25.png")]
		private static var AAch24:Class;
		[Embed(source="../../images/elements/alphaicons/26.png")]
		private static var AAch25:Class;
		[Embed(source="../../images/elements/alphaicons/27.png")]
		private static var AAch26:Class;
		[Embed(source="../../images/elements/alphaicons/28.png")]
		private static var AAch27:Class;
		[Embed(source="../../images/elements/alphaicons/29.png")]
		private static var AAch28:Class;
		[Embed(source="../../images/elements/alphaicons/30.png")]
		private static var AAch29:Class;

		
		static public var backgrounds:Vector.<BitmapData> = new Vector.<BitmapData>();
		static public var tileBodies:Vector.<Vector.<BitmapData>> = new Vector.<Vector.<BitmapData>>(117);
		static public var tileImages:Vector.<Vector.<BitmapData>> = new Vector.<Vector.<BitmapData>>();
		static public var buttonImages:Vector.<BitmapData> = new Vector.<BitmapData>();
		static public var elementImages:Vector.<BitmapData> = new Vector.<BitmapData>();
		static public var achAlphaImages:Vector.<BitmapData> = new Vector.<BitmapData>();
		static public var tooltips:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		public function ImageRes()
		{
		
		}
		
		public static function initPreloader():void
		{
		
		}
		
		public static function init():void
		{
			tooltips[0] = (new Hint0() as Bitmap).bitmapData;
			tooltips[1] = (new Hint1() as Bitmap).bitmapData;
			tooltips[2] = (new Hint2() as Bitmap).bitmapData;
			tooltips[3] = (new Hint3() as Bitmap).bitmapData;
			tooltips[4] = (new Hint4() as Bitmap).bitmapData;
			tooltips[5] = (new Hint5() as Bitmap).bitmapData;
			tooltips[6] = (new Hint6() as Bitmap).bitmapData;
			tooltips[7] = (new Hint7() as Bitmap).bitmapData;
			tooltips[8] = (new Hint8() as Bitmap).bitmapData;
			tooltips[9] = (new Hint9() as Bitmap).bitmapData;
			tooltips[10] = (new Hint10() as Bitmap).bitmapData;
			tooltips[11] = (new Hint11() as Bitmap).bitmapData;
			tooltips[12] = (new Hint12() as Bitmap).bitmapData;
			tooltips[13] = (new Hint13() as Bitmap).bitmapData;
			
			for (var j:int = 1; j < tileBodies.length; j++)
			{
				tileBodies[j] = new Vector.<BitmapData>();
			}
			
			tileBodies[1].push((new Asset1() as Bitmap).bitmapData);
			tileBodies[2].push((new Asset2() as Bitmap).bitmapData);
			tileBodies[3].push((new Asset3() as Bitmap).bitmapData);
			tileBodies[4].push((new Asset4_0() as Bitmap).bitmapData);
			tileBodies[4].push((new Asset4_1() as Bitmap).bitmapData);
			tileBodies[4].push((new Asset4_2() as Bitmap).bitmapData);
			tileBodies[4].push((new Asset4_3() as Bitmap).bitmapData);
			tileBodies[4].push((new Asset4_4() as Bitmap).bitmapData);
			tileBodies[4].push((new Asset4_5() as Bitmap).bitmapData);
			tileBodies[5].push((new Asset5() as Bitmap).bitmapData);
			tileBodies[6].push((new Asset6_0() as Bitmap).bitmapData);
			tileBodies[6].push((new Asset6_1() as Bitmap).bitmapData);
			tileBodies[7].push((new Asset7() as Bitmap).bitmapData);
			tileBodies[8].push((new Asset8() as Bitmap).bitmapData);
			tileBodies[9].push((new Asset9() as Bitmap).bitmapData);
			tileBodies[10].push((new Asset10() as Bitmap).bitmapData);
			tileBodies[11].push((new Asset11() as Bitmap).bitmapData);
			tileBodies[12].push((new Asset12() as Bitmap).bitmapData);
			tileBodies[13].push((new Asset13() as Bitmap).bitmapData);
			tileBodies[14].push((new Asset14() as Bitmap).bitmapData);
			tileBodies[20].push((new Asset20() as Bitmap).bitmapData);
			tileBodies[21].push((new Asset21_0() as Bitmap).bitmapData);
			tileBodies[21].push((new Asset21_1() as Bitmap).bitmapData);
			tileBodies[21].push((new Asset21_2() as Bitmap).bitmapData);
			tileBodies[21].push((new Asset21_3() as Bitmap).bitmapData);
			tileBodies[22].push((new Asset22_0() as Bitmap).bitmapData);
			tileBodies[22].push((new Asset22_1() as Bitmap).bitmapData);
			tileBodies[22].push((new Asset22_2() as Bitmap).bitmapData);
			tileBodies[23].push((new Asset23() as Bitmap).bitmapData);
			tileBodies[30].push((new Asset30() as Bitmap).bitmapData);
			tileBodies[31].push((new Asset31() as Bitmap).bitmapData);
			tileBodies[32].push((new Asset32() as Bitmap).bitmapData);
			tileBodies[40].push((new Asset40() as Bitmap).bitmapData);
			tileBodies[41].push((new Asset41() as Bitmap).bitmapData);
			tileBodies[42].push((new Asset42() as Bitmap).bitmapData);
			tileBodies[50].push((new Asset50() as Bitmap).bitmapData);
			tileBodies[51].push((new Asset51() as Bitmap).bitmapData);
			tileBodies[52].push((new Asset52() as Bitmap).bitmapData);
			tileBodies[53].push((new Asset53() as Bitmap).bitmapData);
			tileBodies[54].push((new Asset54() as Bitmap).bitmapData);
			tileBodies[55].push((new Asset55() as Bitmap).bitmapData);
			tileBodies[56].push((new Asset56() as Bitmap).bitmapData);
			tileBodies[57].push((new Asset57() as Bitmap).bitmapData);
			tileBodies[58].push((new Asset58() as Bitmap).bitmapData);
			tileBodies[59].push((new Asset59() as Bitmap).bitmapData);
			tileBodies[60].push((new Asset60() as Bitmap).bitmapData);
			tileBodies[61].push((new Asset61() as Bitmap).bitmapData);
			tileBodies[62].push((new Asset62() as Bitmap).bitmapData);
			tileBodies[63].push((new Asset63() as Bitmap).bitmapData);
			tileBodies[65].push((new Asset65() as Bitmap).bitmapData);
			tileBodies[66].push((new Asset66() as Bitmap).bitmapData);
			tileBodies[67].push((new Asset67() as Bitmap).bitmapData);
			tileBodies[68].push((new Asset68() as Bitmap).bitmapData);
			tileBodies[69].push((new Asset69() as Bitmap).bitmapData);
			tileBodies[70].push((new Asset70() as Bitmap).bitmapData);
			tileBodies[71].push((new Asset71() as Bitmap).bitmapData);
			tileBodies[72].push((new Asset72() as Bitmap).bitmapData);
			tileBodies[73].push((new Asset73() as Bitmap).bitmapData);
			tileBodies[74].push((new Asset74() as Bitmap).bitmapData);
			tileBodies[75].push((new Asset75() as Bitmap).bitmapData);
			tileBodies[76].push((new Asset76() as Bitmap).bitmapData);
			tileBodies[77].push((new Asset77() as Bitmap).bitmapData);
			tileBodies[78].push((new Asset78() as Bitmap).bitmapData);
			tileBodies[79].push((new Asset79() as Bitmap).bitmapData);
			tileBodies[80].push((new Asset80() as Bitmap).bitmapData);
			tileBodies[81].push((new Asset81() as Bitmap).bitmapData);
			tileBodies[82].push((new Asset82() as Bitmap).bitmapData);
			tileBodies[83].push((new Asset83() as Bitmap).bitmapData);
			tileBodies[84].push((new Asset84() as Bitmap).bitmapData);
			tileBodies[85].push((new Asset85() as Bitmap).bitmapData);
			tileBodies[86].push((new Asset86() as Bitmap).bitmapData);
			tileBodies[101].push((new Asset101_0() as Bitmap).bitmapData);
			tileBodies[101].push((new Asset101_1() as Bitmap).bitmapData);
			tileBodies[101].push((new Asset101_2() as Bitmap).bitmapData);
			tileBodies[101].push((new Asset101_3() as Bitmap).bitmapData);
			tileBodies[101].push((new Asset101_4() as Bitmap).bitmapData);
			tileBodies[101].push((new Asset101_5() as Bitmap).bitmapData);
			tileBodies[101].push((new Asset101_6() as Bitmap).bitmapData);
			tileBodies[101].push((new Asset101_7() as Bitmap).bitmapData);
			tileBodies[101].push((new Asset101_8() as Bitmap).bitmapData);
			tileBodies[102].push((new Asset102() as Bitmap).bitmapData);
			tileBodies[103].push((new Asset103() as Bitmap).bitmapData);
			tileBodies[104].push((new Asset104() as Bitmap).bitmapData);
			tileBodies[105].push((new Asset105() as Bitmap).bitmapData);
			tileBodies[106].push((new Asset106() as Bitmap).bitmapData);
			tileBodies[107].push((new Asset107() as Bitmap).bitmapData);
			tileBodies[108].push((new Asset108() as Bitmap).bitmapData);
			tileBodies[109].push((new Asset109() as Bitmap).bitmapData);
			tileBodies[110].push((new Asset110() as Bitmap).bitmapData);
			tileBodies[111].push((new Asset111() as Bitmap).bitmapData);
			tileBodies[112].push((new Asset112() as Bitmap).bitmapData);
			tileBodies[113].push((new Asset113() as Bitmap).bitmapData);
			tileBodies[114].push((new Asset114() as Bitmap).bitmapData);
			tileBodies[115].push((new Asset115() as Bitmap).bitmapData);
			tileBodies[116].push((new Asset116() as Bitmap).bitmapData);
			
			tileImages[0] = new Vector.<BitmapData>();
			tileImages[1] = new Vector.<BitmapData>();
			tileImages[2] = new Vector.<BitmapData>();
			tileImages[3] = new Vector.<BitmapData>();
			tileImages[4] = new Vector.<BitmapData>();
			tileImages[5] = new Vector.<BitmapData>();
			tileImages[6] = new Vector.<BitmapData>();
			
			tileImages[0].push((new GraphicTile0() as Bitmap).bitmapData);
			tileImages[1].push((new GraphicTile1_0() as Bitmap).bitmapData);
			//tileImages[1].push((new GraphicTile1_1() as Bitmap).bitmapData);
			tileImages[2].push((new GraphicTile2_0() as Bitmap).bitmapData);
			//tileImages[2].push((new GraphicTile2_1() as Bitmap).bitmapData);
			tileImages[3].push((new GraphicTile3_0() as Bitmap).bitmapData);
			//tileImages[3].push((new GraphicTile3_1() as Bitmap).bitmapData);
			tileImages[4].push((new GraphicTile4() as Bitmap).bitmapData);
			//tileImages[5].push((new GraphicTile5() as Bitmap).bitmapData);
			//tileImages[6].push((new GraphicTile6() as Bitmap).bitmapData);
			
			elementImages[0] = (new Element0() as Bitmap).bitmapData;
			elementImages[1] = (new Element1() as Bitmap).bitmapData;
			elementImages[2] = (new Element2() as Bitmap).bitmapData;
			elementImages[3] = (new Element3() as Bitmap).bitmapData;
			elementImages[4] = (new Element4() as Bitmap).bitmapData;
			elementImages[5] = (new Element5() as Bitmap).bitmapData;
			elementImages[6] = (new Element6() as Bitmap).bitmapData;
			elementImages[7] = (new Element7() as Bitmap).bitmapData;
			elementImages[8] = (new Element8() as Bitmap).bitmapData;
			elementImages[9] = (new Element9() as Bitmap).bitmapData;
			elementImages[10] = (new Element10() as Bitmap).bitmapData;
			elementImages[11] = (new Element11() as Bitmap).bitmapData;
			elementImages[12] = (new Element12() as Bitmap).bitmapData;
			elementImages[13] = (new Element13() as Bitmap).bitmapData;
			elementImages[14] = (new Element14() as Bitmap).bitmapData;
			elementImages[15] = (new Element15() as Bitmap).bitmapData;
			elementImages[16] = (new Element16() as Bitmap).bitmapData;
			elementImages[17] = (new Element17() as Bitmap).bitmapData;
			elementImages[18] = elementImages[17];
			elementImages[19] = (new Element19() as Bitmap).bitmapData;
			elementImages[20] = (new Element20() as Bitmap).bitmapData;
			elementImages[21] = (new Element21() as Bitmap).bitmapData;
			elementImages[22] = (new Element22() as Bitmap).bitmapData;
			elementImages[23] = (new Element23() as Bitmap).bitmapData;
			elementImages[24] = (new Element24() as Bitmap).bitmapData;
			elementImages[25] = (new Element25() as Bitmap).bitmapData;
			elementImages[26] = (new Element26() as Bitmap).bitmapData;
			elementImages[27] = (new Element27() as Bitmap).bitmapData;
			elementImages[28] = (new Element28() as Bitmap).bitmapData;
			elementImages[29] = (new Element29() as Bitmap).bitmapData;
			elementImages[30] = (new Element30() as Bitmap).bitmapData;
			elementImages[31] = (new Element31() as Bitmap).bitmapData;
			elementImages[32] = (new Element32() as Bitmap).bitmapData;
			elementImages[33] = (new Element33() as Bitmap).bitmapData;
			elementImages[34] = (new Element34() as Bitmap).bitmapData;
			elementImages[35] = (new Element35() as Bitmap).bitmapData;
			elementImages[36] = (new Element36() as Bitmap).bitmapData;
			elementImages[37] = null;//(new Element37() as Bitmap).bitmapData;
			elementImages[38] = null;//(new Element38() as Bitmap).bitmapData;
			elementImages[39] = null;//(new Element39() as Bitmap).bitmapData;
			elementImages[40] = null;//(new Element40() as Bitmap).bitmapData;
			elementImages[41] = null;//(new Element41() as Bitmap).bitmapData;
			elementImages[42] = (new Element42() as Bitmap).bitmapData;//intro eyes
			elementImages[43] = (new Element43() as Bitmap).bitmapData;
			elementImages[44] = (new Element44() as Bitmap).bitmapData;
			elementImages[45] = (new Element45() as Bitmap).bitmapData;
			elementImages[46] = (new Element46() as Bitmap).bitmapData;
			elementImages[47] = (new Element47() as Bitmap).bitmapData;
			elementImages[48] = (new Element48() as Bitmap).bitmapData;
			elementImages[49] = (new Element49() as Bitmap).bitmapData;
			elementImages[50] = (new Element50() as Bitmap).bitmapData;
			elementImages[51] = (new Element51() as Bitmap).bitmapData;
			elementImages[52] = (new Element52() as Bitmap).bitmapData;
			elementImages[53] = (new Element53() as Bitmap).bitmapData;
			elementImages[54] = (new Element54() as Bitmap).bitmapData;
			elementImages[55] = (new Element55() as Bitmap).bitmapData;
			elementImages[56] = (new Element56() as Bitmap).bitmapData;
			elementImages[57] = (new Element57() as Bitmap).bitmapData;
			elementImages[58] = (new Element58() as Bitmap).bitmapData;
			elementImages[59] = (new Element59() as Bitmap).bitmapData;
			elementImages[60] = (new Element60() as Bitmap).bitmapData;
			elementImages[61] = (new Element61() as Bitmap).bitmapData;
			elementImages[62] = (new Element62() as Bitmap).bitmapData;
			elementImages[63] = (new Element63() as Bitmap).bitmapData;
			elementImages[64] = (new Element64() as Bitmap).bitmapData;
			elementImages[65] = (new Element65() as Bitmap).bitmapData;
			elementImages[66] = (new Element66() as Bitmap).bitmapData;
			elementImages[67] = (new Element67() as Bitmap).bitmapData;
			elementImages[68] = (new Element68() as Bitmap).bitmapData;
			elementImages[69] = (new Element69() as Bitmap).bitmapData;
			elementImages[70] = (new Element70() as Bitmap).bitmapData;
			elementImages[71] = (new Element71() as Bitmap).bitmapData;
			
			buttonImages[0] = (new Button0() as Bitmap).bitmapData;
			buttonImages[1] = (new Button1() as Bitmap).bitmapData;
			buttonImages[2] = (new Button2() as Bitmap).bitmapData;
			buttonImages[3] = (new Button3() as Bitmap).bitmapData;
			buttonImages[4] = (new Button4() as Bitmap).bitmapData;
			buttonImages[5] = (new Button5() as Bitmap).bitmapData;
			buttonImages[6] = (new Button6() as Bitmap).bitmapData;
			buttonImages[7] = (new Button7() as Bitmap).bitmapData;
			buttonImages[8] = (new Button8() as Bitmap).bitmapData;
			buttonImages[9] = (new Button9() as Bitmap).bitmapData;
			buttonImages[10] = null;//(new Button10() as Bitmap).bitmapData;
			if (PreloaderRes.preloaderImages[4])
			{
				buttonImages[11] = PreloaderRes.preloaderImages[4];
				buttonImages[12] = PreloaderRes.preloaderImages[5];
			}
			else
			{
				ColorShortcuts.init();
				DisplayShortcuts.init();
				buttonImages[11] = (new PreloaderRes.ResPlayNormal() as Bitmap).bitmapData;
				buttonImages[12] = (new PreloaderRes.ResPlayHover() as Bitmap).bitmapData;
			}
			buttonImages[13] = (new Button13() as Bitmap).bitmapData;
			buttonImages[14] = (new Button14() as Bitmap).bitmapData;
			buttonImages[15] = (new Button15() as Bitmap).bitmapData;
			buttonImages[16] = (new Button16() as Bitmap).bitmapData;
			buttonImages[17] = null;// (new Button17() as Bitmap).bitmapData;
			buttonImages[18] = null;// (new Button18() as Bitmap).bitmapData;
			buttonImages[19] = (new Button19() as Bitmap).bitmapData;
			buttonImages[20] = (new Button20() as Bitmap).bitmapData;
			buttonImages[21] = (new Button21() as Bitmap).bitmapData;
			buttonImages[22] = (new Button22() as Bitmap).bitmapData;
			buttonImages[23] = (new Button23() as Bitmap).bitmapData;
			buttonImages[24] = (new Button24() as Bitmap).bitmapData;
			buttonImages[25] = (new Button25() as Bitmap).bitmapData;
			buttonImages[26] = (new Button26() as Bitmap).bitmapData;
			buttonImages[27] = (new Button27() as Bitmap).bitmapData;
			buttonImages[28] = (new Button28() as Bitmap).bitmapData;
			buttonImages[29] = null;//(new Button29() as Bitmap).bitmapData;
			buttonImages[30] = null;//(new Button30() as Bitmap).bitmapData;
			buttonImages[31] = null;//(new Button31() as Bitmap).bitmapData;
			buttonImages[32] = null;//(new Button32() as Bitmap).bitmapData;
			buttonImages[33] = (new Button33() as Bitmap).bitmapData;
			buttonImages[34] = (new Button34() as Bitmap).bitmapData;
			buttonImages[35] = (new Button35() as Bitmap).bitmapData;
			buttonImages[36] = (new Button36() as Bitmap).bitmapData;
			buttonImages[37] = null;//(new Button37() as Bitmap).bitmapData;
			buttonImages[38] = null;//(new Button38() as Bitmap).bitmapData;
			buttonImages[39] = null;//(new Button39() as Bitmap).bitmapData;
			buttonImages[40] = null;//(new Button40() as Bitmap).bitmapData;
			buttonImages[41] = null;//(new Button41() as Bitmap).bitmapData;
			buttonImages[42] = null;//(new Button42() as Bitmap).bitmapData;
			buttonImages[43] = (new Button43() as Bitmap).bitmapData;
			buttonImages[44] = (new Button44() as Bitmap).bitmapData;
			buttonImages[45] = (new Button45() as Bitmap).bitmapData;
			buttonImages[46] = (new Button46() as Bitmap).bitmapData;
			buttonImages[47] = (new Button47() as Bitmap).bitmapData;
			buttonImages[48] = (new Button48() as Bitmap).bitmapData;
			buttonImages[49] = (new Button49() as Bitmap).bitmapData;
			buttonImages[50] = (new Button50() as Bitmap).bitmapData;
			buttonImages[51] = (new Button51() as Bitmap).bitmapData;
			buttonImages[52] = (new Button52() as Bitmap).bitmapData;
			buttonImages[53] = (new Button53() as Bitmap).bitmapData;
			buttonImages[54] = (new Button54() as Bitmap).bitmapData;
			buttonImages[55] = (new Button55() as Bitmap).bitmapData;
			buttonImages[56] = (new Button56() as Bitmap).bitmapData;
			buttonImages[57] = (new Button57() as Bitmap).bitmapData;
			buttonImages[58] = (new Button58() as Bitmap).bitmapData;
			buttonImages[59] = (new Button59() as Bitmap).bitmapData;
			buttonImages[60] = (new Button60() as Bitmap).bitmapData;
			buttonImages[61] = (new Button61() as Bitmap).bitmapData;
			buttonImages[62] = (new Button62() as Bitmap).bitmapData;
			buttonImages[63] = (new Button63() as Bitmap).bitmapData;
			buttonImages[64] = (new Button64() as Bitmap).bitmapData;
			buttonImages[65] = (new Button65() as Bitmap).bitmapData;
			buttonImages[66] = (new Button66() as Bitmap).bitmapData;
			              
			var bg:Sprite = new BgResources() as Sprite;
			var len:int = bg.numChildren;
			for (var i:int = 0; i < len; i++)
			{
				backgrounds[i] = (bg.getChildAt(i) as Bitmap).bitmapData;
			}
			
			achAlphaImages[0] = (new AAch0() as Bitmap).bitmapData;
			achAlphaImages[1] = (new AAch1() as Bitmap).bitmapData;
			achAlphaImages[2] = (new AAch2() as Bitmap).bitmapData;
			achAlphaImages[3] = (new AAch3() as Bitmap).bitmapData;
			achAlphaImages[4] = (new AAch4() as Bitmap).bitmapData;
			achAlphaImages[5] = (new AAch5() as Bitmap).bitmapData;
			achAlphaImages[6] = (new AAch6() as Bitmap).bitmapData;
			achAlphaImages[7] = (new AAch7() as Bitmap).bitmapData;
			achAlphaImages[8] = (new AAch8() as Bitmap).bitmapData;
			achAlphaImages[9] = (new AAch9() as Bitmap).bitmapData;
			achAlphaImages[10] = (new AAch10() as Bitmap).bitmapData;
			achAlphaImages[11] = (new AAch11() as Bitmap).bitmapData;
			achAlphaImages[12] = (new AAch12() as Bitmap).bitmapData;
			achAlphaImages[13] = (new AAch13() as Bitmap).bitmapData;
			achAlphaImages[14] = (new AAch14() as Bitmap).bitmapData;
			achAlphaImages[15] = (new AAch15() as Bitmap).bitmapData;
			achAlphaImages[16] = (new AAch16() as Bitmap).bitmapData;
			achAlphaImages[17] = (new AAch17() as Bitmap).bitmapData;
			achAlphaImages[18] = (new AAch18() as Bitmap).bitmapData;
			achAlphaImages[19] = (new AAch19() as Bitmap).bitmapData;
			achAlphaImages[20] = (new AAch20() as Bitmap).bitmapData;
			achAlphaImages[21] = (new AAch21() as Bitmap).bitmapData;
			achAlphaImages[22] = (new AAch22() as Bitmap).bitmapData;
			achAlphaImages[23] = (new AAch23() as Bitmap).bitmapData;
			achAlphaImages[24] = (new AAch24() as Bitmap).bitmapData;
			achAlphaImages[25] = (new AAch25() as Bitmap).bitmapData;
			achAlphaImages[26] = (new AAch26() as Bitmap).bitmapData;
			achAlphaImages[27] = (new AAch27() as Bitmap).bitmapData;
			achAlphaImages[28] = (new AAch28() as Bitmap).bitmapData;
			achAlphaImages[29] = (new AAch29() as Bitmap).bitmapData;
		}
		
		public static function getTileBody(type:int):BitmapData
		{
			const percent:Number = RandUtils.getInt(0, 100);
			
			var index:int = 0;
			var curPercent:Number;
			if (type < percentTiles.length)
				curPercent = percentTiles[type][index];
			else
				curPercent = 100;
				
				
			while (percent > curPercent)
			{
				index++;
				curPercent += percentTiles[type][index];
			}
			//trace("int1",type,index)
			//trace("int2",percentTiles[type][index])
			
			return tileBodies[type][index];
		}
		
		public static function getTileImage(type:int, currentIndex:int = -1):Array
		{
			const percent:Number = RandUtils.getInt(0, 100);
			var index:int = 0;
			var curPercent:Number = percentImagesTile[type][index];
			while (percent > curPercent)
			{
				index++;
				curPercent += percentImagesTile[type][index];
			}
			//if (currentIndex == 0 && index == 0)
				//index = 1;
			//else if (currentIndex == 1 && index == 1)
				index = 0;
			
			return [tileImages[type][index], index];
		}
	}

}