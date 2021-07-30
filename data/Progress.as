package data
{
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Progress
	{
		
		public var isGameComplete:Boolean = false;
		
		/**
		 * max 30
		 */
		public var levelsCompleted:int = 45;
		public var currentLevel:int = 0;
		public var numberLevels:int = 45;
		
		public var moneyAtLevel:int = 0;
		public var totalMoney:int = 0;
		
		public var tntLevel:int = 0;
		public var radarLevel:int = 0;
		public var batteryLevel:int = 0;
		
		public var spentTime:int = 0;
		
		public var currentStar:int = 0;
		public var allStar:int = 0;
		public var maxStar:int = 45 * 3;
		
		public var currentTNT:int = 0;
		public var currentBattery:int = 0;
		
		public var tntNumber:Vector.<int> = new <int>[ //per level
			0, //
			1, //
			3, //
			5, //
			8, //
			13, //
			];//
		
		public var tntCosts:Vector.<int> = new <int>[ //
			0, //
			700, //
			2000, //
			3500, //
			5000, //
			8000, //
			];//
			
		/*
		 * inner - left, top, right, bottom
		 * outer - the same
		 */
		public var radarStates:Vector.<Vector.<int>> = new <Vector.<int>>[ //
			new <int>[0,0,0,0,0,0,0,0],
			new <int>[0,0,0,1,0,0,0,0],
			new <int>[1,0,1,1,0,0,0,0],
			new <int>[1,1,1,1,0,0,0,1],
			new <int>[1,1,1,1,1,0,1,1],
			new <int>[1,1,1,1,1,1,1,1],
			];//
			
		public var radarCosts:Vector.<int> = new <int>[ //
			0, //
			500, //
			1500, //
			3500, //
			5000, //
			7500, //
			];//
			
		public var batteryNumber:Vector.<int> = new <int>[ //per level
			0, //
			3, //
			6, //
			8, //
			10, //
			13, //
			];//
			
		public var batteryCosts:Vector.<int> = new <int>[ //
			0, //
			500, //
			1500, //
			3500, //
			5000, //
			7500, //
			];//
		
		public var starToLevels:Vector.<int> = new <int>[ //
			0, //
			0, //
			0, //
			0, //
			0, //5
			0, //
			0, //
			0, //
			0, //
			0, //10
			0, //
			0, //
			0, //
			0, //
			0, //15
			0, //
			0, //
			0, //
			0, //
			0, //20
			0, //
			0, //
			0, //
			0, //
			0, //25
			0, //
			0, //
			0, //
			0, //
			0, //30
			0, //
			0, //
			0, //
			0, //
			0, //35
			0, //
			0, //
			0, //
			0, //
			0, //40
			0, //
			0, //
			0, //
			0, //
			0, //45
			]; //
		
		public var achievements:Vector.<int> = new <int>[ //
			0, //
			0, //
			0, //
			0, //
			0, //5
			0, //
			0, //
			0, //
			0, //
			0, //10
			0, //
			0, //
			0, //
			0, //
			0, //15
			0, //
			0, //
			0, //
			0, //
			0, //20
			0, //
			0, //
			0, //
			0, //
			0, //25
			0, //
			0, //
			0, //
			0, //
			0, //30
			]; //
		
		//{level: [exit1, exit2]}
		public var exits:Object/*Array*/ = new Object();
		
		public var facebook:int = 0;	
		public var twitter:int = 0;	
			
		public function Progress()
		{
		
		}
	
	}

}