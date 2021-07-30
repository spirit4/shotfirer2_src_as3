package data
{
	import com.newgrounds.*;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class ApiNG
	{
		
		public function ApiNG()
		{
		
		}
		
		static public function sendScore(score:uint):void
		{
			API.postScore("Score", score);
		}
		
		static public function sendAchievement(type:uint):void
		{
			API.unlockMedal(JSONRes.jsonAch[type].title);
		}
	}

}