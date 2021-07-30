package data
{
	import flash.utils.Dictionary;
	import units.Crab;
	import units.Gollum;
	import units.Parrot;
	import units.Worm;
	import utils.HintToLevel;
	
	/**
	 *
	 * @author spirit2
	 */
	public class Behavior
	{
		static public var tntToLevels:Vector.<uint> = new <uint>[ //
			3, 6, 8, 5, 7, //5
			7, 6, 8, 7, 8, //10
			8, 5, 3, 2, 3, //15
			6, 5, 3, 3, 5, //20
			0, 0, 0, 0, 0, //25
			0, 3, 4, 0, 0, //30
			0, 0, 0, 0, 2, //35
			0, 5, 0, 2, 0, //40
			5, 0, 0, 0, 0, //45
		];
		
		//static public var tntToLevels:Vector.<uint> = new <uint>[ //
			//3, 6, 8, 5, 7, //5
			//7, 6, 8, 7, 6, //10
			//8, 5, 3, 2, 3, //15
			//6, 5, 3, 3, 5, //20
			//2, 1, 2, 2, 2, //25
			//5, 7, 8, 3, 5, //30
			//6, 1, 1, 6, 10, //35
			//7, 13, 5, 10, 6, //40
			//13, 7, 6, 3, 3, //45
		//];
		
		static public const RUBY_COST:int = 50;
		
		static public var coinCosts:Vector.<int> = new <int>[ //
			100, //
			200, //
			300, //
			500, //
		]; //
		
		static public var monsterCosts:Dictionary = new Dictionary();
			//50, //blue	
			//100, //crab		
			//200, //parrot
			//50, //worm
		//]; //
		
		static public var shopDescriptions:Vector.<String> = new <String>[ //
			"The additional dynamites which can be used in each level", //
			"Shows the hidden treasures underground and uses the battery for work", //
			"Allows to use the radar for the search hidden treasures", //
		]; //
		
		static public var tooltips:Vector.<Vector.<HintToLevel>>;
		
		
		
		public function Behavior()
		{
			
		}
		
		public static function init():void
		{
			tooltips = new Vector.<Vector.<HintToLevel>>(45);
			
			tooltips[0] = new Vector.<HintToLevel>();
			tooltips[0].push(new HintToLevel(40, 290, 250, 100, 80, 200, ImageRes.tooltips[ImageRes.HINT_LVL_1_1]));
			tooltips[0].push(new HintToLevel(470, 250, 170, 100, 480, 250, ImageRes.tooltips[ImageRes.HINT_LVL_1_2]));
			tooltips[0].push(new HintToLevel(320, 190, 3, 60, 245, 115, ImageRes.tooltips[ImageRes.HINT_LVL_1_3]));
			
			tooltips[1] = new Vector.<HintToLevel>();
			tooltips[1].push(new HintToLevel(190, 350, 200, 80, 230, 290, ImageRes.tooltips[ImageRes.HINT_LVL_2_1]));
			
			tooltips[2] = new Vector.<HintToLevel>();
			tooltips[2].push(new HintToLevel(80, 370, 270, 80, 130, 320, ImageRes.tooltips[ImageRes.HINT_LVL_3_1]));
			tooltips[2].push(new HintToLevel(450, 360, 120, 70, 490, 330, ImageRes.tooltips[ImageRes.HINT_LVL_3_2]));
			
			tooltips[3] = new Vector.<HintToLevel>();
			tooltips[3].push(new HintToLevel(280, 340, 150, 140, 275, 330, ImageRes.tooltips[ImageRes.HINT_LVL_4_1]));
			tooltips[3].push(new HintToLevel(490, 90, 110, 70, 320, 80, ImageRes.tooltips[ImageRes.HINT_LVL_4_2]));
			
			tooltips[6] = new Vector.<HintToLevel>();
			tooltips[6].push(new HintToLevel(440, 100, 270, 80, 400, 80, ImageRes.tooltips[ImageRes.HINT_LVL_5_1]));
			
			tooltips[9] = new Vector.<HintToLevel>();
			tooltips[9].push(new HintToLevel(360, 210, 110, 80, 0, 10, ImageRes.tooltips[ImageRes.HINT_LVL_10_1]));
			
			tooltips[11] = new Vector.<HintToLevel>();
			tooltips[11].push(new HintToLevel(380, 200, 140, 70, 280, 130, ImageRes.tooltips[ImageRes.HINT_LVL_6_1]));
			
			tooltips[13] = new Vector.<HintToLevel>();
			tooltips[13].push(new HintToLevel(90, 150, 170, 80, 95, 120, ImageRes.tooltips[ImageRes.HINT_LVL_7_1]));
			
			tooltips[15] = new Vector.<HintToLevel>();
			tooltips[15].push(new HintToLevel(80, 370, 150, 80, 22, 315, ImageRes.tooltips[ImageRes.HINT_LVL_8_1]));
			
			tooltips[18] = new Vector.<HintToLevel>();
			tooltips[18].push(new HintToLevel(520, 420, 210, 80, 485, 390, ImageRes.tooltips[ImageRes.HINT_LVL_9_1]));
			
			monsterCosts[Gollum] = 50;
			monsterCosts[Worm] = 50;
			monsterCosts[Crab] = 100;
			monsterCosts[Parrot] = 200;
		}
	}

}