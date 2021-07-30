package data
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import utils.Base64;
	import utils.Functions;
	import utils.Scores;
	import view.hints.Tooltip;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Branding
	{
		//[Embed(source="../../swf/FG_adslot_between-v1_2_3.swf", mimeType="application/octet-stream")]
		//public static var Fetching:Class;
		
		public static var stage:Stage;
		public static var isShowingAds:Boolean = false;//for keyboard
		
		public static var isScoreOnlyKGorNG:Boolean = true; //block sponsor api score
		public static var isKGorNG:Boolean; //sitelock
		public static var isConnectedKGorNG:Boolean; //sitelock
		
		public function Branding()
		{
		
		}
		
		public static function mapHandler(e:MouseEvent):void
		{
			const progress:Progress = Controller.model.progress;
			var tempArray:Vector.<String> = new Vector.<String>();
			for each (var key:Boolean in progress.achievements)
			{
				tempArray.push(((key) ? '1' : '0'));
			}
			
			var str:String = "";
			str += ((progress.isGameComplete) ? '1' : '0') + "|";
			str += progress.levelsCompleted.toString() + "|";
			str += progress.currentLevel.toString() + "|";
			str += progress.starToLevels.toString() + "|";
			str += progress.allStar.toString() + "|";
			//str += progress.artToLevels.toString() + "|";
			str += tempArray.toString() + "|";
			str += progress.facebook.toString() + "|";
			str += progress.twitter.toString();
			
			str = Base64.encode(str);
			
			var http_vraag:String = stage.loaderInfo.url.substr(0, stage.loaderInfo.url.indexOf(":"));
			var deze_website:String;
			if ((http_vraag == "http"))
			{
				deze_website = stage.loaderInfo.url;
			}
			else
			{
				deze_website = "local";
			}
			
			var content_knop:String = "exclusive_content";
			var spel_naam:String = "shotfirer";
			
			//Deze string niet wijzigen
			var link:String = "http://www.funnygames.nu/redirect.html?gameid=21545&jLd83e5W=" + str;
			var onTibacoNetwork:Boolean = false;
			try
			{
				onTibacoNetwork = ExternalInterface.call("isTibaco") == true;
			}
			catch (error:Error)
			{
				trace(error);
			}
			if (!onTibacoNetwork)
			{
				link = link.concat("&utm_source=" + deze_website + "&utm_medium=flashgame&utm_term=" + spel_naam + "&utm_content=" + content_knop + "&utm_campaign=sponsored_games");
			}
			var request:URLRequest = new URLRequest(link);
			navigateToURL(request, "_blank");
		
		}
		
		public static function moreHandler(e:MouseEvent):void
		{
			var http_vraag:String = stage.loaderInfo.url.substr(0, stage.loaderInfo.url.indexOf(":"));
			var deze_website:String;
			if ((http_vraag == "http"))
			{
				deze_website = stage.loaderInfo.url;
			}
			else
			{
				deze_website = "local";
			}
			
			var content_knop:String = "more_games";
			var spel_naam:String = "shotfirer";
			
			//Deze string niet wijzigen
			var link:String = "http://www.funnygames.nu/redirect.html?gameid=21545&page=related";
			var onTibacoNetwork:Boolean = false;
			try
			{
				onTibacoNetwork = ExternalInterface.call("isTibaco") == true;
			}
			catch (error:Error)
			{
				trace(error);
			}
			if (!onTibacoNetwork)
			{
				link = link.concat("&utm_source=" + deze_website + "&utm_medium=flashgame&utm_term=" + spel_naam + "&utm_content=" + content_knop + "&utm_campaign=sponsored_games");
			}
			var request:URLRequest = new URLRequest(link);
			navigateToURL(request, "_blank");
		}
		
		public static function logoHandler(e:MouseEvent):void
		{
			var http_vraag:String = stage.loaderInfo.url.substr(0, stage.loaderInfo.url.indexOf(":"));
			var deze_website:String;
			if ((http_vraag == "http"))
			{
				deze_website = stage.loaderInfo.url;
			}
			else
			{
				deze_website = "local";
			}
			
			var content_knop:String = "logo";
			var spel_naam:String = "shotfirer";
			
			var link:String = "http://www.funnygames.nu";
			var onTibacoNetwork:Boolean = false;
			try
			{
				onTibacoNetwork = ExternalInterface.call("isTibaco") == true;
			}
			catch (error:Error)
			{
				trace(error);
			}
			if (!onTibacoNetwork)
			{
				link = link.concat("?utm_source=" + deze_website + "&utm_medium=flashgame&utm_term=" + spel_naam + "&utm_content=" + content_knop + "&utm_campaign=sponsored_games");
			}
			var request:URLRequest = new URLRequest(link);
			navigateToURL(request, "_blank");
		}
		
		public static function facebookOverHandler(e:MouseEvent):void
		{
			//Tooltip.getInstance().showTooltip("Tip, like our Facebook page and get 10 points!");
		}
		
		public static function twitterOverHandler(e:MouseEvent):void
		{
			//Tooltip.getInstance().showTooltip("Tip, follow us on Twitter and get 10 points!");
		}
		
		public static function outHandler(e:MouseEvent):void
		{
			Tooltip.getInstance().hideTooltip();
		}
		
		public static function facebookHandler(e:MouseEvent):void
		{
			Controller.model.progress.facebook = 1;
			
			var http_vraag:String = stage.loaderInfo.url.substr(0, stage.loaderInfo.url.indexOf(":"));
			var deze_website:String;
			if ((http_vraag == "http"))
			{
				deze_website = stage.loaderInfo.url;
			}
			else
			{
				deze_website = "local";
			}
			
			var content_knop:String = "facebook";
			var spel_naam:String = "shotfirer";
			
			var link:String = "http://www.funnygames.nu/redirect.html?page=facebook";
			var onTibacoNetwork:Boolean = false;
			try
			{
				onTibacoNetwork = ExternalInterface.call("isTibaco") == true;
			}
			catch (error:Error)
			{
				trace(error);
			}
			if (!onTibacoNetwork)
			{
				link = link.concat("&utm_source=" + deze_website + "&utm_medium=flashgame&utm_term=" + spel_naam + "&utm_content=" + content_knop + "&utm_campaign=sponsored_games");
			}
			var request:URLRequest = new URLRequest(link);
			navigateToURL(request, "_blank");
		}
		
		public static function twitterHandler(e:MouseEvent):void
		{
			Controller.model.progress.twitter = 1;
			
			var http_vraag:String = stage.loaderInfo.url.substr(0, stage.loaderInfo.url.indexOf(":"));
			var deze_website:String;
			if ((http_vraag == "http"))
			{
				deze_website = stage.loaderInfo.url;
			}
			else
			{
				deze_website = "local";
			}
			
			var content_knop:String = "twitter";
			var spel_naam:String = "shotfirer";
			
			var link:String = "http://www.funnygames.nu/redirect.html?page=twitter";
			var onTibacoNetwork:Boolean = false;
			try
			{
				onTibacoNetwork = ExternalInterface.call("isTibaco") == true;
			}
			catch (error:Error)
			{
				trace(error);
			}
			if (!onTibacoNetwork)
			{
				link = link.concat("&utm_source=" + deze_website + "&utm_medium=flashgame&utm_term=" + spel_naam + "&utm_content=" + content_knop + "&utm_campaign=sponsored_games");
			}
			var request:URLRequest = new URLRequest(link);
			navigateToURL(request, "_blank");
		}
		
		public static function walkHandler(e:MouseEvent):void
		{
			var http_vraag:String = stage.loaderInfo.url.substr(0, stage.loaderInfo.url.indexOf(":"));
			var deze_website:String;
			if ((http_vraag == "http"))
			{
				deze_website = stage.loaderInfo.url;
			}
			else
			{
				deze_website = "local";
			}
			
			var content_knop:String = "walkthrough";
			var spel_naam:String = "shotfirer";
			
			//Deze string niet wijzigen
			var link:String = "http://www.funnygames.nu/redirect.html?gameid=21545&page=walkthrough";
			var onTibacoNetwork:Boolean = false;
			try
			{
				onTibacoNetwork = ExternalInterface.call("isTibaco") == true;
			}
			catch (error:Error)
			{
				trace(error);
			}
			if (!onTibacoNetwork)
			{
				link = link.concat("&utm_source=" + deze_website + "&utm_medium=flashgame&utm_term=" + spel_naam + "&utm_content=" + content_knop + "&utm_campaign=sponsored_games");
			}
			var request:URLRequest = new URLRequest(link);
			navigateToURL(request, "_blank");
		}
		
		public static function submitScoreHandler(e:MouseEvent = null):void
		{
			var score:uint = Scores.getScore();
			if (score == 0)
				return;
			
			if (Functions.isUrl(["kongregate.com"]) && isConnectedKGorNG)
				ApiKG.sendScore(score);
			
			if (Functions.isUrl(["newgrounds.com", "uploads.ungrounded.net"]) && isConnectedKGorNG)
				ApiNG.sendScore(score);
			
			if (isKGorNG && isConnectedKGorNG && isScoreOnlyKGorNG)
				return;
			
			//sendScore(score, 21545, "shotfirer");
		}
		
		public static function submitAchievement(type:uint):void
		{
			if (Functions.isUrl(["kongregate.com"]) && isConnectedKGorNG)
				ApiKG.sendAchievement(type);
			
			if (Functions.isUrl(["newgrounds.com", "uploads.ungrounded.net"]) && isConnectedKGorNG)
				ApiNG.sendAchievement(type);
		}
		
		//private static function sendScore(_tws_score, gameid, gameterm):void
		//{
			//var _tws_gameid = gameid;
			//var _tws_tracking = "utm_medium=flashgame&utm_term=" + gameterm + "&utm_content=highscore&utm_campaign=sponsored_games";
			//var _tws_filler = "0123456789abcdef";
			//var _tws_session = _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//var _tws_url = "http://www.funnygames.nu/highscores/submit.html";
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += ((String(_tws_score).charAt(1).length > 0) ? String(_tws_score).charAt(1) : _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1));
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += ((String(_tws_score).charAt(6).length > 0) ? String(_tws_score).charAt(6) : _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1));
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += ((String(_tws_score).charAt(9).length > 0) ? String(_tws_score).charAt(9) : _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1));
			//_tws_session += ((String(_tws_score).charAt(8).length > 0) ? String(_tws_score).charAt(8) : _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1));
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += ((String(_tws_score).charAt(3).length > 0) ? String(_tws_score).charAt(3) : _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1));
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += ((String(_tws_score).charAt(2).length > 0) ? String(_tws_score).charAt(2) : _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1));
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += ((String(_tws_score).charAt(7).length > 0) ? String(_tws_score).charAt(7) : _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1));
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += ((String(_tws_score).charAt(0).length > 0) ? String(_tws_score).charAt(0) : _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1));
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += ((String(_tws_score).charAt(5).length > 0) ? String(_tws_score).charAt(5) : _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1));
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += ((String(_tws_score).charAt(4).length > 0) ? String(_tws_score).charAt(4) : _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1));
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//_tws_session += _tws_filler.charAt(Math.round((Math.random() * 16) + 0.5) - 1);
			//
			//var onTibacoNetwork:Boolean = false;
			//try
			//{
				//onTibacoNetwork = ExternalInterface.call("isTibaco") == true;
			//}
			//catch (error:Error)
			//{
				//trace(error);
			//}
			//if (!onTibacoNetwork)
			//{
				//flash.net.navigateToURL(new flash.net.URLRequest(_tws_url + "?length=" + String(_tws_score).length + "&score=" + _tws_score + "&session=" + _tws_session + "&gameid=" + _tws_gameid + "&" + _tws_tracking + "&utm_source=" + escape(flash.display.LoaderInfo(new flash.display.Loader().contentLoaderInfo).loaderURL)), "_blank");
			//}
			//else
			//{
				////(gameid, session, score, username);
				//ExternalInterface.call("gcom", _tws_gameid, _tws_session, _tws_score);
			//}
		//}
	}

}