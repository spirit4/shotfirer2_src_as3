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
	 * ...
	 * @author spirit2
	 */
	public class ButtonStateImage extends Sprite
	{
		private var _image:BitmapData;
		private var _imageHover:BitmapData;
		private var _bitmap:Bitmap;
		private var _imageStates:Vector.<BitmapData>;
		
		private var _isActive:Boolean;
		private var _isDown:Boolean;
		
		public function ButtonStateImage(image:BitmapData, image2:BitmapData, imageHover:BitmapData = null, imageHover2:BitmapData = null, isActive:Boolean = false)
		{
			buttonMode = true;
			mouseChildren = false;
			_isActive = isActive;
			
			_imageStates = new <BitmapData>[image, imageHover, image2, imageHover2];
			_image = image;
			
			if (imageHover)
			{
				_imageHover = imageHover;
				addEventListener(MouseEvent.ROLL_OVER, overHandler);
				addEventListener(MouseEvent.ROLL_OUT, outHandler);
			}
			
			_bitmap = new Bitmap(_image);
			addChild(_bitmap);
			_bitmap.x = -_image.width >> 1;
			_bitmap.y = -_image.height >> 1;
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			addEventListener(MouseEvent.MOUSE_UP, upHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			setState();
		}
		
		private function setState():void
		{
			if (_isActive)
			{
				_image = _imageStates[2];
				_imageHover = _imageStates[3];
			}
			else
			{
				_image = _imageStates[0];
				_imageHover = _imageStates[1];
			}
			
			_bitmap.bitmapData = _image;
		}
		
		private function upHandler(e:MouseEvent = null):void
		{
			_isDown = false;
			Tweener.addTween(_bitmap, {_brightness: 0, time: 0.2, transition: "easeInQuart"});
		}
		
		private function downHandler(e:MouseEvent):void
		{
			_isDown = true;
			Tweener.addTween(_bitmap, {_brightness: 0.7, time: 0.2, transition: "easeOutQuart"});
		}
		
		private function clickHandler(e:MouseEvent = null):void
		{
			SoundManager.getInstance().playSFX(SoundRes.SFX_MOUSE_CLICK);
			
			_isActive = !_isActive;
			
			setState();
			_bitmap.x = _bitmap.y = 0;
			overHandler();
		}
		
		private function outHandler(e:MouseEvent = null):void
		{
			SoundManager.getInstance().playSFX(SoundRes.SFX_MOUSE_HOVER);
			
			if (_isDown)
				upHandler();
			
			_bitmap.bitmapData = _image;
			_bitmap.x = -_image.width >> 1;
			_bitmap.y = -_image.height >> 1;
		}
		
		private function overHandler(e:MouseEvent = null):void
		{
			SoundManager.getInstance().playSFX(SoundRes.SFX_MOUSE_HOVER);
			
			_bitmap.bitmapData = _imageHover;
			_bitmap.width = _imageHover.width;
			_bitmap.height = _imageHover.height;
			_bitmap.x = -_imageHover.width >> 1;
			_bitmap.y = -_imageHover.height >> 1;
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListener(MouseEvent.ROLL_OVER, overHandler);
			removeEventListener(MouseEvent.ROLL_OUT, outHandler);
			removeEventListener(MouseEvent.CLICK, clickHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			
			Tweener.removeTweens(_bitmap);
			removeChild(_bitmap);
			_imageStates.length = 0;
			
			_imageStates = null;
			_image = null;
			_imageHover = null;
			_bitmap = null;
		}
		
		public function get isActive():Boolean
		{
			return _isActive;
		}
		
		public function set isActive(value:Boolean):void 
		{
			_isActive = value;
			setState();
		}
		
		public function clasp():void
		{
			Tweener.addTween(this, {scaleX: 0.95, scaleY: 0.95, time: 0.6, transition: "easeInOutQuad", onComplete: unclasp});
			//trace(1111)
		}
		
		private function unclasp():void
		{
			Tweener.addTween(this, {scaleX: 1.05, scaleY: 1.05, time: 0.6, transition: "easeInOutQuad", onComplete: clasp});
			//trace(2222)
		}
	}

}