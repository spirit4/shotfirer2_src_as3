package data
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	import units.*;
	import utils.BitmapClip;
	import utils.RandUtils;
	import utils.Tile;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Level extends EventDispatcher
	{
		private static const WIDTH:int = Model.WIDTH; //number cells
		private static const HEIGHT:int = Model.HEIGHT; //number cells
		private static const SIZE:int = Model.SIZE; //one cell
		
		private var _debug:BitmapDebug;
		private var _space:Space;
		private var _model:Model;
		
		private var _hero:Hero;
		private var _boxes:Vector.<Box>;
		private var _gems:Vector.<Body>;
		private var _coins:Vector.<Body>;
		private var _arts:Vector.<Body>;
		private var _presses:Vector.<Body>;
		private var _enemies:Vector.<Enemy>;
		
		private var _progress:Progress;
		
		private var _counter:int;
		private var _counterSands:int;
		
		private var _grounds:Vector.<Tile> = new Vector.<Tile>(); //without bottom
		
		private var _cells:Vector.<Tile>;
		private var _sprite:Sprite;
		
		private var _active:ActiveObjects;
		
		public function Level(sprite:Sprite, testSprite:Sprite, jsonLevel:Array)
		{
			_model = Controller.model;
			
			_space = _model.space;
			_boxes = _model.boxes;
			_gems = _model.gems;
			_coins = _model.coins;
			_arts = _model.arts;
			_presses = _model.presses;
			_enemies = _model.enemies;
			_cells = _model.cells;
			_progress = _model.progress;
			
			_sprite = sprite;
			_active = new ActiveObjects(sprite, _cells, jsonLevel, _presses);
			
			loadLevel(sprite, testSprite, jsonLevel);
		}
		
		private function loadLevel(sprite:Sprite, testSprite:Sprite, jsonLevel:Array):void
		{
			//const time0:uint = getTimer();
			//const time1:uint = getTimer();
			//trace("time1=", time1-time0)
			
			createSpace(testSprite);
			createWalls(sprite);
			
			//const time2:uint = getTimer();
			//trace("time2=", time2-time1)
			
			var index:uint;
			var types:Array;
			for each (var obj:Object in jsonLevel)
			{
				index = uint(obj.index);
				
				types = obj.types as Array;
				
				for each (var type:uint in types)
				{
					switch (type)
					{
						case ImageRes.PRESS_0: 
						case ImageRes.PRESS_1: 
						case ImageRes.PRESS_2: 
							createPress(sprite, index, type)
							break;
						case ImageRes.WEB_0: 
						case ImageRes.WEB_1: 
						case ImageRes.WEB_2: 
						case ImageRes.WEB_3: 
						case ImageRes.WEB_4: 
						case ImageRes.WEB_5: 
						case ImageRes.ICICLE_0: 
						case ImageRes.ICICLE_1: 
						case ImageRes.ICICLE_2: 
						case ImageRes.ICICLE_3: 
						case ImageRes.ICICLE_4: 
						case ImageRes.SPLIT_0: 
						case ImageRes.SPLIT_1: 
						case ImageRes.SPLIT_2: 
						case ImageRes.SPLIT_3: 
						case ImageRes.SPLIT_4: 
						case ImageRes.SPLIT_5: 
						case ImageRes.SPLIT_CROSS_0: 
						case ImageRes.SPLIT_CROSS_1: 
						case ImageRes.SPLIT_CROSS_2: 
						case ImageRes.SPLIT_CROSS_3: 
						case ImageRes.HOLE_0: 
						case ImageRes.HOLE_1: 
						case ImageRes.HOLE_2: 
							createStaticImage(sprite, index, type)
							break;
						case ImageRes.TORCH: 
							createTorches(sprite, index);
							break;
						case ImageRes.TROLLEY: 
							createTrolleys(sprite, index)
							break;
						case ImageRes.EXIT: 
							createExit(sprite, index)
							break;
						case ImageRes.GEM: 
							createGem(sprite, index)
							break;
						case ImageRes.COIN_0: 
						case ImageRes.COIN_1: 
						case ImageRes.COIN_2: 
						case ImageRes.COIN_3: 
							createCoin(sprite, index, type)
							break;
						case ImageRes.CASE_TNT: 
							createTNTCase(sprite, index)
							break;
						case ImageRes.CASE_BATTERY: 
							createBatteryCase(sprite, index)
							break;
						case ImageRes.LOGO_BODY: 
							createLogoBody(sprite, index)
							break;
						case ImageRes.ARTEFACT: 
						case ImageRes.IDOL: 
							createArts(sprite, index, type)
							break;
						case ImageRes.SPIKE: 
							if (types.length == 1)
								createSpike(sprite, index)
							break;
						case ImageRes.GROUND: 
							createGround(sprite, index)
							break;
						case ImageRes.ROCK: 
							createRock(sprite, index)
							break;
						case ImageRes.STONE: 
						case ImageRes.BOND_0: 
						case ImageRes.BOND_1: 
						case ImageRes.BOND_2: 
						case ImageRes.BOND_3: 
						case ImageRes.MARK_0: 
						case ImageRes.MARK_1: 
						case ImageRes.MARK_2:
							
							break;
						case ImageRes.STAIRS: 
							if (types.length == 1)
								createStairs(sprite, index)
							break;
						case ImageRes.HERO: 
							createHero(sprite, index)
							break;
						case ImageRes.GOLLUM: 
						case ImageRes.PARROT: 
						case ImageRes.CRAB: 
						case ImageRes.WORM: 
							createEnemy(sprite, index, type, types)
							break;
						case ImageRes.BOX_TNT: 
							createBoxTNT(sprite, index)
							break;
						default: 
							trace("other type", type)
					}
				}
			}
			
			//const time3:uint = getTimer();
			//trace("time3=", time3-time2)
			
			_active.createObjects(_space);
			
			//const time4:uint = getTimer();
			//trace("time4=", time4-time3)
			
			createTileImages();
			createDecor();
			doBoxesUpGems();
			doPressesUp();
			doStonesUp();
			doEnemiesUp();
			
			//const time5:uint = getTimer();
			//trace("time5=", time5-time4)
			
			Controller.juggler.addCall(doInNextFrame, 2 / 60);
		}
		
		private function doInNextFrame():void
		{
			Controller.juggler.removeCall(doInNextFrame);
			//trace("disp1")
			dispatchEvent(new Event(Event.INIT));
		}
		
		private function createTNTCase(sprite:Sprite, index:uint):void
		{
			const bitmap:BitmapClip = new BitmapClip(new <uint>[AnimationRes.CASE_TNT], new <Array>[null], new Rectangle(0, 0, 32, 32), 30);
			bitmap.play(AnimationRes.CASE_TNT);
			//bitmap.stop();
			sprite.addChild(bitmap);
			
			const tile:Tile = _cells[index];
			const body:Body = new Body(BodyType.STATIC, Vec2.weak(tile.x + 2, tile.y + 2));
			const poly:Polygon = new Polygon(Polygon.rect(0, 0, 28, 30, true));
			poly.sensorEnabled = true;
			body.shapes.add(poly);
			body.space = _space;
			
			bitmap.x = tile.x + 2;
			bitmap.y = tile.y;
			
			body.userData.view = bitmap;
			body.userData.type = ImageRes.CASE_TNT;
			
			body.cbTypes.add(Model.BODY_TNT_CASE);
		}
		
		private function createBatteryCase(sprite:Sprite, index:uint):void
		{
			const bitmap:BitmapClip = new BitmapClip(new <uint>[AnimationRes.CASE_BATTERY], new <Array>[null], new Rectangle(0, 0, 32, 32), 30);
			bitmap.play(AnimationRes.CASE_BATTERY);
			//bitmap.stop();
			sprite.addChild(bitmap);
			
			const tile:Tile = _cells[index];
			const body:Body = new Body(BodyType.STATIC, Vec2.weak(tile.x + 6, tile.y + 2));
			const poly:Polygon = new Polygon(Polygon.rect(0, 0, 20, 30, true));
			poly.sensorEnabled = true;
			body.shapes.add(poly);
			body.space = _space;
			
			bitmap.x = tile.x;
			bitmap.y = tile.y;
			
			body.userData.view = bitmap;
			body.userData.type = ImageRes.CASE_BATTERY;
			
			body.cbTypes.add(Model.BODY_BATTERY_CASE);
		}
		
		private function createLogoBody(sprite:Sprite, index:uint):void
		{
			const bitmap:Bitmap = new Bitmap(ImageRes.getTileBody(ImageRes.LOGO_BODY));
			//bitmap.stop();
			sprite.addChild(bitmap);
			
			const tile:Tile = _cells[index];
			const body:Body = new Body(BodyType.STATIC, Vec2.weak(tile.x + 3, tile.y + 3));
			const poly:Polygon = new Polygon(Polygon.rect(0, 0, 26, 26, true));
			poly.sensorEnabled = true;
			body.shapes.add(poly);
			body.space = _space;
			
			bitmap.x = tile.x + 3;
			bitmap.y = tile.y + 3;
			bitmap.visible = false; //CoinController
			
			body.userData.view = bitmap;
			body.userData.type = ImageRes.LOGO_BODY;
			
			body.cbTypes.add(Model.BODY_LOGO);
		}
		
		private function createPress(sprite:Sprite, index:uint, type:uint):void
		{
			const innerType:int = AnimationRes.PRESS_0 - ImageRes.PRESS_0 + type;
			const bitmap:BitmapClip = new BitmapClip(new <uint>[innerType], new <Array>[null], new Rectangle(0, 0, 48, 48), 45);
			bitmap.play(innerType);
			bitmap.stop();
			sprite.addChild(bitmap);
			
			const tile:Tile = _cells[index];
			const body:Body = new Body(BodyType.STATIC, Vec2.weak(tile.x + SIZE / 2, tile.y + SIZE / 2));
			const poly:Polygon = new Polygon(Polygon.rect(-SIZE / 2, -SIZE / 2, SIZE, SIZE, true), Material.steel());
			const sensor:Polygon = new Polygon(Polygon.rect(-10, -20, 20, 6, true));
			poly.material.rollingFriction = 0.02;
			body.shapes.add(poly);
			body.shapes.add(sensor);
			sensor.sensorEnabled = true;
			body.space = _space;
			
			bitmap.x = tile.x - 7;
			bitmap.y = tile.y - 9;
			
			body.userData.type = type;
			body.userData.view = bitmap;
			//trace("[createPress]",innerType, type);
			body.userData.colorType = innerType;
			body.userData.counter = 0;
			body.userData.ao = [];
			_presses.push(body);
			
			tile.staticBodies[type] = body;
			tile.addObject(bitmap, type);
			
			body.cbTypes.add(Model.BODY_GROUND);
			sensor.cbTypes.add(Model.BODY_PRESS);
		}
		
		private function createTorches(sprite:Sprite, index:uint):void
		{
			const bitmap:BitmapClip = new BitmapClip(new <uint>[AnimationRes.TORCH], new <Array>[null], new Rectangle(0, 0, 80, 80));
			bitmap.play(AnimationRes.TORCH);
			sprite.addChild(bitmap);
			//Controller.juggler.add(bitmap);
			
			const tile:Tile = _cells[index];
			bitmap.x = tile.x - 40;
			bitmap.y = tile.y - 40;
		}
		
		private function createStaticImage(sprite:Sprite, index:uint, type:uint):void
		{
			const bitmap:Bitmap = new Bitmap(ImageRes.getTileBody(type));
			sprite.addChild(bitmap);
			
			const tile:Tile = _cells[index];
			bitmap.x = tile.x;
			bitmap.y = tile.y;
		}
		
		private function createSpike(sprite:Sprite, index:uint):void
		{
			const bitmap:Bitmap = new Bitmap(ImageRes.getTileBody(ImageRes.SPIKE));
			sprite.addChild(bitmap);
			
			const tile:Tile = _cells[index];
			const body:Body = new Body(BodyType.STATIC, Vec2.weak(tile.x + 2, tile.y + 10));
			const poly:Polygon = new Polygon(Polygon.rect(0, 0, 28, 22, true), null, Model.FILTER_SPIKE);
			poly.material.rollingFriction = 0.5;
			
			body.shapes.add(poly);
			body.space = _space;
			
			bitmap.x = tile.x - (bitmap.bitmapData.width - Model.SIZE) / 2;
			bitmap.y = tile.y + Model.SIZE - bitmap.bitmapData.height;
			
			tile.staticBodies[ImageRes.SPIKE] = body;
			tile.addObject(bitmap, ImageRes.SPIKE);
			body.userData.view = bitmap;
			body.userData.type = ImageRes.SPIKE;
			
			poly.cbTypes.add(Model.BODY_DANGER);
			body.cbTypes.add(Model.BODY_SPIKE);
		}
		
		private function createEnemy(sprite:Sprite, index:uint, type:int, array:Array):void
		{
			const tile:Tile = _cells[index];
			
			var isRight:Boolean;
			var enemy:Enemy;
			
			if (array.length > 1)
				isRight = true;
			
			switch (type)
			{
				case ImageRes.GOLLUM: 
					enemy = new Gollum(isRight);
					break;
				case ImageRes.PARROT: 
					enemy = new Parrot(isRight);
					break;
				case ImageRes.CRAB: 
					enemy = new Crab(isRight);
					break;
				case ImageRes.WORM: 
					enemy = new Worm();
					break;
			}
			
			enemy.body.position.setxy(tile.x + SIZE / 2, tile.y + SIZE - 15);
			enemy.body.space = _space;
			enemy.body.userData.type = type;
			
			sprite.addChild(enemy);
			_enemies.push(enemy);
		}
		
		private function createArts(sprite:Sprite, index:uint, type:uint):void
		{
			//if (_progress.artToLevels.indexOf(_progress.currentLevel) != -1)
			//return;
			
			var rect:Rectangle = new Rectangle(0, 0, 32, 32);
			var animType:int = AnimationRes.ARTIFACT;
			if (type == ImageRes.IDOL)
			{
				animType = AnimationRes.IDOL;
				rect = new Rectangle(0, 0, 32, 64);
			}
			
			const bitmap:BitmapClip = new BitmapClip(new <uint>[animType], new <Array>[null], rect);
			bitmap.play(animType);
			bitmap.stop();
			sprite.addChild(bitmap);
			
			const tile:Tile = _cells[index];
			const body:Body = new Body(BodyType.STATIC, Vec2.weak(tile.x + 2, tile.y + 2));
			const poly:Polygon = new Polygon(Polygon.rect(0, 0, 28, 28, true));
			poly.sensorEnabled = true;
			body.shapes.add(poly);
			body.space = _space;
			
			bitmap.x = tile.x;
			bitmap.y = tile.y;
			
			if (type == ImageRes.IDOL)
			{
				bitmap.x += 1;
				bitmap.y -= 34;
			}
			
			body.userData.type = type;
			body.userData.view = bitmap;
			_arts.push(body);
			
			body.cbTypes.add(Model.BODY_ARTEFACT);
			if (type == ImageRes.IDOL)
				body.cbTypes.add(Model.BODY_IDOL);
		}
		
		private function createGem(sprite:Sprite, index:uint):void
		{
			const bitmap:BitmapClip = new BitmapClip(new <uint>[AnimationRes.GEM], new <Array>[null], new Rectangle(0, 0, 32, 32));
			bitmap.play(AnimationRes.GEM);
			bitmap.stop();
			sprite.addChild(bitmap);
			
			const tile:Tile = _cells[index];
			const body:Body = new Body(BodyType.STATIC, Vec2.weak(tile.x + 5, tile.y + 14));
			const poly:Polygon = new Polygon(Polygon.rect(0, 0, 22, 17, true));
			poly.sensorEnabled = true;
			body.shapes.add(poly);
			body.space = _space;
			
			bitmap.x = tile.x;
			bitmap.y = tile.y + 4;
			
			body.userData.type = ImageRes.GEM;
			body.userData.view = bitmap;
			_gems.push(body);
			
			body.cbTypes.add(Model.BODY_GEM);
			
			if (tile.isContains(ImageRes.GROUND))
			{
				const groundRubin:Bitmap = new Bitmap(ImageRes.getTileImage(ImageRes.RUBIN_GROUND)[0]);
				sprite.addChildAt(groundRubin, sprite.numChildren - 1);
				
				groundRubin.x = tile.x;
				groundRubin.y = tile.y;
				
				sprite.removeChild(tile.objects[0]);
				tile.removeObject(ImageRes.GROUND)
				tile.addObject(groundRubin, ImageRes.GROUND);
			}
		}
		
		private function createCoin(sprite:Sprite, index:uint, type:int):void
		{
			const coinType:int = (type - ImageRes.COIN_0) * 2 + AnimationRes.COINS_0;
			const bitmap:BitmapClip = new BitmapClip(new <uint>[coinType], new <Array>[null], new Rectangle(0, 0, 32, 32));
			bitmap.play(coinType);
			bitmap.stop();
			sprite.addChild(bitmap);
			
			const tile:Tile = _cells[index];
			const body:Body = new Body(BodyType.STATIC, Vec2.weak(tile.x + 5, tile.y + 7));
			const poly:Polygon = new Polygon(Polygon.rect(0, 0, 22, 18, true));
			poly.sensorEnabled = true;
			body.shapes.add(poly);
			body.space = _space;
			
			bitmap.x = tile.x;
			bitmap.y = tile.y + 4;
			bitmap.visible = false;
			
			body.userData.type = type;
			body.userData.view = bitmap;
			_coins.push(body);
			
			body.cbTypes.add(Model.BODY_COIN);
		}
		
		private function createExit(sprite:Sprite, index:uint):void
		{
			//trace("exit before", _progress.exits[_progress.currentLevel.toString()]);
			
			if (!_progress.exits[_progress.currentLevel.toString()])
				_progress.exits[_progress.currentLevel.toString()] = [];
			
			//trace("exit after",_progress.exits[_progress.currentLevel.toString()]);
			
			const tile:Tile = _cells[index];
			const body:Body = new Body(BodyType.STATIC, Vec2.weak(tile.x + SIZE / 2 - 5, tile.y));
			const poly:Polygon = new Polygon(Polygon.rect(0, 0, 10, SIZE, true));
			poly.sensorEnabled = true;
			body.shapes.add(poly);
			body.space = _space;
			
			const bitmap:Bitmap = new Bitmap(ImageRes.getTileBody(ImageRes.EXIT));
			sprite.addChildAt(bitmap, 0);
			
			bitmap.x = tile.x - (bitmap.width - SIZE) / 2;
			bitmap.y = tile.y + SIZE - bitmap.height + 3;
			
			tile.staticBodies[ImageRes.EXIT] = body;
			tile.addObject(bitmap, ImageRes.EXIT);
			body.userData.view = bitmap;
			
			body.userData.type = ImageRes.EXIT;
			body.userData.index = index;
			
			body.cbTypes.add(Model.BODY_EXIT);
		}
		
		private function createHero(sprite:Sprite, index:uint):void
		{
			const heroSize:int = 10;
			const tile:Tile = _cells[index];
			
			var top:Body = new Body();
			const material:Material = Material.ice();
			material.elasticity = 0;
			material.density = 3;
			const poly:Polygon = new Polygon(Polygon.rect(1, 0, heroSize * 2 - 2, heroSize * 4 - 3), material, Model.FILTER_HERO);
			top.shapes.add(poly);
			top.space = _space;
			top.allowRotation = false;
			
			const polyCenter:Polygon = new Polygon(Polygon.rect(3, 2, 14, 40, true), null, Model.FILTER_HERO);
			polyCenter.sensorEnabled = true;
			polyCenter.material.density = 0;
			top.shapes.add(polyCenter);
			
			const polyTop:Polygon = new Polygon(Polygon.rect(5, 9, heroSize, 4, true), null, Model.FILTER_HERO);
			polyTop.sensorEnabled = true;
			top.shapes.add(polyTop);
			
			const polyBottom:Polygon = new Polygon(Polygon.rect(5, SIZE + 15, heroSize, 4, true), null, Model.FILTER_HERO);
			polyBottom.sensorEnabled = true;
			top.shapes.add(polyBottom);
			
			const polyRight:Polygon = new Polygon(Polygon.rect(heroSize * 2, heroSize * 2, 4, heroSize * 2 - 4, true), null, Model.FILTER_HERO);
			polyRight.sensorEnabled = true;
			top.shapes.add(polyRight);
			polyRight.userData.direction = 1;
			
			const polyLeft:Polygon = new Polygon(Polygon.rect(-4, heroSize * 2, 4, heroSize * 2 - 4, true), null, Model.FILTER_HERO);
			polyLeft.sensorEnabled = true;
			top.shapes.add(polyLeft);
			polyLeft.userData.direction = -1;
			
			var base:Body = new Body();
			base.space = _space;
			base.position.setxy(tile.x + SIZE, tile.y + SIZE - heroSize);
			top.position.setxy(tile.x + SIZE - heroSize, base.position.y - heroSize * 4 + 3);
			
			var circle:Circle = new Circle(heroSize, null, Material.rubber(), Model.FILTER_HERO);
			circle.material.staticFriction = 0;
			circle.material.rollingFriction = 0.5;
			circle.material.dynamicFriction = 0.3;
			circle.material.elasticity = 0;
			circle.material.density = 5;
			circle.body = base;
			
			var lineJoint:PivotJoint = new PivotJoint(base, top, Vec2.weak(0, 0), Vec2.weak(10, heroSize * 4 - 3));
			lineJoint.ignore = true;
			lineJoint.space = _space;
			lineJoint.stiff = true;
			
			_hero = new Hero(top, base, poly, circle, polyTop, polyBottom);
			sprite.addChild(_hero);
			
			polyTop.cbTypes.add(Model.BODY_HERO_TOP);
			poly.cbTypes.add(Model.BODY_HERO);
			circle.cbTypes.add(Model.BODY_HERO_BASE);
			polyLeft.cbTypes.add(Model.BODY_HERO_SIDE);
			polyRight.cbTypes.add(Model.BODY_HERO_SIDE);
			polyBottom.cbTypes.add(Model.BODY_HERO_BOTTOM);
			polyCenter.cbTypes.add(Model.BODY_HERO_CENTER);
			
			base.cbTypes.add(Model.BODY_HERO_ALL);
			top.cbTypes.add(Model.BODY_HERO_ALL);
			
			polyTop.cbTypes.add(Model.BODY_HERO_SHAPE_ALL);
			poly.cbTypes.add(Model.BODY_HERO_SHAPE_ALL);
			circle.cbTypes.add(Model.BODY_HERO_SHAPE_ALL);
			polyLeft.cbTypes.add(Model.BODY_HERO_SHAPE_ALL);
			polyRight.cbTypes.add(Model.BODY_HERO_SHAPE_ALL);
			polyBottom.cbTypes.add(Model.BODY_HERO_SHAPE_ALL);
		}
		
		private function createBoxTNT(sprite:Sprite, index:uint):void
		{
			const tile:Tile = _cells[index];
			const body:Body = new Body(BodyType.DYNAMIC, Vec2.weak(tile.x + SIZE / 2, tile.y + 15));
			const poly:Polygon = new Polygon(Polygon.rect(-SIZE / 2 + 2, -SIZE / 2 + 0, SIZE - 4, 31, true), Material.steel(), Model.FILTER_BOX);
			const sensor:Polygon = new Polygon(Polygon.rect(-10, 13, 20, 6, true));
			const circle:Circle = new Circle(15.5, null, Material.ice(), Model.FILTER_BOX);
			sensor.sensorEnabled = true;
			body.shapes.add(poly);
			body.shapes.add(sensor);
			body.shapes.add(circle);
			circle.material.density = 10;
			poly.material.density = 10;
			poly.material.dynamicFriction = 1;
			circle.material.dynamicFriction = 1;
			poly.material.staticFriction = 0.4;
			circle.material.staticFriction = 0.4;
			body.allowRotation = false;
			body.space = _space;
			
			const bitmap:Bitmap = new Bitmap(ImageRes.getTileBody(ImageRes.BOX_TNT));
			
			body.userData.view = bitmap;
			
			const boxTNT:BoxTNT = new BoxTNT(body, sensor, _boxes, _enemies, sprite, _cells, createNextToGroundImage);
			body.userData.bodyClass = boxTNT;
			body.userData.type = ImageRes.BOX_TNT;
			body.userData.index = index;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			_boxes.push(boxTNT);
			
			sprite.addChild(boxTNT);
			boxTNT.addChild(bitmap);
			
			boxTNT.x = body.position.x - SIZE / 2 - 1;
			boxTNT.y = body.position.y - SIZE / 2 - 1;
			
			sensor.cbTypes.add(Model.BODY_TNT_BOX);
			body.cbTypes.add(Model.BODY_BOX);
		}
		
		private function createTrolleys(sprite:Sprite, index:uint):void
		{
			const tile:Tile = _cells[index];
			const body:Body = new Body(BodyType.DYNAMIC, Vec2.weak(tile.x + SIZE / 2 + 12, tile.y + 30));
			const poly:Polygon = new Polygon(Polygon.rect(-SIZE / 2 + 2, -SIZE / 2 - 1, SIZE - 4, 26, true), Material.steel(), Model.FILTER_BOX);
			const sensor:Polygon = new Polygon(Polygon.rect(-10, 13, 20, 6, true));
			
			poly.material.density = 20;
			poly.material.dynamicFriction = 1;
			poly.material.staticFriction = 0.4;
			poly.material.elasticity = 0;
			body.allowRotation = false;
			body.space = _space;
			
			sensor.sensorEnabled = true;
			body.shapes.add(poly);
			body.shapes.add(sensor);
			
			var circle:Circle;
			var wheel:Body;
			var lineJoint:PivotJoint;
			var bitmap:Bitmap;
			
			//left wheel
			wheel = new Body();
			wheel.space = _space;
			wheel.position.setxy(tile.x + 1, tile.y);
			
			circle = new Circle(5, null, Material.steel(), Model.FILTER_BOX);
			//trace("left", circle.material.elasticity,circle.material.density,circle.material.staticFriction,circle.material.rollingFriction,circle.material.dynamicFriction);
			circle.material.staticFriction = 30;
			circle.material.rollingFriction = 30;
			circle.material.dynamicFriction = 30;
			circle.material.elasticity = 0;
			circle.material.density = 80;
			circle.body = wheel;
			
			lineJoint = new PivotJoint(wheel, body, Vec2.weak(0, 0), Vec2.weak(-10, 9));
			lineJoint.ignore = true;
			lineJoint.space = _space;
			lineJoint.stiff = true;
			
			var bitmapLeftWheel:Sprite = new Sprite();
			bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_TROLLEY_WHEEL], "auto", true);
			bitmapLeftWheel.addChild(bitmap);
			body.userData.wheelLeftView = bitmapLeftWheel;
			body.userData.wheelLeft = wheel;
			bitmap.x = -bitmap.width * 0.5;
			bitmap.y = -bitmap.height * 0.5;
			bitmapLeftWheel.x = 8;
			bitmapLeftWheel.y = 26;
			
			//right wheel
			wheel = new Body();
			wheel.space = _space;
			wheel.position.setxy(tile.x + 1, tile.y);
			
			circle = new Circle(5, null, Material.steel(), Model.FILTER_BOX);
			//trace("right", circle.material.elasticity,circle.material.density,circle.material.staticFriction,circle.material.rollingFriction,circle.material.dynamicFriction);
			circle.material.staticFriction = 30;
			circle.material.rollingFriction = 30;
			circle.material.dynamicFriction = 30;
			circle.material.elasticity = 0;
			circle.material.density = 80;
			circle.body = wheel;
			
			lineJoint = new PivotJoint(wheel, body, Vec2.weak(0, 0), Vec2.weak(10, 9));
			lineJoint.ignore = true;
			lineJoint.space = _space;
			lineJoint.stiff = true;
			
			var bitmapRightWheel:Sprite = new Sprite();
			
			bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_TROLLEY_WHEEL], "auto", true);
			bitmapRightWheel.addChild(bitmap);
			body.userData.wheelRightView = bitmapRightWheel;
			body.userData.wheelRight = wheel;
			bitmap.x = -bitmap.width * 0.5;
			bitmap.y = -bitmap.height * 0.5;
			//trace("rigrrrrht",bitmap.x,bitmap.y, bitmapRightWheel.width, bitmapRightWheel.height)
			bitmapRightWheel.x = 23;
			bitmapRightWheel.y = 26;
			
			bitmap = new Bitmap(ImageRes.getTileBody(ImageRes.TROLLEY));
			body.userData.view = bitmap;
			bitmap.y = -1;
			
			body.userData.type = ImageRes.TROLLEY;
			body.userData.buttonsArray = [];
			
			const trolley:Trolley = new Trolley(body, sensor, _boxes, sprite);
			body.userData.bodyClass = trolley;
			sprite.addChild(trolley);
			trolley.addChildAt(bitmap, 0);
			trolley.addChild(bitmapLeftWheel);
			trolley.addChild(bitmapRightWheel);
			
			_boxes.push(trolley);
			
			trolley.x = body.position.x - SIZE / 2 - 1;
			trolley.y = body.position.y - SIZE / 2 - 5;
			
			sensor.cbTypes.add(Model.BODY_NORMAL_BOX);
			body.cbTypes.add(Model.BODY_BOX);
		}
		
		private function createStairs(sprite:Sprite, index:uint):void
		{
			const tile:Tile = _cells[index];
			const body:Body = new Body(BodyType.STATIC, Vec2.weak(tile.x + 15, tile.y));
			const poly:Polygon = new Polygon(Polygon.rect(0, 0, 2, SIZE, true));
			poly.sensorEnabled = true;
			body.shapes.add(poly);
			body.space = _space;
			
			const bitmap:Bitmap = new Bitmap(ImageRes.getTileBody(ImageRes.STAIRS));
			sprite.addChildAt(bitmap, 0);
			
			body.userData.view = bitmap;
			body.userData.type = ImageRes.STAIRS;
			
			bitmap.x = tile.x + SIZE / 2 - bitmap.width / 2;
			bitmap.y = tile.y + SIZE - bitmap.height + 2;
			
			body.cbTypes.add(Model.BODY_STAIRS);
			poly.cbTypes.add(Model.BODY_STAIRS);
		}
		
		private function createGround(sprite:Sprite, index:uint):void
		{
			const tile:Tile = _cells[index];
			
			var body:Body;
			var bitmap:Bitmap
			
			if (_model.poolGrounds.length > 0)
			{
				body = _model.poolGrounds.shift();
				bitmap = body.userData.view;
			}
			else
			{
				body = new Body(BodyType.STATIC);
				body.shapes.add(new Polygon(Polygon.rect(0, 0, SIZE, SIZE, true), Material.wood()));
				
				bitmap = new Bitmap(ImageRes.getTileBody(ImageRes.GROUND));
				body.userData.view = bitmap;
				
				body.userData.type = ImageRes.GROUND;
				
				body.cbTypes.add(Model.BODY_GROUND);
				body.cbTypes.add(Model.BODY_CONTAINS_DUST);
			}
			
			body.position.set(Vec2.weak(tile.x, tile.y));
			body.space = _space;
			
			sprite.addChild(bitmap);
			
			bitmap.x = tile.x;
			bitmap.y = tile.y;
			
			tile.staticBodies[ImageRes.GROUND] = body;
			tile.addObject(bitmap, ImageRes.GROUND);
		}
		
		private function createRock(sprite:Sprite, index:uint):void
		{
			const tile:Tile = _cells[index];
			
			var body:Body;
			var bitmap:Bitmap
			
			body = new Body(BodyType.STATIC);
			const material:Material = Material.steel();
			material.dynamicFriction = 0.15;
			material.staticFriction = 0.3;
			material.staticFriction = 0.003;
			body.shapes.add(new Polygon(Polygon.rect(0, 0, SIZE, SIZE, true), material));
			
			bitmap = new Bitmap(ImageRes.getTileBody(ImageRes.ROCK));
			body.userData.view = bitmap;
			
			body.userData.type = ImageRes.ROCK;
			
			body.cbTypes.add(Model.BODY_GROUND);
			
			body.position.set(Vec2.weak(tile.x, tile.y));
			body.space = _space;
			
			sprite.addChild(bitmap);
			
			bitmap.x = tile.x - (bitmap.width - Model.SIZE >> 1);
			bitmap.y = tile.y - 2;
			
			tile.staticBodies[ImageRes.ROCK] = body;
			tile.addObject(bitmap, ImageRes.ROCK);
		}
		
		private function createSpace(sprite:Sprite):void
		{
			_space = _model.space;
			
			CONFIG::debug
			{
				_debug = new BitmapDebug(SIZE * (WIDTH + 1), SIZE * (HEIGHT + 1), 0xF30066, true);
				_debug.drawConstraints = true;
				//_debug.dra = true;
				sprite.addChildAt(_debug.display, 0);
			}
		}
		
		private function createWalls(sprite:Sprite):void
		{
			_model.cacheWalls.space = _space;
		}
		
		private function doStonesUp():void
		{
			const topIndex:int = _sprite.numChildren - 1;
			const len:int = _cells.length;
			var tile:Tile;
			for (var i:int = 0; i < len; i++)
			{
				tile = _cells[i];
				if (tile.isContains(ImageRes.STONE) || tile.isContains(ImageRes.ROCK))
				{
					if (tile.objects[0].parent == _sprite) //ActiveBody STONE
						_sprite.setChildIndex(tile.objects[0], topIndex);
				}
			}
		}
		
		private function doPressesUp():void
		{
			if (_boxes.length == 0)
				return;
			
			const topIndex:int = _sprite.getChildIndex(_boxes[0]) - 1;
			for each (var body:Body in _presses)
			{
				_sprite.setChildIndex(body.userData.view, topIndex);
			}
		}
		
		private function doEnemiesUp():void
		{
			if (_enemies.length == 0)
				return;
			
			for each (var enemy:Enemy in _enemies)
			{
				_sprite.setChildIndex(enemy, _sprite.numChildren - 1);
			}
		}
		
		private function doBoxesUpGems():void
		{
			if (_gems.length == 0)
				return;
			
			const topIndex:int = _sprite.numChildren - 1;
			for each (var box:Box in _boxes)
			{
				_sprite.setChildIndex(box, topIndex);
			}
		}
		
		private function createTileImages():void
		{
			const len:int = _cells.length;
			var tile:Tile;
			for (var i:int = 0; i < len; i++)
			{
				tile = _cells[i];
				if (tile.isContains(ImageRes.GROUND))
				{
					createGroundImage(tile);
				}
			}
		}
		
		private function createDecor():void
		{
			const availables:Vector.<int> = new Vector.<int>();
			const types:Array = [ImageRes.DECOR_STONE, ImageRes.DECOR_GRASS, ImageRes.DECOR_BOARD];
			
			var len:int = _cells.length;
			var tile:Tile;
			var type:int;
			for (var i:int = 0; i < len; i++)
			{
				tile = _cells[i];
				if (tile.isContains(ImageRes.GROUND) && tile.top >= 0 && !_cells[tile.top].isContains(ImageRes.GROUND) && !_cells[tile.top].isContains(ImageRes.ROCK) && !_cells[tile.top].isContains(ImageRes.STONE) && tile.left >= 0 && tile.right >= 0 && _cells[tile.left].isContains(ImageRes.GROUND) && _cells[tile.right].isContains(ImageRes.GROUND) && _cells[tile.left].top >= 0 && _cells[tile.right].top >= 0 && !_cells[_cells[tile.left].top].isContains(ImageRes.GROUND) && !_cells[_cells[tile.left].top].isContains(ImageRes.ROCK) && !_cells[_cells[tile.left].top].isContains(ImageRes.STONE) && !_cells[_cells[tile.right].top].isContains(ImageRes.GROUND) && !_cells[_cells[tile.right].top].isContains(ImageRes.ROCK) && !_cells[_cells[tile.right].top].isContains(ImageRes.STONE))
				{
					availables.push(i);
				}
			}
			
			const numbers:Object = new Object();
			var sum:int;
			//trace("[types]", types, availables.length);
			for each (type in types)
			{
				numbers[type] = Math.round(availables.length * ImageRes.DECOR_PERCENTAGES[type] * 0.01);
				//trace("[sdsdsdsd]", numbers[type], type);
				if (numbers[type] < ImageRes.DECOR_RANGES[type][0])
					numbers[type] = ImageRes.DECOR_RANGES[type][0];
				else if (numbers[type] > ImageRes.DECOR_RANGES[type][1])
					numbers[type] = ImageRes.DECOR_RANGES[type][1];
				
				sum += numbers[type];
			}
			
			//trace("[decor numbers]", numbers[ImageRes.DECOR_STONE], numbers[ImageRes.DECOR_GRASS], numbers[ImageRes.DECOR_BOARD], availables.length);
			
			var index:int = 0;
			
			while (sum > 0)
			{
				for each (type in types)
				{
					if (numbers[type] > 0)
					{
						index = RandUtils.getInt(0, availables.length - 1);
						tile = _cells[availables[index]];
						tile.addDecor(type, _sprite);
						
						numbers[type]--;
						availables.splice(index, 1);
						sum--;
					}
				}
			}
		
			//trace("[decor after]", availables.length);
		
		}
		
		public function createGroundImage(tile:Tile):void
		{
			var indexImage:int = -1;
			var bitmap:Bitmap;
			var arr:Array;
			//trace("[createGroundImage]");
			if (tile.bottom == -2 || tile.bottom != -1 && !_cells[tile.bottom].isContains(ImageRes.GROUND))
			{
				bitmap = new Bitmap(ImageRes.getTileImage(ImageRes.BOTTOM_GROUND)[0]);
				_sprite.addChild(bitmap);
				tile.addImgObject(bitmap, ImageRes.BOTTOM_GROUND);
				
				bitmap.x = tile.x + Model.SIZE / 2 - bitmap.width / 2;
				bitmap.y = tile.y + Model.SIZE - 7;
				
				_grounds.push(tile); // sand------------------------------
			}
			if (tile.right == -2 || tile.right != -1 && !_cells[tile.right].isContains(ImageRes.GROUND))
			{
				arr = ImageRes.getTileImage(ImageRes.RIGHT_GROUND);
				bitmap = new Bitmap(arr[0]);
				_sprite.addChild(bitmap);
				tile.addImgObject(bitmap, ImageRes.RIGHT_GROUND);
				
				bitmap.x = tile.x + Model.SIZE - bitmap.width + 4;
				bitmap.y = tile.y + Model.SIZE / 2 - bitmap.height / 2;
				
				bitmap.name = arr[1].toString();
				indexImage = arr[1];
			}
			if (tile.left == -2 || tile.left != -1 && !_cells[tile.left].isContains(ImageRes.GROUND))
			{
				bitmap = new Bitmap(ImageRes.getTileImage(ImageRes.LEFT_GROUND, indexImage)[0]);
				_sprite.addChild(bitmap);
				tile.addImgObject(bitmap, ImageRes.LEFT_GROUND);
				bitmap.x = tile.x - 4;
				bitmap.y = tile.y + Model.SIZE / 2 - bitmap.height / 2;
			}
			if (tile.top == -2 || tile.top != -1 && !_cells[tile.top].isContains(ImageRes.GROUND))
			{
				bitmap = new Bitmap(ImageRes.getTileImage(ImageRes.TOP_GROUND)[0]);
				_sprite.addChild(bitmap);
				tile.addImgObject(bitmap, ImageRes.TOP_GROUND);
				bitmap.x = tile.x + Model.SIZE / 2 - bitmap.width / 2;
				bitmap.y = tile.y - bitmap.height / 2 + 1;
			}
		}
		
		public function createNextToGroundImage(tile:Tile):void
		{
			_counterSands += 4;
			//trace("[createNextToGroundImage]");
			AchievementController.getInstance().addParam(AchievementController.BLOW_GROUND);
			
			var indexImage:int = -1;
			var bitmap:Bitmap;
			var arr:Array;
			var nextTile:Tile;
			var topIndex:int = _sprite.numChildren - 3;
			
			if (tile.top >= 0 && _cells[tile.top].isContains(ImageRes.GROUND))
			{
				if (_cells[tile.top].imgObjects[1])
					topIndex = _sprite.getChildIndex(_cells[tile.top].imgObjects[1]);
				else if (_cells[tile.top].imgObjects[3])
					topIndex = _sprite.getChildIndex(_cells[tile.top].imgObjects[3]);
				
				bitmap = new Bitmap(ImageRes.getTileImage(ImageRes.BOTTOM_GROUND)[0]);
				_sprite.addChildAt(bitmap, topIndex);
				nextTile = _cells[tile.top];
				nextTile.addImgObject(bitmap, ImageRes.BOTTOM_GROUND);
				
				bitmap.x = tile.x + Model.SIZE / 2 - bitmap.width / 2;
				bitmap.y = tile.y - 7;
			}
			if (tile.left >= 0 && _cells[tile.left].isContains(ImageRes.GROUND))
			{
				if (_cells[tile.left].imgObjects[0])
					topIndex = _sprite.getChildIndex(_cells[tile.left].imgObjects[0]);
				
				//trace("[tt]",_cells[tile.left].imgObjects[0],topIndex);	
				
				arr = ImageRes.getTileImage(ImageRes.RIGHT_GROUND);
				bitmap = new Bitmap(arr[0]);
				_sprite.addChildAt(bitmap, topIndex - 1); //------------------------------
				nextTile = _cells[tile.left];
				nextTile.addImgObject(bitmap, ImageRes.RIGHT_GROUND);
				
				bitmap.x = nextTile.x + Model.SIZE - bitmap.width + 4;
				bitmap.y = nextTile.y + Model.SIZE / 2 - bitmap.height / 2;
				
				bitmap.name = arr[1].toString();
				indexImage = arr[1];
				
				if (_cells[tile.left].imgObjects[2] && topIndex != _sprite.numChildren - 4) //add +1
					_sprite.setChildIndex(_cells[tile.left].imgObjects[2], topIndex - 2);
			}
			if (tile.right >= 0 && _cells[tile.right].isContains(ImageRes.GROUND))
			{
				if (_cells[tile.right].imgObjects[0])
					topIndex = _sprite.getChildIndex(_cells[tile.right].imgObjects[0]);
				
				bitmap = new Bitmap(ImageRes.getTileImage(ImageRes.LEFT_GROUND, indexImage)[0]);
				_sprite.addChildAt(bitmap, topIndex - 1); //------------------------------
				nextTile = _cells[tile.right];
				nextTile.addImgObject(bitmap, ImageRes.LEFT_GROUND);
				bitmap.x = nextTile.x - 4;
				bitmap.y = nextTile.y + Model.SIZE / 2 - bitmap.height / 2;
				
				if (_cells[tile.right].imgObjects[2] && topIndex != _sprite.numChildren - 4) //add +1
					_sprite.setChildIndex(_cells[tile.right].imgObjects[2], topIndex - 2);
			}
			if (tile.bottom >= 0 && _cells[tile.bottom].isContains(ImageRes.GROUND))
			{
				bitmap = new Bitmap(ImageRes.getTileImage(ImageRes.TOP_GROUND)[0]);
				_sprite.addChild(bitmap);
				nextTile = _cells[tile.bottom];
				nextTile.addImgObject(bitmap, ImageRes.TOP_GROUND);
				bitmap.x = nextTile.x + Model.SIZE / 2 - bitmap.width / 2;
				bitmap.y = nextTile.y - bitmap.height / 2 + 1;
			}
			
			_sprite.setChildIndex(_hero, _sprite.numChildren - 1);
			
			const indexForSand:int = _grounds.indexOf(tile);
			if (indexForSand != -1)
				_grounds.splice(indexForSand, 1);
		}
		
		private function addSand():void
		{
			var tile:Tile = _grounds[RandUtils.getInt(0, _grounds.length - 1)];
			
			const bitmap:BitmapClip = new BitmapClip(new <uint>[AnimationRes.SAND], new <Array>[null], new Rectangle(0, 0, 64, 64));
			bitmap.play(AnimationRes.SAND, false);
			_sprite.addChildAt(bitmap, 0);
			
			//Controller.juggler.add(bitmap);
			bitmap.addEventListener(Event.COMPLETE, sandCompleteHandler, false, 0, true);
			
			bitmap.x = tile.x - 16;
			bitmap.y = tile.y + Math.random() * 10 + 21;
		}
		
		private function sandCompleteHandler(e:Event):void
		{
			const bitmap:BitmapClip = e.currentTarget as BitmapClip;
			//Controller.juggler.remove(bitmap);
			
			bitmap.removeEventListener(Event.COMPLETE, sandCompleteHandler);
			_sprite.removeChild(bitmap);
		}
		
		//=====================================================================================================================
		public function update():void
		{
			_space.step(1 / 60);
			
			CONFIG::debug
			{
				_debug.clear();
				_debug.draw(_space);
				_debug.flush();
			}
			
			if (_counterSands > 0)
				_counter++;
			
			if (_counter - 2 == 0)
			{
				_counter = 0;
				_counterSands--;
				addSand();
			}
		}
		
		public function destroy():void
		{
			var len:int = _cells.length;
			
			for (var j:int = 0; j < len; j++)
			{
				_cells[j].clear();
			}
			
			len = _space.listeners.length - 1;
			for (var i:int = len; i >= 0; i--)
			{
				_space.listeners.remove(_space.listeners.at(i));
			}
			
			len = _space.constraints.length - 1;
			for (i = len; i >= 0; i--)
			{
				_space.constraints.remove(_space.constraints.at(i));
					//trace("remove(constraints)");
			}
			
			len = _space.arbiters.length - 1;
			for (i = len; i >= 0; i--)
			{
				_space.arbiters.remove(_space.arbiters.at(i));
					//trace("remove(arbiters)");
			}
			
			//trace("_model.poolGrounds.length1", _model.poolGrounds.length)
			
			var body:Body;
			len = _space.bodies.length - 1;
			for (i = len; i >= 0; i--)
			{
				body = _space.bodies.at(i);
				
				if (body.userData.type == ImageRes.GROUND)
					_model.poolGrounds.push(body);
				else
					body.userData.view = null;
				
				body.userData.clip = null;
				_space.bodies.remove(body);
					//trace("remove(body)");
			}
			
			_space.clear();
			
			//trace("_model.poolGrounds.length2",_model.poolGrounds.length)
			
			_active.destroy();
			_active = null;
			
			_grounds.length = 0;
			_grounds = null;
			
			_boxes = null;
			_gems = null;
			_coins = null;
			_arts = null;
			_enemies = null;
			_sprite = null;
			_debug = null;
			_space = null;
			_hero = null;
			_cells = null;
			_progress = null;
			_model = null;
		}
		
		public function get hero():Hero
		{
			return _hero;
		}
		
		public function get space():Space
		{
			return _space;
		}
	}

}