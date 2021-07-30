package utils
{
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * no sound
	 * @author spirit2
	 */
	public class ButtonImagePreloader extends Sprite
	{
		private var _image:BitmapData;
		private var _imageHover:BitmapData;
		private var _bitmap:Bitmap;
		
		private var _hoverX:Number;
		private var _hoverY:Number;
		private var _isDown:Boolean;
		protected var _isAnimation:Boolean;
		
		public function ButtonImagePreloader(image:BitmapData, imageHover:BitmapData = null, isAnimation:Boolean = false)
		{
			buttonMode = true;
			mouseChildren = false;
			
			_isAnimation = isAnimation;
			_image = image;
			
			_bitmap = new Bitmap(_image);
			addChild(_bitmap);
			
			if (imageHover)
			{
				_imageHover = imageHover;
				addEventListener(MouseEvent.ROLL_OVER, overHandler);
				addEventListener(MouseEvent.ROLL_OUT, outHandler);
				
				_hoverX = -(_imageHover.width - _image.width) / 2;
				_hoverY = -(_imageHover.height - _image.height) / 2;
			}
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			addEventListener(MouseEvent.MOUSE_UP, upHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		protected function upHandler(e:MouseEvent = null):void
		{
			_isDown = false;
			Tweener.addTween(_bitmap, {_brightness: 0, time: 0.2, transition: "easeInQuart"});
		}
		
		protected function downHandler(e:MouseEvent):void
		{
			_isDown = true;
			Tweener.addTween(_bitmap, {_brightness: 0.7, time: 0.2, transition: "easeOutQuart"});
		}
		
		protected function outHandler(e:MouseEvent = null):void
		{
			if (_isDown)
				upHandler();
			
			if (_isAnimation)
				Tweener.addTween(_bitmap, {x: 0, y: 0, width: _image.width, height: _image.height, time: 0.1, transition: "easeInQuart", onComplete: changeToOut});
			else
			{
				_bitmap.bitmapData = _image;
				_bitmap.x = _bitmap.y = 0;
			}
		}
		
		protected function overHandler(e:MouseEvent):void
		{
			_bitmap.bitmapData = _imageHover;
			
			if (_isAnimation)
			{
				_bitmap.width = _image.width;
				_bitmap.height = _image.height;
				Tweener.addTween(_bitmap, {x: _hoverX, y: _hoverY, width: _imageHover.width, height: _imageHover.height, time: 0.1, transition: "easeOutQuart"});
			}
			else
			{
				_bitmap.x = _hoverX;
				_bitmap.y = _hoverY;
			}
		}
		
		protected function changeToOut():void
		{
			_bitmap.bitmapData = _image;
			_bitmap.width = _image.width;
			_bitmap.height = _image.height;
		}
		
		protected function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListener(MouseEvent.ROLL_OVER, overHandler);
			removeEventListener(MouseEvent.ROLL_OUT, outHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			
			Tweener.removeTweens(_bitmap);
			removeChild(_bitmap);
			_image = null;
			_imageHover = null;
			_bitmap = null;
		}
	}

}