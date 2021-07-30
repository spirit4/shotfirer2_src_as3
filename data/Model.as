package data
{
	import event.GameEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	import nape.callbacks.CbType;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	import sound.SoundManager;
	import units.Box;
	import units.Enemy;
	import units.Hero;
	import utils.Analytics;
	import utils.debug.Console;
	import utils.HintToLevel;
	import utils.Statistics;
	import utils.Tile;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Model extends EventDispatcher
	{
		public static const WIDTH:int = 24; //number cells was 19
		public static const HEIGHT:int = 18; //number cells was 14
		public static const SIZE:int = 32; //one cell (px)
		public static const PADDING_TOP:int = 12; //one cell (px)
		
		public static var isDebug:Boolean = false;
		public static var console:Console;
		
		private var _cells:Vector.<Tile>;
		
		private var _progress:Progress;
		private var _ac:AchievementController;
		
		public static const BODY_HERO_RADAR:CbType = new CbType();
		public static const BODY_HERO_CENTER:CbType = new CbType();
		public static const BODY_HERO:CbType = new CbType();
		public static const BODY_HERO_BASE:CbType = new CbType();
		public static const BODY_HERO_TOP:CbType = new CbType();
		public static const BODY_HERO_BOTTOM:CbType = new CbType();
		public static const BODY_HERO_SIDE:CbType = new CbType();
		public static const BODY_HERO_ALL:CbType = new CbType();
		public static const BODY_HERO_SHAPE_ALL:CbType = new CbType();
		public static const BODY_EXIT:CbType = new CbType();
		public static const BODY_STAIRS:CbType = new CbType();
		public static const BODY_GEM:CbType = new CbType();
		public static const BODY_COIN:CbType = new CbType();
		public static const BODY_GROUND:CbType = new CbType();
		public static const BODY_CONTAINS_DUST:CbType = new CbType();
		public static const BODY_BOX:CbType = new CbType();
		public static const BODY_NORMAL_BOX:CbType = new CbType();
		public static const BODY_TNT:CbType = new CbType();
		public static const BODY_TNT_BOX:CbType = new CbType();
		public static const BODY_TNT_CASE:CbType = new CbType();
		public static const BODY_BATTERY_CASE:CbType = new CbType();
		public static const BODY_LOGO:CbType = new CbType();
		public static const BODY_ENEMY:CbType = new CbType();
		public static const BODY_PARROT_ATTACK_SENSOR:CbType = new CbType();
		public static const BODY_DANGER:CbType = new CbType();
		public static const BODY_SPIKE:CbType = new CbType();
		public static const BODY_PRESS:CbType = new CbType();
		public static const BODY_ARTEFACT:CbType = new CbType();
		public static const BODY_IDOL:CbType = new CbType();
		public static const BODY_WALL:CbType = new CbType();
		
		public static const BODY_BONUS_TNT:CbType = new CbType();
		public static const BODY_BONUS_SPHERE:CbType = new CbType();
		
		private static const ALL:int = 0x0001;
		private static const HERO:int = 0x0002;
		private static const TNT:int = 0x0004;
		private static const PARTS:int = 0x0008;
		private static const ENEMY:int = 0x0010;
		private static const BOX:int = 0x0020;
		private static const SPIKE:int = 0x0040;
		
		//public static const FILTER_HERO:InteractionFilter = new InteractionFilter(HERO, ALL, HERO, ALL | SPIKE | BOX);
		//public static const FILTER_TNT:InteractionFilter = new InteractionFilter(TNT, ALL);
		//public static const FILTER_TNT_PARTICLES:InteractionFilter = new InteractionFilter(PARTS, ALL | HERO);
		//public static const FILTER_ENEMY:InteractionFilter = new InteractionFilter(ENEMY, ALL | HERO | BOX | SPIKE);
		//public static const FILTER_BOX:InteractionFilter = new InteractionFilter(1, ~PARTS, BOX, ALL | HERO | ENEMY | BOX);
		//public static const FILTER_ENEMY_BULLET:InteractionFilter = new InteractionFilter(ENEMY, ALL | HERO | BOX);
		//public static const FILTER_FOR_CRAB:InteractionFilter = new InteractionFilter(ENEMY, ALL | HERO | BOX, ENEMY, ALL | HERO | BOX);
		//public static const FILTER_SPIKE:InteractionFilter = new InteractionFilter(SPIKE, ALL | BOX | ENEMY);
		
		public static const FILTER_HERO:InteractionFilter = new InteractionFilter(HERO, ALL | BOX, HERO, ALL | ENEMY | BOX |SPIKE);
		public static const FILTER_TNT:InteractionFilter = new InteractionFilter(TNT, ALL, TNT, ALL);
		public static const FILTER_TNT_PARTICLES:InteractionFilter = new InteractionFilter(PARTS, ALL, PARTS, 0);
		public static const FILTER_ENEMY:InteractionFilter = new InteractionFilter(ENEMY, ALL | BOX | SPIKE, ENEMY, ALL | HERO | BOX | SPIKE);
		public static const FILTER_BOX:InteractionFilter = new InteractionFilter(BOX, ALL | HERO | ENEMY | BOX | SPIKE, BOX, ALL | HERO | ENEMY | BOX | SPIKE);
		public static const FILTER_ENEMY_BULLET:InteractionFilter = new InteractionFilter(ENEMY, ALL | HERO | BOX | SPIKE, ENEMY, ALL | HERO | BOX | SPIKE);
		public static const FILTER_FOR_CRAB:InteractionFilter = new InteractionFilter(ENEMY, ALL | HERO | BOX, ENEMY, ALL | HERO | BOX);
		public static const FILTER_SPIKE:InteractionFilter = new InteractionFilter(SPIKE, ALL | BOX | ENEMY, SPIKE, ALL | HERO | BOX | ENEMY);
		
		private var _space:Space;
		
		private var _hero:Hero;
		private var _boxes:Vector.<Box> = new Vector.<Box>();
		private var _gems:Vector.<Body> = new Vector.<Body>();
		private var _coins:Vector.<Body> = new Vector.<Body>();
		private var _arts:Vector.<Body> = new Vector.<Body>();
		private var _presses:Vector.<Body> = new Vector.<Body>();
		private var _enemies:Vector.<Enemy> = new Vector.<Enemy>();
		
		private var _poolGrounds:Vector.<Body> = new Vector.<Body>();
		private var _cacheWalls:Body;
		
		private var _currentObjectLevel:Level;
		
		private var _shapeHints:Vector.<Shape>;
		private var _bitmapHints:Vector.<Bitmap>;
		
		private var _so:SharedObject;
		
		static public const GLOBAL_IDLE:int = 0;
		static public const GLOBAL_GAME:int = 1;
		static public const GLOBAL_PAUSE:int = 2;
		
		private var _globalState:int = 0;
		
		public function Model()
		{
			_progress = new Progress();
			Behavior.init();
			
			CONFIG::release
			{
				loadSharedObject();
			}
			
			createCells();
			prepareBodies();
		}
		
		private function loadSharedObject():void
		{
			_so = SharedObject.getLocal("shotfirerSave_v" + Analytics.NUMBER_VERSION);
			
			if (_so.size != 0)
			{
				_progress.isGameComplete = _so.data.isGameComplete;
				_progress.levelsCompleted = _so.data.levelsCompleted;
				_progress.currentLevel = _so.data.currentLevel;
				_progress.totalMoney = _so.data.totalMoney;
				
				_progress.tntLevel = _so.data.tntLevel;
				_progress.radarLevel = _so.data.radarLevel;
				_progress.batteryLevel = _so.data.batteryLevel;
				
				_progress.spentTime = _so.data.spentTime;
				_progress.starToLevels = _so.data.starToLevels;
				_progress.allStar = _so.data.allStar;
				_progress.achievements = _so.data.achievements;
				
				//_progress.facebook = _so.data.facebook;
				//_progress.twitter = _so.data.twitter;
				
				SoundManager.getInstance().setSavingState(Boolean(_so.data.music), Boolean(_so.data.sfx));
			}
		}
		
		private function saveSharedObject():void
		{
			_so.data.isGameComplete = _progress.isGameComplete;
			_so.data.levelsCompleted = _progress.levelsCompleted;
			_so.data.currentLevel = _progress.currentLevel;
			_so.data.totalMoney = _progress.totalMoney;
			
			_so.data.tntLevel = _progress.tntLevel;
			_so.data.radarLevel = _progress.radarLevel;
			_so.data.batteryLevel = _progress.batteryLevel;
			
			_so.data.spentTime = _progress.spentTime;
			_so.data.starToLevels = _progress.starToLevels;
			_so.data.allStar = _progress.allStar;
			_so.data.achievements = _progress.achievements;
			
			//_so.data.facebook = _progress.facebook;
			//_so.data.twitter = _progress.twitter;
			
			_so.data.music = SoundManager.getInstance().isMusic;
			_so.data.sfx = SoundManager.getInstance().isSFX;
			
			_so.flush();
		}
		
		public function clearSharedObject():void
		{
			if (!_so)
				return;
			
			_so.data.isGameComplete = false;
			_so.data.levelsCompleted = 15;//temp!!!!!!!!!!!!!!!!!
			_so.data.currentLevel = 0;
			_so.data.totalMoney = 0;
			
			_so.data.tntLevel = 0;
			_so.data.radarLevel = 1;
			_so.data.batteryLevel = 1;
			
			_so.data.spentTime = 0;
			_so.data.starToLevels = new <int>[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,];
			_so.data.allStar = 0;
			_so.data.achievements = new <int>[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,];
			
			_so.data.music = true;
			_so.data.sfx = true;
			
			_so.flush();
			
			loadSharedObject();
		}
		
		private function createCells():void
		{
			_cells = new Vector.<Tile>(WIDTH * HEIGHT);
			var xCell:int;
			var yCell:int;
			
			const len:int = WIDTH * HEIGHT;
			for (var i:int = 0; i < len; i++)
			{
				yCell = (int(i / WIDTH)) * SIZE + PADDING_TOP;
				xCell = (i - int(i / WIDTH) * WIDTH) * SIZE + SIZE / 2;
				
				_cells[i] = new Tile(xCell, yCell, i);
				_cells[i].setNextTiles(WIDTH, HEIGHT);
			}
		}
		
		public function goToNextLevel():void
		{
			//level stats
			Statistics.jumpAuto = 0;
			Statistics.bonusArrows = 0;
			Statistics.bonusMouse = 0;
			Statistics.crawlAuto = 0;
			Statistics.crawlButton = 0;
			Statistics.tntCtrl = 0;
			Statistics.tntPerLvl = 0;
			Statistics.tntSpace = 0;
			Statistics.tntZ = 0;
			Statistics.lvlRetries = 0;
			
			_progress.currentStar = 0;
			_progress.currentLevel++;
			
			if(_progress.currentLevel == _progress.levelsCompleted)
				_progress.levelsCompleted++;
			
			if (_progress.levelsCompleted > 45) //45
				_progress.levelsCompleted = 45;
			
			if (_progress.currentLevel > 44)
				_progress.currentLevel = 44;
			
			CONFIG::release
			{
				saveSharedObject();
			}
			
			trace("goToNextLevel() --->> currentLevel: ", _progress.currentLevel)
		}
		
		public function destroyLevel():void
		{
			_ac.removeAchievement();
			
			_shapeHints.length = 0;
			_bitmapHints.length = 0;
			_shapeHints = null;
			_bitmapHints = null;
			
			for each (var enemy:Enemy in _enemies)
			{
				enemy.destroy();
			}
			
			_hero.destroy(); //hero!!!-----------------------------------
			_currentObjectLevel.destroy();
			_currentObjectLevel = null;
			
			_boxes.length = 0;
			_gems.length = 0;
			_coins.length = 0;
			_arts.length = 0;
			_presses.length = 0;
			_enemies.length = 0;
			_hero = null;
		}
		
		public function loadLevel(sprite:Sprite, testSprite:Sprite):void
		{
			//_currentObjectLevel = new Level(sprite, testSprite, JSONRes.tileLevels[_progress.currentLevel]);
			if (JSONRes.editingLevel.length == 0)
				_currentObjectLevel = new Level(sprite, testSprite, JSONRes.tileLevels[_progress.currentLevel]);
			else
				_currentObjectLevel = new Level(sprite, testSprite, JSONRes.editingLevel);
			
			_hero = _currentObjectLevel.hero;
			
			createTooltips(sprite);
			
			sprite.setChildIndex(hero, sprite.numChildren - 1);
			
			_currentObjectLevel.addEventListener(Event.INIT, initHandler);
		}
		
		private function initHandler(e:Event):void
		{
			_currentObjectLevel.removeEventListener(Event.INIT, initHandler);
			
			dispatchEvent(new GameEvent(GameEvent.LEVEL_INIT));
		}
		
		private function prepareBodies():void
		{
			const gravity:Vec2 = Vec2.weak(0, 600);
			_space = new Space(gravity);
			
			var body:Body;
			var bitmap:Bitmap;
			var bd:BitmapData;
			
			for (var i:int = 0; i < 50; i++)
			{
				body = new Body(BodyType.STATIC);
				body.shapes.add(new Polygon(Polygon.rect(0, 0, SIZE, SIZE, true), Material.wood()));
				
				bd = ImageRes.getTileBody(ImageRes.GROUND);
				bitmap = new Bitmap(bd);
				body.userData.view = bitmap;
				
				body.userData.type = ImageRes.GROUND;
				
				body.cbTypes.add(Model.BODY_GROUND);
				body.cbTypes.add(Model.BODY_CONTAINS_DUST);
				
				_poolGrounds.push(body);
			}
			
			createCacheWalls();
		}
		
		private function createCacheWalls():void
		{
			const material:Material = Material.steel();
			material.elasticity = 0;
			material.density = 10;
			
			const w:Number = SIZE * (WIDTH + 1);
			const h:Number = SIZE * HEIGHT + 2 * PADDING_TOP;
			const wall:Body = new Body(BodyType.STATIC);
			wall.userData.type = "wall";
			
			var poly:Polygon;
			//top
			poly = new Polygon(Polygon.rect(-SIZE * 4, -SIZE * 4, w + SIZE * 8, SIZE, true), material);
			poly.sensorEnabled = true;
			wall.shapes.add(poly);
			//bottom
			poly = new Polygon(Polygon.rect(-SIZE * 4, h + SIZE * 3, w + SIZE * 8, SIZE, true), material);
			poly.sensorEnabled = true;
			wall.shapes.add(poly);
			//left
			poly = new Polygon(Polygon.rect(-SIZE * 4, -SIZE * 4, SIZE, h + SIZE * 8, true), material);
			poly.sensorEnabled = true;
			wall.shapes.add(poly);
			//right
			poly = new Polygon(Polygon.rect(w + SIZE * 3, -SIZE * 4, SIZE, h + SIZE * 8, true), material);
			poly.sensorEnabled = true;
			wall.shapes.add(poly);
			
			wall.cbTypes.add(Model.BODY_WALL);
			wall.userData.type = "wall";
			
			_cacheWalls = wall;
		}
		
		private function createTooltips(sprite:Sprite):void
		{
			const hints:Vector.<HintToLevel> = Behavior.tooltips[_progress.currentLevel];
			var shape:Shape;
			var bitmap:Bitmap;
			_shapeHints = new Vector.<Shape>();
			_bitmapHints = new Vector.<Bitmap>();
			
			for each (var hint:HintToLevel in hints)
			{
				shape = new Shape();
				shape.graphics.beginFill(0x000000,0.3);
				shape.graphics.drawRect(0, 0, hint.w, hint.h);
				shape.graphics.endFill();
				sprite.addChild(shape);
				shape.x = hint.x;
				shape.y = hint.y;
				shape.visible = false;
				_shapeHints.push(shape);
				
				bitmap = new Bitmap(hint.bd);
				sprite.addChild(bitmap);
				bitmap.x = hint.xHint;
				bitmap.y = hint.yHint;
				bitmap.visible = false;
				_bitmapHints.push(bitmap);
			}
		}
		
		//=============================================================================================================
		public function update():void
		{
			_currentObjectLevel.update();
			
			for (var i:int = 0; i < _shapeHints.length; i++)
			{
				if (_hero.hitTestObject(_shapeHints[i]))
				{
					if (!_bitmapHints[i].visible)
						_bitmapHints[i].visible = true;
				}
				else
				{
					if (_bitmapHints[i].visible)
						_bitmapHints[i].visible = false;
				}
			}
			
			for each (var box:Box in _boxes)
			{
				if (box.body.velocity.y > 10)
					box.body.velocity.x = 0;
				
				box.update();
			}
			
			for each (var enemy:Enemy in _enemies)
			{
				enemy.update();
			}
		}
		
		public function get cells():Vector.<Tile>
		{
			return _cells;
		}
		
		public function get progress():Progress
		{
			return _progress;
		}
		
		public function get space():Space
		{
			return _space;
		}
		
		public function get hero():Hero
		{
			return _hero;
		}
		
		public function get currentObjectLevel():Level
		{
			return _currentObjectLevel;
		}
		
		public function get gems():Vector.<Body>
		{
			return _gems;
		}
		
		public function get arts():Vector.<Body>
		{
			return _arts;
		}
		
		public function get presses():Vector.<Body>
		{
			return _presses;
		}
		
		public function get enemies():Vector.<Enemy>
		{
			return _enemies;
		}
		
		public function get boxes():Vector.<Box>
		{
			return _boxes;
		}
		
		public function set ac(value:AchievementController):void
		{
			_ac = value;
		}
		
		public function get poolGrounds():Vector.<Body>
		{
			return _poolGrounds;
		}
		
		public function get cacheWalls():Body
		{
			return _cacheWalls;
		}
		
		public function set cacheWalls(value:Body):void
		{
			_cacheWalls = value;
		}
		
		public function get coins():Vector.<Body> 
		{
			return _coins;
		}
		
		public function get globalState():int 
		{
			return _globalState;
		}
		
		public function set globalState(value:int):void 
		{
			_globalState = value;
			//trace("set globalState", _globalState);
			//Controller.juggler.pause(value);
		}
	}

}