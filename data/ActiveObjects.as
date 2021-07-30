package data
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	import units.ActiveBody;
	import utils.Tile;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class ActiveObjects
	{
		private var _cells:Vector.<Tile>;
		private var _map:Vector.<Vector.<uint>>;
		private var _sprite:Sprite;
		private var _space:Space;
		
		private var _usedCells:Object /*uint*/ = new Object();
		private var _presses:Vector.<Body>;
		
		public function ActiveObjects(sprite:Sprite, cells:Vector.<Tile>, jsonLevel:Array, presses:Vector.<Body>)
		{
			_sprite = sprite;
			_cells = cells;
			_presses = presses;
			
			createMapTypes(jsonLevel);
		}
		
		private function createMapTypes(jsonLevel:Array):void
		{
			const len:int = jsonLevel.length;
			
			_map = new Vector.<Vector.<uint>>(_cells.length);
			var index:uint;
			var types:Array;
			var obj:Object;
			for (var i:int = 0; i < len; i++) 
			{
				obj = jsonLevel[i];
				index = obj["index"];
				types = obj["types"] as Array;
				_map[index] = Vector.<uint>(types);
			}
		}
		
		public function createObjects(space:Space):void
		{
			_space = space;
			
			const len:int = _map.length;
			for (var i:int = 0; i < len; i++)
			{
				if (_map[i] && !_usedCells.hasOwnProperty(i) && _map[i][0] == ImageRes.STONE)
					createStone(i);
			}
		}
		
		private function createStone(i:int):void
		{
			var stoneData:Vector.<uint> = new Vector.<uint>();
			var step:uint;
			var bond:int;
			
			if (_map[i].length == 1 || (_map[i][1] < ImageRes.BOND_0 && _map[i][1] > ImageRes.BOND_3))
				bond = -1;
			else
				bond = _map[i][1];
			
			step = getStep(bond, i);
			
			for (var j:int = i; isRightStone(j, bond); j += step)
			{
				_usedCells[j] = "stone";
				stoneData.push(j);
			}
			
			createStoneBody(stoneData);
		}
		
		private function createStoneBody(stoneData:Vector.<uint>):void
		{
			var tile:Tile = _cells[stoneData[0]];
			
			var kx:int = 1;
			var ky:int = 1;
			if (stoneData.length > 1)
			{
				if (stoneData[1] - stoneData[0] == 1)
					kx = stoneData.length;
				else
					ky = stoneData.length;
			}
			
			const body:Body = new Body(BodyType.STATIC, Vec2.weak(tile.x, tile.y));
			body.shapes.add(new Polygon(Polygon.rect(0, 0, Model.SIZE * kx, Model.SIZE * ky, true), Material.steel()));
			body.space = _space;
			
			var typeImg:int = ImageRes.ROCK_0;
			if (kx > 1)
				typeImg = kx == 3 ? ImageRes.ROCK_3W_0 : ImageRes.ROCK_2W_0;
			else if (ky > 1)
				typeImg = ky == 3 ? ImageRes.ROCK_3H_0 : ImageRes.ROCK_2H_0;
			
			const container:Sprite = new Sprite();
			_sprite.addChildAt(container, 0);
			container.name = ImageRes.ROCK_0.toString();
			
			
			body.userData.view = container;
			
			var delta:Number;
			var typeMark:int = -1;
			
			container.x = tile.x - 2;
			container.y = tile.y - 2;
			
			for each (var index:uint in stoneData)
			{
				tile = _cells[index];
				tile.addObject(container, ImageRes.STONE);
				tile.staticBodies[ImageRes.STONE] = body;
				
				if (_map[index].length > 2)
				{
					typeMark = _map[index][2];
					
					if (_map[index].length > 3)
					{
						if (_map[index][3] == ImageRes.SPIKE)
							body.userData.bodyClass = createActiveBody(ActiveBody.SPIKE, index);//for achievement, only spike
						else
							createActiveBody(ActiveBody.STAIR, index);
					}
					else
						createActiveBody(ActiveBody.STONE, index, body);
				}
			}
			
			//trace("createStoneBody",typeImg,kx,ky,typeMark);
			var bitmap:Bitmap = new Bitmap(ImageRes.getTileBody(typeImg + typeMark - ImageRes.MARK_0));
			container.addChild(bitmap);
			
			//if (typeMark > -1)
			//{
				//bitmap = new Bitmap(ImageRes.getTileBody(typeMark));
				//container.addChild(bitmap);
				//delta = (Model.SIZE - bitmap.width) / 2;
				//bitmap.x = delta;
				//bitmap.y = delta;
				//
				//bitmap = new Bitmap(ImageRes.getTileBody(typeMark));
				//container.addChild(bitmap);
				//bitmap.x = delta + Model.SIZE * (kx - 1);
				//bitmap.y = delta + Model.SIZE * (ky - 1);
			//}
			
			body.cbTypes.add(Model.BODY_GROUND);
		}
		
		private function createActiveBody(type:int, index:uint, body:Body = null):ActiveBody
		{
			const activeBody:ActiveBody = new ActiveBody(type, index, _map, _cells, body);
			
			if (activeBody.type == ActiveBody.SPIKE)
				activeBody.body.space = _space;
			
			_sprite.addChild(activeBody);
			
			
			for each (var button:Body in _presses)
			{
				//trace("[createActiveBody]",button.userData.colorType, activeBody.colorType);
				if (button.userData.colorType - AnimationRes.PRESS_0 == activeBody.colorType)
					button.userData.ao.push(activeBody);
			}
			
			return activeBody;
		}
		
		private function isRightStone(i:int, bond:int):Boolean
		{
			if (i < 0 || i >= _map.length)
				return false;
			
			if (_map[i] && _map[i][0] == ImageRes.STONE)
			{
				if ((_map[i].length == 1 && bond == -1) || (_map[i].length > 1 && bond == _map[i][1]))
					return true;
			}
			return false;
		}
		
		private function getStep(bond:int, i:int):uint
		{
			if (isRightStone(i + 1, bond))
				return 1;
			
			if (isRightStone(i + Model.WIDTH, bond))
				return Model.WIDTH;
			
			return 1;
		}
		
		public function destroy():void
		{
			_cells = null;
			_sprite = null;
			_map.length = 0;
			_map = null;
			_space = null;
			_presses = null;
			_usedCells = null;
		}
	}

}