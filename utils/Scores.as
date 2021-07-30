package utils
{
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Scores 
	{
		
		[Inline]
		static public function getScore():uint
		{
			var allScore:uint = 0;
			const fullGame:uint = 100;
			const art:uint = 100;
			const rubin:uint = 10;
			const achievement:uint = 10;
			const facebook:uint = 10;
			const twitter:uint = 10;
			
			allScore += Controller.model.progress.allStar * rubin;
			
			const achievements:Vector.<Boolean> = Controller.model.progress.achievements;
			for each (var ach:Boolean in achievements) 
			{
				if (ach)
					allScore += achievement;
			}
			
			allScore += Controller.model.progress.facebook * facebook;
			allScore += Controller.model.progress.twitter * twitter;
			allScore += Controller.model.progress.artToLevels.length * art;
			
			if (Controller.model.progress.isGameComplete)
				allScore += fullGame;
			
			if (allScore > 1730)
			{
				trace("incorrect score", allScore)
				allScore = 1730;
			}
			
			trace("score: ", allScore)
			return allScore;
		}
	}
	
}