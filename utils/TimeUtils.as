package utils
{
	/**
	 * 
	 * @author spirit2
	 */
	public class TimeUtils
	{
		
		public static function getTimeString(sec:uint):String
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
	
	}
}