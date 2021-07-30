package data
{
	import com.adobe.serialization.json.JSON;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class JSONRes
	{
		
		[Embed(source="../../levels/0.json",mimeType="application/octet-stream")]
		private static var Level0:Class;
		[Embed(source="../../levels/1.json",mimeType="application/octet-stream")]
		private static var Level1:Class;
		[Embed(source="../../levels/2.json",mimeType="application/octet-stream")]
		private static var Level2:Class;
		[Embed(source="../../levels/3.json",mimeType="application/octet-stream")]
		private static var Level3:Class;
		[Embed(source="../../levels/4.json",mimeType="application/octet-stream")]
		private static var Level4:Class;
		[Embed(source="../../levels/5.json",mimeType="application/octet-stream")]
		private static var Level5:Class;
		[Embed(source="../../levels/6.json",mimeType="application/octet-stream")]
		private static var Level6:Class;
		[Embed(source="../../levels/7.json",mimeType="application/octet-stream")]
		private static var Level7:Class;
		[Embed(source="../../levels/8.json",mimeType="application/octet-stream")]
		private static var Level8:Class;
		[Embed(source="../../levels/9.json",mimeType="application/octet-stream")]
		private static var Level9:Class;
		[Embed(source="../../levels/10.json",mimeType="application/octet-stream")]
		private static var Level10:Class;
		[Embed(source="../../levels/11.json",mimeType="application/octet-stream")]
		private static var Level11:Class;
		[Embed(source="../../levels/12.json",mimeType="application/octet-stream")]
		private static var Level12:Class;
		[Embed(source="../../levels/13.json",mimeType="application/octet-stream")]
		private static var Level13:Class;
		[Embed(source="../../levels/14.json",mimeType="application/octet-stream")]
		private static var Level14:Class;
		[Embed(source="../../levels/15.json",mimeType="application/octet-stream")]
		private static var Level15:Class;
		[Embed(source="../../levels/16.json",mimeType="application/octet-stream")]
		private static var Level16:Class;
		[Embed(source="../../levels/17.json",mimeType="application/octet-stream")]
		private static var Level17:Class;
		[Embed(source="../../levels/18.json",mimeType="application/octet-stream")]
		private static var Level18:Class;
		[Embed(source="../../levels/19.json",mimeType="application/octet-stream")]
		private static var Level19:Class;
		[Embed(source="../../levels/20.json",mimeType="application/octet-stream")]
		private static var Level20:Class;
		[Embed(source="../../levels/21.json",mimeType="application/octet-stream")]
		private static var Level21:Class;
		[Embed(source="../../levels/22.json",mimeType="application/octet-stream")]
		private static var Level22:Class;
		[Embed(source="../../levels/23.json",mimeType="application/octet-stream")]
		private static var Level23:Class;
		[Embed(source="../../levels/24.json",mimeType="application/octet-stream")]
		private static var Level24:Class;
		[Embed(source="../../levels/25.json",mimeType="application/octet-stream")]
		private static var Level25:Class;
		[Embed(source="../../levels/26.json",mimeType="application/octet-stream")]
		private static var Level26:Class;
		[Embed(source="../../levels/27.json",mimeType="application/octet-stream")]
		private static var Level27:Class;
		[Embed(source="../../levels/28.json",mimeType="application/octet-stream")]
		private static var Level28:Class;
		[Embed(source="../../levels/29.json",mimeType="application/octet-stream")]
		private static var Level29:Class;
		[Embed(source="../../levels/30.json",mimeType="application/octet-stream")]
		private static var Level30:Class;
		[Embed(source="../../levels/31.json",mimeType="application/octet-stream")]
		private static var Level31:Class;
		[Embed(source="../../levels/32.json",mimeType="application/octet-stream")]
		private static var Level32:Class;
		[Embed(source="../../levels/33.json",mimeType="application/octet-stream")]
		private static var Level33:Class;
		[Embed(source="../../levels/34.json",mimeType="application/octet-stream")]
		private static var Level34:Class;
		[Embed(source="../../levels/35.json",mimeType="application/octet-stream")]
		private static var Level35:Class;
		[Embed(source="../../levels/36.json",mimeType="application/octet-stream")]
		private static var Level36:Class;
		[Embed(source="../../levels/37.json",mimeType="application/octet-stream")]
		private static var Level37:Class;
		[Embed(source="../../levels/38.json",mimeType="application/octet-stream")]
		private static var Level38:Class;
		[Embed(source="../../levels/39.json",mimeType="application/octet-stream")]
		private static var Level39:Class;
		[Embed(source="../../levels/40.json",mimeType="application/octet-stream")]
		private static var Level40:Class;
		[Embed(source="../../levels/41.json",mimeType="application/octet-stream")]
		private static var Level41:Class;
		[Embed(source="../../levels/42.json",mimeType="application/octet-stream")]
		private static var Level42:Class;
		[Embed(source="../../levels/43.json",mimeType="application/octet-stream")]
		private static var Level43:Class;
		[Embed(source="../../levels/44.json",mimeType="application/octet-stream")]
		private static var Level44:Class;
		
		[Embed(source="../../texts/achievements.json",mimeType="application/octet-stream")]
		private static var Ach:Class;
		
		static public var tileLevels:Vector.<Array> = new Vector.<Array>();
		static public var jsonAch:Array = [];
		
		static public var editingLevel:Array = [];
		
		public function JSONRes()
		{
			
		}
		
		public static function init():void
		{
			tileLevels[0] = getParseJSON(Level0);
			tileLevels[1] = getParseJSON(Level1);
			tileLevels[2] = getParseJSON(Level2);
			tileLevels[3] = getParseJSON(Level3);
			tileLevels[4] = getParseJSON(Level4);
			tileLevels[5] = getParseJSON(Level5);
			tileLevels[6] = getParseJSON(Level6);
			tileLevels[7] = getParseJSON(Level7);
			tileLevels[8] = getParseJSON(Level8);
			tileLevels[9] = getParseJSON(Level9);
			tileLevels[10] = getParseJSON(Level10);
			tileLevels[11] = getParseJSON(Level11);
			tileLevels[12] = getParseJSON(Level12);
			tileLevels[13] = getParseJSON(Level13);
			tileLevels[14] = getParseJSON(Level14);
			tileLevels[15] = getParseJSON(Level15);
			tileLevels[16] = getParseJSON(Level16);
			tileLevels[17] = getParseJSON(Level17);
			tileLevels[18] = getParseJSON(Level18);
			tileLevels[19] = getParseJSON(Level19);
			tileLevels[20] = getParseJSON(Level20);
			tileLevels[21] = getParseJSON(Level21);
			tileLevels[22] = getParseJSON(Level22);
			tileLevels[23] = getParseJSON(Level23);
			tileLevels[24] = getParseJSON(Level24);
			tileLevels[25] = getParseJSON(Level25);
			tileLevels[26] = getParseJSON(Level26);
			tileLevels[27] = getParseJSON(Level27);
			tileLevels[28] = getParseJSON(Level28);
			tileLevels[29] = getParseJSON(Level29);
			tileLevels[30] = getParseJSON(Level30);
			tileLevels[31] = getParseJSON(Level31);
			tileLevels[32] = getParseJSON(Level32);
			tileLevels[33] = getParseJSON(Level33);
			tileLevels[34] = getParseJSON(Level34);
			tileLevels[35] = getParseJSON(Level35);
			tileLevels[36] = getParseJSON(Level36);
			tileLevels[37] = getParseJSON(Level37);
			tileLevels[38] = getParseJSON(Level38);
			tileLevels[39] = getParseJSON(Level39);
			tileLevels[40] = getParseJSON(Level40);
			tileLevels[41] = getParseJSON(Level41);
			tileLevels[42] = getParseJSON(Level42);
			tileLevels[43] = getParseJSON(Level43);
			tileLevels[44] = getParseJSON(Level44);
			
			jsonAch = getParseJSON(Ach);
		}
		
		private static function getParseJSON(Embedded:Class):Array
		{
			return com.adobe.serialization.json.JSON.decode(new Embedded()) as Array;
		}
	}

}