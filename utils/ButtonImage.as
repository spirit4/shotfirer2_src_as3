package utils
{
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import sound.SoundManager;
	import sound.SoundRes;
	
	/**
	 * image:BitmapData, imageHover:BitmapData = null, isAnimation:Boolean = false
	 * @author spirit2
	 */
	public class ButtonImage extends Sprite
	{
		private var _image:BitmapData;
		private var _imageHover:BitmapData;
		private var _bitmap:Bitmap;

		private var _isDown:Boolean;
		protected var _isAnimation:Boolean;
		protected var _isClasp:Boolean;
		
		public function ButtonImage(image:BitmapData, imageHover:BitmapData = null, isAnimation:Boolean = false)
		{
			buttonMode = true;
			mouseChildren = false;
			
			_isAnimation = isAnimation;
			_image = image;
			
			_bitmap = new Bitmap(_image, "auto", _isAnimation);
			addChild(_bitmap);
			_bitmap.x = -_image.width >> 1;
			_bitmap.y = -_image.height >> 1;
			
			if (imageHover)
			{
				_imageHover = imageHover;
				addEventListener(MouseEvent.ROLL_OVER, overHandler);
				addEventListener(MouseEvent.ROLL_OUT, outHandler);
			}
			
			addEventListener(MouseEvent.CLICK, clickHandler);
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
			Tweener.addTween(_bitmap, {_brightness: 0.5, time: 0.2, transition: "easeOutQuart"});
		}
		
		protected function clickHandler(e:MouseEvent):void
		{
			SoundManager.getInstance().playSFX(SoundRes.SFX_MOUSE_CLICK);
		}
		
		protected function outHandler(e:MouseEvent = null):void
		{
			SoundManager.getInstance().playSFX(SoundRes.SFX_MOUSE_HOVER);
			Tweener.removeTweens(this);
			if (_isClasp)
				clasp();
			
			if (_isDown)
				upHandler();
			
			if (_isAnimation && !Tweener.isTweening(this))
				Tweener.addTween(this, {width: _image.width, height: _image.height, time: 0.1, transition: "easeInQuart", onComplete: changeToOut});
			else
			{
				_bitmap.bitmapData = _image;
				_bitmap.smoothing = _isAnimation;
				_bitmap.x = -_image.width >> 1;
				_bitmap.y = -_image.height >> 1;
			}
		}
		
		protected function overHandler(e:MouseEvent):void
		{
			SoundManager.getInstance().playSFX(SoundRes.SFX_MOUSE_HOVER);
			Tweener.removeTweens(this);
			
			_bitmap.bitmapData = _imageHover;
			_bitmap.smoothing = _isAnimation;
			_bitmap.width = _imageHover.width;
			_bitmap.height = _imageHover.height;
			
			if (_isAnimation && !Tweener.isTweening(this))
			{
				_bitmap.width = _image.width;
				_bitmap.height = _image.height;
				Tweener.addTween(this, {width: _imageHover.width, height: _imageHover.height, time: 0.1, transition: "easeOutQuart"});
			}
			else
			{
				_bitmap.x = -_imageHover.width >> 1;
				_bitmap.y = -_imageHover.height >> 1;
			}
		}
		
		protected function changeToOut():void
		{
			_bitmap.bitmapData = _image;
			_bitmap.smoothing = _isAnimation;
			_bitmap.width = _image.width;
			_bitmap.height = _image.height;
			_bitmap.x = -_image.width >> 1;
			_bitmap.y = -_image.height >> 1;
		}
		
		protected function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListener(MouseEvent.ROLL_OVER, overHandler);
			removeEventListener(MouseEvent.ROLL_OUT, outHandler);
			removeEventListener(MouseEvent.CLICK, clickHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			
			Tweener.removeTweens(this);
			removeChild(_bitmap);
			_image = null;
			_imageHover = null;
			_bitmap = null;
		}
		
		public function clasp():void
		{
			_isClasp = true;
			Tweener.addTween(this, { scaleX: 0.95, scaleY: 0.95, time: 0.6, transition: "easeInOutQuad", onComplete: unclasp});
			//trace(1111)
		}
		
		private function unclasp():void
		{
			Tweener.addTween(this, { scaleX: 1.05, scaleY: 1.05, time: 0.6, transition: "easeInOutQuad", onComplete: clasp});
			//trace(2222)
		}
	}

}