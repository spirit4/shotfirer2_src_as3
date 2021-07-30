package units
{
	import caurina.transitions.Tweener;
	import data.AchievementController;
	import data.ImageRes;
	import data.Model;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundChannel;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.Tile;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class ActiveBody extends Sprite
	{
		static public const SPIKE:int = 0;
		static public const STAIR:int = 1;
		static public const STONE:int = 2;
		
		private var _isActive:Boolean; //button pressed
		private var _map:Vector.<Vector.<uint>>;
		private var _cells:Vector.<Tile>;
		private var _body:Body;
		private var _type:int;
		private var _colorType:int;
		
		private var _position:Vec2;
		private var _positionActive:Vec2;
		
		private var _addingStairs:Vector.<Bitmap>;
		private var _stairDirection:int;
		private var _counterStair:int;
		private var _soundStair:SoundChannel;
		
		public function ActiveBody(type:int, index:int, map:Vector.<Vector.<uint>>, cells:Vector.<Tile>, body:Body = null)
		{
			_type = type;
			_map = map;
			_cells = cells;
			_body = body;
			
			switch (type)
			{
				case SPIKE: 
					createSpike(index);
					break;
				case STAIR: 
					createStair(index);
					break;
				case STONE: 
					createStone(index);
					break;
				default: 
					trace("ActiveBody - unkmown type");
			}
			
			_colorType = _map[index][2] - ImageRes.MARK_0;
			//trace("[ActiveBody]",_colorType, _map[index][2]);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function createSpike(index:int):void
		{
			_isActive = true;
			
			const tile:Tile = _cells[index];
			const bitmap:Bitmap = new Bitmap(ImageRes.getTileBody(_map[index][3]));
			addChild(bitmap);
			
			const dxy:Array = getPosition(index);
			const rot:uint = dxy[2];
			const pointTile:Vec2 = new Vec2(tile.x + Model.SIZE / 2, tile.y + Model.SIZE / 2);
			var point0:Vec2 = new Vec2(-0.5 * Model.SIZE + 1, -1.5 * Model.SIZE + 6);
			var point1:Vec2 = new Vec2(0.5 * Model.SIZE - 1, -0.5 * Model.SIZE);
			
			rotateVec2(point0, rot)
			rotateVec2(point1, rot)
			
			point0 = point0.add(pointTile);
			point1 = point1.add(pointTile);
			
			_body = new Body(BodyType.STATIC, point0);
			const poly:Polygon = new Polygon(Polygon.rect(0, 0, point1.x - point0.x, point1.y - point0.y), null, Model.FILTER_SPIKE);
			_body.shapes.add(poly);
			poly.material.rollingFriction = 0.5;
			
			bitmap.rotation = 90 * rot;
			var pos:Vec2 = new Vec2(-bitmap.bitmapData.width * 0.5, -0.5 * Model.SIZE - bitmap.bitmapData.height + 4);
			
			rotateVec2(pos, rot)
			pos = pos.add(pointTile);
			//SPIKE-----------------------------------------------
			this.x = pos.x;
			this.y = pos.y;
			_positionActive = pos;
			
			_position = pos.copy();
			_position.x -= Model.SIZE * dxy[0] - 5 * dxy[0];
			_position.y -= Model.SIZE * dxy[1] - 5 * dxy[1];
			
			_body.userData.view = bitmap;
			_body.userData.type = ImageRes.SPIKE;
			
			poly.cbTypes.add(Model.BODY_DANGER);
			_body.cbTypes.add(Model.BODY_SPIKE);
		}
		
		public function turnOnOff(space:Space):void
		{
			_isActive = !_isActive;
			
			var spaceBody:Space = _body.space;
			if (_isActive)
			{
				_body.space = space;
				if (_type == STAIR)
				{
					AchievementController.getInstance().addParam(AchievementController.ACTIVATE_STAIR);
					
					if (_soundStair)
						SoundManager.getInstance().stopSFX(_soundStair);
					
					_soundStair = SoundManager.getInstance().playSFX(SoundRes.SFX_STAIR_ONOFF);
					turnOnStair();
					return;
				}
				else if (_type == STONE)
				{
					SoundManager.getInstance().playSFX(SoundRes.SFX_STONE_OFF);
					_body.space = null;
					_body.position.set(_positionActive);
					_body.space = space;
				}
				else if (_type == SPIKE)
				{
					if(!SoundManager.getInstance().isThisSFX(SoundRes.SFX_SPIKE_ONOFF))
						SoundManager.getInstance().playSFX(SoundRes.SFX_SPIKE_ONOFF);
				}
				
				this.visible = true;
				Tweener.addTween(this, {x: _positionActive.x, y: _positionActive.y, time: 0.2, transition: "easeInQuad"});
			}
			else
			{
				
				_body.space = null;
				if (_type == STAIR)
				{
					if (_soundStair)
						SoundManager.getInstance().stopSFX(_soundStair);
					
					_soundStair = SoundManager.getInstance().playSFX(SoundRes.SFX_STAIR_ONOFF);
					turnOffStair();
					return;
				}
				else if (_type == STONE)
				{
					AchievementController.getInstance().addParam(AchievementController.ACTIVATE_STONE);
					
					SoundManager.getInstance().playSFX(SoundRes.SFX_STONE_ON);
					_body.position.set(_position);
					_body.space = spaceBody;
				}
				else if (_type == SPIKE)
				{
					AchievementController.getInstance().addParam(AchievementController.ACTIVATE_SPIKE);
					
					if(!SoundManager.getInstance().isThisSFX(SoundRes.SFX_SPIKE_ONOFF))
						SoundManager.getInstance().playSFX(SoundRes.SFX_SPIKE_ONOFF);
				}
				
				Tweener.addTween(this, {x: _position.x, y: _position.y, time: 0.2, transition: "easeInQuad", onComplete: hideHandler});
			}
		}
		
		private function turnOnStair():void
		{
			if (!_addingStairs)
				return;
			
			if (_counterStair == _addingStairs.length)
			{
				if (_soundStair)
					SoundManager.getInstance().stopSFX(_soundStair);
				
				return;
			}
			
			const bitmap:Bitmap = _addingStairs[_counterStair];
			bitmap.y = _body.userData.view.y + Model.SIZE * _stairDirection * _counterStair;
			const newY:Number = _body.userData.view.y + Model.SIZE * _stairDirection * (_counterStair + 1);
			
			bitmap.visible = true;
			_counterStair++;
			Tweener.addTween(bitmap, {y: newY, time: 0.1, transition: "linear", onComplete: turnOnStair});
		}
		
		private function turnOffStair():void
		{
			if (!_addingStairs)
				return;
			
			if (_counterStair < _addingStairs.length)
				_addingStairs[_counterStair].visible = false;
			
			if (_counterStair == 0)
			{
				if (_soundStair)
					SoundManager.getInstance().stopSFX(_soundStair);
				
				return;
			}
			
			const bitmap:Bitmap = _addingStairs[_counterStair - 1];
			bitmap.y = _body.userData.view.y + Model.SIZE * _stairDirection * _counterStair;
			const newY:Number = _body.userData.view.y + Model.SIZE * _stairDirection * (_counterStair - 1);
			
			_counterStair--;
			Tweener.addTween(bitmap, {y: newY, time: 0.1, transition: "linear", onComplete: turnOffStair});
		}
		
		private function hideHandler():void
		{
			if (_type == SPIKE)
				this.visible = false;
		}
		
		private function createStair(index:int):void
		{
			_isActive = false;
			
			const tile:Tile = _cells[index];
			var bitmap:Bitmap = new Bitmap(ImageRes.getTileBody(_map[index][3]));
			addChild(bitmap);
			
			const dxy:Array = getPosition(index);
			const rot:uint = dxy[2];
			const pointTile:Vec2 = new Vec2(tile.x + Model.SIZE / 2, tile.y + Model.SIZE / 2);
			var point0:Vec2 = new Vec2(-0.5 * Model.SIZE + 15, -1.5 * Model.SIZE);
			var point1:Vec2 = new Vec2(0.5 * Model.SIZE - 15, -0.5 * Model.SIZE);
			
			rotateVec2(point0, rot)
			rotateVec2(point1, rot)
			
			point0 = point0.add(pointTile);
			point1 = point1.add(pointTile);
			
			_body = new Body(BodyType.STATIC, point0);
			const poly:Polygon = new Polygon(Polygon.rect(0, 0, point1.x - point0.x, point1.y - point0.y));
			poly.sensorEnabled = true;
			_body.shapes.add(poly);
			
			_body.userData.view = bitmap;
			_body.userData.type = ImageRes.STAIRS;
			if (rot > 0)
				_body.userData.type = ImageRes.STAIRS + 100;
			
			bitmap.rotation = 90 * rot;
			var pos:Vec2 = new Vec2(-bitmap.bitmapData.width * 0.5, -0.5 * Model.SIZE - bitmap.bitmapData.height + 2);
			rotateVec2(pos, rot)
			pos = pos.add(pointTile);
			//STAIR-----------------------------------------------
			this.x = pos.x;
			this.y = pos.y;
			_position = pos;
			
			_positionActive = pos.copy();
			_positionActive.x += Model.SIZE * dxy[0];
			_positionActive.y += Model.SIZE * dxy[1];
			
			const num:uint = Math.abs(dxy[1]);
			poly.scale(1, num + 1);
			
			_addingStairs = new Vector.<Bitmap>();
			_stairDirection = dxy[1] / num;
			for (var i:int = 0; i < num; i++)
			{
				bitmap = new Bitmap(ImageRes.getTileBody(_map[index][3]));
				addChild(bitmap);
				bitmap.rotation = 90 * rot;
				bitmap.y = Model.SIZE * _stairDirection * (i + 1);
				_addingStairs.push(bitmap);
				bitmap.visible = false;
			}
			
			body.position.y = _positionActive.y;
			
			_body.cbTypes.add(Model.BODY_STAIRS);
		}
		
		private function createStone(index:int):void
		{
			_isActive = true;
			
			_cells[index].removeObject(ImageRes.STONE);
			_cells[index].addObject(this, ImageRes.STONE);
			
			this.x = _body.userData.view.x;
			this.y = _body.userData.view.y;
			
			_body.userData.view.x = 0;
			_body.userData.view.y = 0;
			
			this.addChild(_body.userData.view);
			_body.userData.view = this;
			
			const tile:Tile = _cells[index];
			const dxy:Array = getPosition(index);
			
			var pos:Vec2 = new Vec2(this.x, this.y);
			//STONE-----------------------------------------------
			this.x = pos.x;
			this.y = pos.y;
			_positionActive = pos;
			
			_position = pos.copy();
			_position.x += Model.SIZE * dxy[0];
			_position.y += Model.SIZE * dxy[1];
		}
		
		private function rotateVec2(point:Vec2, rot:uint):void
		{
			var tempX:Number;
			var tempY:Number;
			for (var i:int = 0; i < rot; i++)
			{
				tempX = point.x;
				tempY = point.y;
				point.x = -tempY;
				point.y = tempX;
			}
		}
		
		private function getPosition(index:int):Array
		{
			const typeMark:int = _map[index][2];
			var rot:uint;
			var step:int;
			var pos:Array = [0, 0, 0]; //x,y,rot
			
			if (_map[index + 1] && _map[index + 1][0] == typeMark)
			{
				rot = 1;
				step = pos[0] = 1;
			}
			else if (_map[index - 1] && _map[index - 1][0] == typeMark)
			{
				rot = 3;
				step = pos[0] = -1;
			}
			else if (index + Model.WIDTH < _map.length && _map[index + Model.WIDTH] && _map[index + Model.WIDTH][0] == typeMark)
			{
				rot = 2;
				pos[1] = 1;
				step = Model.WIDTH;
			}
			else if (index - Model.WIDTH > 0 && _map[index - Model.WIDTH] && _map[index - Model.WIDTH][0] == typeMark)
			{
				rot = 0;
				pos[1] = -1;
				step = -Model.WIDTH;
			}
			
			pos[2] = rot;
			
			var border:int = step;
			if (_type == STAIR)
				border += step;
			for (var i:int = index + step; (i + border > 0 && i + border < _map.length && _map[i + border] && _map[i + border][0] == typeMark); i += step)
			{
				if (pos[0] > 0)
					pos[0]++;
				else if (pos[0] < 0)
					pos[0]--;
				else if (pos[1] > 0)
					pos[1]++;
				else if (pos[1] < 0)
					pos[1]--;
			}
			
			return pos;
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			while (numChildren)
				removeChildAt(0);
			
			_body = null;
			_map = null;
			_cells = null;
			_position = null;
			_positionActive = null;
			
			if (_addingStairs)
			{
				_addingStairs.length = 0;
				_addingStairs = null;
			}
		}
		
		public function get body():Body
		{
			return _body;
		}
		
		public function get colorType():int
		{
			return _colorType;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function get isActive():Boolean 
		{
			return _isActive;
		}
	}

}