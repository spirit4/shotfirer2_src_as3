package view.hints
{
	import caurina.transitions.Tweener;
	import data.ImageRes;
	import data.Progress;
	import event.GameEvent;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.getTimer;
	import utils.TextBox;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Tooltip
	{
		private static var _instance:Tooltip;
		private static var _allowInstance:Boolean = false;
		
		private var _stage:Stage;
		private var _tip:Sprite;
		
		public function Tooltip()
		{
			if (!_allowInstance)
			{
				throw new Error("Error: Use Tooltip.getInstance() instead of the new keyword.");
			}
			init();
		}
		
		public static function getInstance():Tooltip
		{
			if (!_instance)
			{
				_allowInstance = true;
				_instance = new Tooltip();
				_allowInstance = false;
			}
			return _instance;
		}
		
		private function init():void
		{
			_tip = new Sprite;		
			_tip.visible = false;
			_tip.mouseEnabled = false;
			
			const bd:BitmapData = ImageRes.elementImages[ImageRes.EL_HELP_BG];
			_tip.graphics.beginBitmapFill(bd, null, false);
			_tip.graphics.drawRect(0, 0, bd.width, bd.height);
			_tip.graphics.endFill();
		}
		
		public function showTooltip(sprite:Sprite):void
		{
			_tip.addChild(sprite);
			_tip.visible = true;
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, dragTooltip);
			_stage.addChildAt(_tip, _stage.numChildren - 1);
		}
		
		private function dragTooltip(e:MouseEvent):void 
		{
			if (e.stageX < 400)
			{
				_tip.x = e.stageX + 40;
				_tip.y = e.stageY - 20;
			}
			else
			{
				_tip.x = e.stageX - 330;
				_tip.y = e.stageY - 90;
			}
		}
		
		public function hideTooltip():void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragTooltip);
			_tip.visible = false;
			_tip.removeChildren();
		}
		
		public function set stage(value:Stage):void
		{
			_stage = value;
		}
	
	}

}