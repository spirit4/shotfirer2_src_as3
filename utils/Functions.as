package utils
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.net.LocalConnection;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Functions
	{
		
		public function Functions()
		{
		
		}
		
		[Inline]
		static public function doGrayColor(obj:DisplayObject):void
		{
			obj.filters = [new ColorMatrixFilter([0.2286, 0.6094, 0.0820, 0, 0, 0.2286, 0.6094, 0.0820, 0, 0, 0.2286, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
		}
		
		[Inline]
		static public function doGrayColor2(obj:DisplayObject):void
		{
			obj.filters = [new ColorMatrixFilter([ //
				0.21, 0.21, 0.21, 0, 50, //
				0.18, 0.18, 0.18, 0, 50, //
				0.12, 0.12, 0.12, 0, 50, //
				0, 0, 0, 1, 0 //
				])]; //
		}
		
		[Inline]
		static public function getRandomInBorder(pos:Number, delta:Number):Number
		{
			return pos + Math.random() * delta * 2 - delta;
		}
		
		[Inline]
		static public function getIndexCell(localX:Number, localY:Number):int
		{
			const cellX:int = int((localX - 16) / 32);
			const cellY:int = int((localY - 16) / 32);
			
			return cellY * 24 + cellX;
			//return cellY * 19 + cellX;
		}
		
		[Inline]
		static public function getTimeGame():String
		{
			return "Время игры: " + getTimeString(int(getTimer() / 1000));
		}
	
		[Inline]
		static public function getTimeString(sec:uint):String
		{
			var daysString:String = '';
			var hoursString:String = '';
			var minutesString:String = '';
			var secondsString:String = '';
			var days:uint = 0;
			var hours:uint = 0;
			var minutes:uint = 0;
			var seconds:uint = 0;
			
			days = int(sec / (24 * 60 * 60));
			days = days > 0 ? days : 0;
			
			hours = int((sec - days * 24 * 60 * 60) / (60 * 60));
			hours = hours > 0 ? hours : 0;
			
			minutes = int((sec - days * 24 * 60 * 60 - hours * 60 * 60) / 60);
			minutes = minutes > 0 ? minutes : 0;
			
			seconds = sec - days * 24 * 60 * 60 - hours * 60 * 60 - minutes * 60;
			
			daysString = (days > 0) ? days.toString() + 'd ' : '';
			hoursString = (hours > 0) ? hours.toString() + 'h ' : '';
			minutesString = (minutes > 0) ? minutes.toString() + 'm ' : '';
			secondsString = (seconds > 0) ? seconds.toString() + 's' : '';

			
			return daysString + hoursString + minutesString + secondsString;
		}
		
		[Inline]
		static public function isUrl(urls_allowed:Array):Boolean
		{
			var localDomainLC:LocalConnection = new LocalConnection();
			var url:String = localDomainLC.domain;
			var domain_parts:Array = url.split("://");
			if (domain_parts[1])
			{
				url = domain_parts[1];
			}
			var flag:Boolean;
			
			for (var x:String in urls_allowed)
			{
				flag = true;
				
				var pos:int = url.search(urls_allowed[x]);
				var char:String;
				if (pos > 0)
					char = url.charAt(pos - 1);

				if (pos == -1)
					flag = false;

				if (pos > 0 && char != '.')
					flag = false;

				if (flag)
					return true;
			}
			return false;
		}
	}

}