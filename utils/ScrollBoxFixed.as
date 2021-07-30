package utils
{
	import caurina.transitions.Tweener;
	import data.ImageRes;
	import data.JSONRes;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class ScrollBoxFixed extends Sprite
	{
		private var _width:Number;
		private var _height:Number;
		private var _delta:Number;
		private var _innerWidth:Number;
		
		private var _container:Sprite;
		private var _left:ButtonImage;
		private var _right:ButtonImage;
		
		private var _isArrows:Boolean;
		
		public function ScrollBoxFixed(vector:Vector.<DisplayObject>, numberCols:int = 3, isArrows:Boolean = false, margin:Number = 5, numberRows:uint = 1)
		{
			_width = (vector[0].width + margin) * numberCols + margin;
			_height = (vector[0].height + margin) * numberRows + margin;
			_delta = vector[0].width * numberCols + margin * 2;
			_isArrows = isArrows;
			
			if (vector.length / numberRows <= numberCols)
				_isArrows = false;
			
			_container = new Sprite();
			addChild(_container);
			_container.mouseEnabled = false;
			
			//_container.graphics.beginFill(0xFFFFFF, 0.2);
			//_container.graphics.drawRect(0, 0, _width, _height);
			//_container.graphics.endFill();
			
			_container.scrollRect = new Rectangle(0, 0, _width, _height);
			
			if (_isArrows)
			{
				createArrows();
				_container.x = _left.width + 6;
			}
			else
				_container.x = 74;
			
			var item:DisplayObject;
			var col:int;
			var row:int;
			
			for (var i:int = 0; i < vector.length; i++)
			{
				col = i % numberCols;
				row = (i - col) / numberCols;
				item = vector[i];
				
				item.x = (((i - (i % (numberCols * numberRows))) / (numberCols * numberRows)) * numberCols + col) * (item.width + margin) + margin;
				item.y = (((i - (i % numberCols)) / numberCols) % numberRows) * (item.height + margin) + margin;
				
				//trace("sdsadwe ", (((i - (i%(numberCols * numberRows))) / (numberCols * numberRows)) * numberCols + col),(((i - (i%numberCols)) / numberCols) % numberRows), item.x, item.y);
				_container.addChild(item);
			}
			
			_innerWidth = _container.width;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			move(-1);//hide arrow
		}
		
		private function createArrows():void
		{
			var button:ButtonImage = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_LEFT], ImageRes.buttonImages[ImageRes.BUTTON_LEFT_HOVER], true);
			button.addEventListener(MouseEvent.CLICK, leftHandler);
			addChild(button);
			button.x = 2;
			button.y = (_height - button.height) / 2 + 53;
			_left = button;
			
			button = new ButtonImage(ImageRes.buttonImages[ImageRes.BUTTON_RIGHT], ImageRes.buttonImages[ImageRes.BUTTON_RIGHT_HOVER], true);
			button.addEventListener(MouseEvent.CLICK, rightHandler);
			addChild(button);
			button.x = _width + 102;
			button.y = (_height - button.height) / 2 + 53;
			_right = button;
		}
		
		private function rightHandler(e:MouseEvent):void
		{
			move(1);
		}
		
		private function leftHandler(e:MouseEvent):void
		{
			move(-1);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (_container.scrollRect)
				parent.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		
		}
		
		private function wheelHandler(e:MouseEvent):void
		{
			move(e.delta > 0 ? 1 : -1);
		}
		
		private function move(direction:Number):void
		{
			//trace("==moveFixed",_innerWidth, _width)
			if (_innerWidth < _width)
				return;
			
			var dx:Number = _container.scrollRect.x;
			dx += _delta * direction;
			
			_left.visible = true;
			_right.visible = true;
			
			if (dx < 7)
			{
				_left.visible = false;
				dx = 0;
			}
			else if (dx > _innerWidth - _width + 12)
			{
				_right.visible = false;
				dx = _innerWidth - _width + 14;
			}
			
			//trace("==dx",dx)
			Tweener.addTween(_container, {_scrollRect_x: dx, time: 0.3, transition: "easeOutQuart"});
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			parent.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
			
			_container.removeChildren();
			removeChildren();
			_container = null;
			_left = null;
			_right = null;
		}
	}

}