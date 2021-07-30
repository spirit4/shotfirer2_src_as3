package utils
{
	import data.ImageRes;
	import data.Model;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import nape.phys.Body;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Tile
	{
		private var _staticBodies:Vector.<Body> = new Vector.<Body>(101); //0 - NONE
		private var _objects:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		private var _imgObjects:Vector.<DisplayObject> = new Vector.<DisplayObject>(4); //top,right,bottom,left
		private var _typesObjects:Vector.<uint> = new Vector.<uint>(); // one object for one type
		
		private var _decor:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		private var _top:int = -1;
		private var _right:int = -1;
		private var _bottom:int = -1;
		private var _left:int = -1;
		
		private var _x:uint;
		private var _y:uint;
		private var _index:uint;
		
		public function Tile(x:uint, y:uint, index:uint)
		{
			_index = index;
			_x = x;
			_y = y;
			//trace(x,y,index)
		}
		
		public function addDecor(type:int, container:DisplayObjectContainer):void
		{
			if (type == ImageRes.DECOR_GRASS && _right < 0 && _left < 0)
				return;
			
			
			
			const bitmap:Bitmap = new Bitmap(ImageRes.getTileBody(type));
			container.addChild(bitmap);
			bitmap.x = _x + Model.SIZE * 0.5 + Math.random() * 22 - 11 - bitmap.width * 0.5;
			bitmap.y = _y - bitmap.height - 2;
			
			_decor.push(bitmap);
			//trace("[addDecor]", _index, type, _x, _y, bitmap.height);
		}
		
		public function removeDecor():void
		{
			for each (var object:DisplayObject in _decor) 
			{
				object.parent.removeChild(object);
			}
			_decor.length = 0;
		}
		
		public function addImgObject(object:DisplayObject, type:int):void
		{
			if (type > _imgObjects.length - 1)
				trace("incorrect type img");
			
			_imgObjects[type] = object;
		}
		
		private function removeImgObject(type:int):void
		{
			if (type > _imgObjects.length - 1)
				trace("incorrect type img");
			
			_imgObjects[type].parent.removeChild(_imgObjects[type]);
			_imgObjects[type] = null;
		}
		
		public function getImgObject(type:int):DisplayObject
		{
			if (type > _imgObjects.length - 1)
				trace("incorrect type img");
			
			return _imgObjects[type];
		}
		
		public function addObject(object:DisplayObject, type:uint, index:int = -1):void
		{
			if (index == -1)
				_objects.push(object);
			else
				_objects.splice(index, 0, object);
			
			_typesObjects.push(type);
		}
		
		public function removeObject(type:uint, index:int = -1, object:DisplayObject = null):void
		{
			const k:uint = _typesObjects.indexOf(type);
			_typesObjects.splice(k, 1);
			
			if (object)
			{
				const i:uint = _objects.indexOf(object);
				_objects.splice(i, 1);
				return;
			}
			
			if (index == -1)
				_objects.pop();
			else
				_objects.splice(index, 1);
		}
		
		public function clear():void
		{
			for (var i:int = 0; i < _staticBodies.length; i++)
			{
				_staticBodies[i] = null;
			}
			_objects.length = 0;
			_typesObjects.length = 0;
			_imgObjects = new Vector.<DisplayObject>(4);
			_decor = new Vector.<DisplayObject>();
		}
		
		public function getObject(index:uint):DisplayObject
		{
			return _objects[index];
		}
		
		public function isContains(type:uint, object:DisplayObject = null):Boolean
		{
			if (type > 0 && _typesObjects.indexOf(type) != -1)
				return true;
			
			if (object && _objects.indexOf(object) != -1)
				return true;
			
			return false;
		}
		
		public function setNextTiles(w:int, h:int):void
		{
			_top = _index - w;
			_right = _index + 1;
			_bottom = _index + w;
			_left = _index - 1;
			
			if (_index < w)
				_top = -2;
			
			if ((_index + 1) % w == 0)
				_right = -2;
			
			if (_index > (w * h - w - 1))
				_bottom = -2;
			
			if (_index % w == 0)
				_left = -2;
		}
		
		public function get y():uint
		{
			return _y;
		}
		
		public function get x():uint
		{
			return _x;
		}
		
		public function get objects():Vector.<DisplayObject>
		{
			return _objects;
		}
		
		public function get typesObjects():Vector.<uint>
		{
			return _typesObjects;
		}
		
		public function get staticBodies():Vector.<Body>
		{
			return _staticBodies;
		}
		
		public function get left():int
		{
			return _left;
		}
		
		public function get bottom():int
		{
			return _bottom;
		}
		
		public function get right():int
		{
			return _right;
		}
		
		public function get top():int
		{
			return _top;
		}
		
		public function get imgObjects():Vector.<DisplayObject>
		{
			return _imgObjects;
		}
		
		public function get index():uint
		{
			return _index;
		}
	}

}