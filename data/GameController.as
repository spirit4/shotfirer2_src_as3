package data
{
	import caurina.transitions.Tweener;
	import effects.PhysicalBurst;
	import event.GameEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.callbacks.OptionType;
	import nape.geom.Ray;
	import nape.geom.RayResult;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import sound.SoundManager;
	import sound.SoundRes;
	import units.*;
	import utils.Analytics;
	import utils.BitmapClip;
	import utils.Functions;
	import utils.Tile;
	import view.Game;
	import view.hints.Reminder;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class GameController
	{
		private var _data:Model;
		private var _game:Game;
		private var _hero:Hero;
		private var _heroController:HeroController;
		
		private var _heroCounters:Dictionary /*int*/ = new Dictionary();
		private var _targetTiles:Vector.<Tile> = new Vector.<Tile>();
		
		//private var _bloodHero:BitmapClip;
		private var _caseTNT:BitmapClip;
		private var _caseBattery:BitmapClip;
		
		private var _boxUnderFoot:Box;
		private var _selectTiles:Vector.<Bitmap> = new Vector.<Bitmap>();
		
		private var _achCounterTNT:int = 0;
		
		public function GameController(game:Game, heroController:HeroController)
		{
			_data = Controller.model;
			_hero = _data.hero;
			_game = game;
			_heroController = heroController;
			
			init();
		}
		
		private function init():void
		{
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_TNT_CASE, Model.BODY_HERO_BASE, toCaseTntHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_BATTERY_CASE, Model.BODY_HERO_BASE, toCaseBatteryHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_LOGO, Model.BODY_HERO_BASE, toLogoBodyHandler));
			
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_EXIT, Model.BODY_HERO, toExitHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_DANGER, Model.BODY_HERO_CENTER, toEnemyHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, Model.BODY_WALL, CbType.ANY_BODY, wallHandler));
			
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_STAIRS, Model.BODY_HERO, toStairHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.SENSOR, Model.BODY_STAIRS, Model.BODY_HERO, fromStairHandler));
			
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_STAIRS, Model.BODY_HERO_TOP, topToStairHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.SENSOR, Model.BODY_STAIRS, Model.BODY_HERO_TOP, topFromStairHandler));
			
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, new OptionType([Model.BODY_GROUND, Model.BODY_BOX]), Model.BODY_HERO_BOTTOM, toGroundHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.SENSOR, new OptionType([Model.BODY_GROUND, Model.BODY_BOX]), Model.BODY_HERO_BOTTOM, fromGroundHandler));
			
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, Model.BODY_GROUND, Model.BODY_HERO, topToGroundHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.ANY, Model.BODY_GROUND, Model.BODY_HERO, topFromGroundHandler));
			
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_GROUND, Model.BODY_HERO_SIDE, toTouchGroundHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.SENSOR, Model.BODY_GROUND, Model.BODY_HERO_SIDE, fromTouchGroundHandler));
			
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_BOX, Model.BODY_HERO_SIDE, toTouchBoxHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.SENSOR, Model.BODY_BOX, Model.BODY_HERO_SIDE, fromTouchBoxHandler));
			
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_NORMAL_BOX, new OptionType([Model.BODY_ENEMY, Model.BODY_HERO_SHAPE_ALL], [Model.BODY_WALL, Model.BODY_HERO_RADAR]), boxTouchHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_TNT_BOX, new OptionType([CbType.ANY_SHAPE], [Model.BODY_WALL, Model.BODY_HERO_RADAR]), boxTouchHandler));
			
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_CONTAINS_DUST, Model.BODY_HERO_BOTTOM, toDustHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.SENSOR, Model.BODY_CONTAINS_DUST, Model.BODY_HERO_BOTTOM, fromDustHandler));
			
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_BOX, Model.BODY_HERO_BOTTOM, standOnBoxHandler));
			_data.space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.SENSOR, Model.BODY_BOX, Model.BODY_HERO_BOTTOM, getOffBoxHandler));
			
			_heroCounters[Model.BODY_HERO_TOP] = 0;
			_heroCounters[Model.BODY_HERO_BOTTOM] = 0;
			_heroCounters[Model.BODY_HERO] = 0;
			_heroCounters[Model.BODY_GROUND] = 0;
			_heroCounters[Model.BODY_BOX] = 0;
			_heroCounters[Model.BODY_HERO_SIDE] = 0;
			_heroCounters[Model.BODY_CONTAINS_DUST] = 0;
			
			_hero.addEventListener(GameEvent.SET_DYNAMITE, tntSetHandler);
			_hero.addEventListener(GameEvent.HERO_SIT, heroSitHandler);
		}
		
		private function wallHandler(cb:InteractionCallback):void
		{
			//trace("[wallHandler]", cb.int2.castBody.userData.type);
			if (_hero.states.currentState != States.DEATH_0 && (cb.int2.castBody.userData.type == "topHero" || cb.int2.castBody.userData.type == "baseHero"))
			{
				SoundManager.getInstance().playSFX(SoundRes.SFX_DEATH_SPIKE);
				_hero.states.changeState(States.DEATH_0);
				_hero.visible = false;
				//_hero.view.addEventListener(Event.COMPLETE, deadHandler);
				
				AchievementController.getInstance().addParam(AchievementController.HERO_DEATH_ABYSS);
			}
			else
			{
				if (cb.int2.castBody.userData.bodyClass is Box)
				{
					const box:Box = cb.int2.castBody.userData.bodyClass as Box;
					box.removeBox();
				}
				else if (cb.int2.castBody.userData.bodyClass is Enemy)
				{
					AchievementController.getInstance().addParam(AchievementController.ENEMY_DEATH_ABYSS);
					
					const enemy:Enemy = cb.int2.castBody.userData.bodyClass as Enemy;
					enemy.removeEnemy()	
				}
			}
		
		}
		
		private function toEnemyHandler(cb:InteractionCallback):void
		{
			//trace("sdsadsad");
			if (cb.int1.castShape.cbTypes.has(Model.BODY_ENEMY))
			{
				const enemy:Enemy = cb.int1.castShape.body.userData.bodyClass as Enemy;
				
				var direction:int = 1;
				if (cb.int1.castShape.body.position.x - 10 - cb.int2.castShape.body.position.x < 0)
					direction = -1;
				
				if (enemy is Parrot)
				{
					const ray:Ray = new Ray(enemy.body.position, Vec2.weak(-direction, 0));
					const rayResult:RayResult = _data.space.rayCast(ray, false);
					
					//_game.levelLayer.graphics.lineStyle(1, 0xFF0000);
					//_game.levelLayer.graphics.moveTo(enemy.body.position.x,enemy.body.position.y);
					//_game.levelLayer.graphics.lineTo(enemy.body.position.x - direction * 200,enemy.body.position.y);
					
					//Controller.debug.drawLine(enemy.body.position, Vec2.weak( -direction, 200), 0xFF0000);
					//trace("[ray test:] ",rayResult.shape.cbTypes.has(Model.BODY_HERO_SHAPE_ALL), direction);
					if (cb.int1.castShape.body.userData.type != "bullet" && !rayResult.shape.cbTypes.has(Model.BODY_HERO_SHAPE_ALL))
						return;
				}
				
				enemy.touchHandler(direction);
				
				if (enemy is Parrot)
				{
					if ((enemy as Parrot).attackSensor == cb.int1.castShape)
						return;
					
					SoundManager.getInstance().playSFX(SoundRes.SFX_DEATH_PARROT);
				}
				
				if (enemy is Crab)
					SoundManager.getInstance().playSFX(SoundRes.SFX_DEATH_PARROT); //?????
				
				if (_hero.states.currentState != States.DEATH_0)//!_bloodHero && 
					AchievementController.getInstance().addParam(AchievementController.HERO_DEATH_ENEMY);
					
				if (enemy is Worm)
					AchievementController.getInstance().addParam(AchievementController.HERO_DEATH_WORM);
			}
			else if (_hero.states.currentState != States.DEATH_0 && cb.int1.castShape.body.userData.type == ImageRes.SPIKE)//!_bloodHero && 
			{
				SoundManager.getInstance().playSFX(SoundRes.SFX_DEATH_SPIKE);
				AchievementController.getInstance().addParam(AchievementController.HERO_DEATH_SPIKE);
			}
			
			if (enemy && enemy is Gollum)
				Tweener.addTween(_hero, {alpha: 1, time: 0.3, onComplete: killHeroWithDelay}); //delay die
			else
				killHeroWithDelay();
		
		}
		
		private function killHeroWithDelay():void
		{
			if (_hero && _hero.states.currentState != States.DEATH_0)//!_bloodHero && 
			{
				SoundManager.getInstance().playSFX(SoundRes.SFX_DEATH_GOLLUM);
				
				_hero.states.changeState(States.DEATH_0);
				//_hero.view.addEventListener(Event.COMPLETE, deadHandler);
			}
		}
		
		private function deadHandler(e:Event):void
		{
			_hero.view.removeEventListener(Event.COMPLETE, deadHandler);
			killHero(false);
		}
		
		private function toCaseTntHandler(cb:InteractionCallback):void
		{
			SoundManager.getInstance().playSFX(SoundRes.SFX_GET_TNT);
			
			const bitmap:Bitmap = cb.int1.castBody.userData.view as Bitmap;
			
			const animation:BitmapClip = new BitmapClip(new <uint>[AnimationRes.TNT_GET], new <Array>[null], new Rectangle(0, 0, 64, 64));
			animation.play(AnimationRes.TNT_GET, false);
			animation.x = bitmap.x - 16;
			animation.y = bitmap.y - 32;
			
			_game.levelLayer.addChild(animation);
			
			//Controller.juggler.add(animation);
			animation.addEventListener(Event.COMPLETE, completeTntGetHandler);
			_caseTNT = animation;
			
			bitmap.parent.removeChild(bitmap);
			cb.int1.castBody.userData.view = null;
			cb.int1.castBody.space = null;
			
			_data.progress.currentTNT += 4;
			_hero.dispatchEvent(new GameEvent(GameEvent.CHANGE_CAPACITY, true));
			
			_game.addChild(new Reminder("+4 dynamite", Reminder.GET_UP, 1.2));
			
			Analytics.pushPage(Analytics.GET_TNT);
			AchievementController.getInstance().addParam(AchievementController.GET_TNT_CASE);
		}
		
		private function completeTntGetHandler(e:Event):void
		{
			_caseTNT.removeEventListener(Event.COMPLETE, completeTntGetHandler);
			
			//Controller.juggler.remove(_caseTNT);
			_game.levelLayer.removeChild(_caseTNT);
			_caseTNT = null;
		}
		
		private function toCaseBatteryHandler(cb:InteractionCallback):void
		{
			SoundManager.getInstance().playSFX(SoundRes.SFX_GET_TNT);
			
			const bitmap:Bitmap = cb.int1.castBody.userData.view as Bitmap;
			
			const animation:BitmapClip = new BitmapClip(new <uint>[AnimationRes.BATTERY_GET], new <Array>[null], new Rectangle(0, 0, 64, 64));
			animation.play(AnimationRes.BATTERY_GET, false);
			animation.x = bitmap.x - 16;
			animation.y = bitmap.y - 32;
			
			_game.levelLayer.addChild(animation);
			
			//Controller.juggler.add(animation);
			animation.addEventListener(Event.COMPLETE, completeBatteryGetHandler);
			_caseBattery = animation;
			
			bitmap.parent.removeChild(bitmap);
			cb.int1.castBody.userData.view = null;
			cb.int1.castBody.space = null;
			
			_data.progress.currentBattery += 3;
			_hero.dispatchEvent(new GameEvent(GameEvent.CHANGE_CAPACITY, true));
			
			_game.addChild(new Reminder("+3 battery", Reminder.GET_UP, 1.2));
			
			Analytics.pushPage(Analytics.GET_BATTERY);
			AchievementController.getInstance().addParam(AchievementController.GET_BATTERY_CASE);
		}
		
		private function completeBatteryGetHandler(e:Event):void
		{
			_caseBattery.removeEventListener(Event.COMPLETE, completeTntGetHandler);
			
			//Controller.juggler.remove(_caseBattery);
			_game.levelLayer.removeChild(_caseBattery);
			_caseBattery = null;
		}
		
		private function toLogoBodyHandler(cb:InteractionCallback):void
		{
			SoundManager.getInstance().playSFX(SoundRes.SFX_GET_TNT);
			
			const bitmap:Bitmap = cb.int1.castBody.userData.view as Bitmap;
			bitmap.parent.removeChild(bitmap);
			cb.int1.castBody.userData.view = null;
			cb.int1.castBody.space = null;
			
			//_data.progress.currentBattery += 3;
			//_hero.dispatchEvent(new GameEvent(GameEvent.CHANGE_CAPACITY, true));
			//
			//_game.addChild(new Reminder("+3 battery", Reminder.GET_UP, 1.2));
			//
			Analytics.pushPage(Analytics.GET_LOGO);
			
			AchievementController.getInstance().addParam(AchievementController.GETTING_LOGO);
		}
		
		private function killHero(isPhysicalBurst:Boolean = true):void
		{
			Tweener.addTween(_game.parent, {_color_redOffset: 100, time: 0.3, transition: "easeOutElastic"});
			Tweener.addTween(_game.parent, {_color_redOffset: 0, time: 0.9, delay: 0.3, transition: "linear"});
			
			if (isPhysicalBurst)
			{
				SoundManager.getInstance().playSFX(SoundRes.SFX_DEATH_TNT);
				
				
				const burst:PhysicalBurst = new PhysicalBurst(_game, _data.space, 2, PhysicalBurst.HERO);
				burst.startBurst(_hero.x, _hero.y + 10, 3, 10);
				_hero.states.changeState(States.DEATH_0);
				_hero.base.setShapeFilters(Model.FILTER_TNT);
				_hero.top.setShapeFilters(Model.FILTER_TNT);
				
				burst.addEventListener(Event.COMPLETE, burstHandler);
				
				AchievementController.getInstance().addParam(AchievementController.HERO_DEATH_TNT);
			}
			else
				_heroController.isFail = true;
		}
		
		private function burstHandler(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, burstHandler);
			
			//_heroController.isFail = true;
		}
		
		//-----------exit-----------
		private function toExitHandler(cb:InteractionCallback):void
		{
			_data.space.listeners.remove(cb.listener)
			_heroController.isToExit = true;
			
			_data.space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.SENSOR, Model.BODY_EXIT, Model.BODY_HERO, fromExitHandler));
		}
		
		private function fromExitHandler(cb:InteractionCallback):void
		{
			_data.space.listeners.remove(cb.listener);
			_heroController.isToExit = false;
			
			_data.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_EXIT, Model.BODY_HERO, toExitHandler));
		}
		
		//-----------exit-----------
		//-----------stairs-----------
		private function toStairHandler(cb:InteractionCallback):void
		{
			_heroCounters[Model.BODY_HERO]++;
			
			if (_heroCounters[Model.BODY_HERO] == 1)
				_heroController.isToStairs = true;
		}
		
		private function fromStairHandler(cb:InteractionCallback):void
		{
			_heroCounters[Model.BODY_HERO]--;
			
			if (_heroCounters[Model.BODY_HERO] == 0)
				_heroController.isToStairs = false;
		}
		
		private function topToStairHandler(cb:InteractionCallback):void
		{
			_heroCounters[Model.BODY_HERO_TOP]++;
			
			if (_heroCounters[Model.BODY_HERO_TOP] == 1)
				_heroController.isTopToStairs = false;
		}
		
		private function topFromStairHandler(cb:InteractionCallback):void
		{
			_heroCounters[Model.BODY_HERO_TOP]--;
			
			if (_heroCounters[Model.BODY_HERO_TOP] == 0)
				_heroController.isTopToStairs = true;
		}
		
		//-----------stairs-----------
		//-----------ground-----------
		private function toGroundHandler(cb:InteractionCallback):void
		{
			_heroCounters[Model.BODY_HERO_BOTTOM]++;
			
			if (_heroCounters[Model.BODY_HERO_BOTTOM] == 1)
				_heroController.isToGround = true;
				
			if(cb.int1.castBody.userData.bodyClass && (cb.int1.castBody.userData.bodyClass is ActiveBody) && !(cb.int1.castBody.userData.bodyClass as ActiveBody).isActive)
				AchievementController.getInstance().addParam(AchievementController.TOUCH_SPIKE_ALIVE);
			
			//trace("gr:", (cb.int1.castBody.userData.bodyClass as ActiveBody).isActive);
		}
		
		private function fromGroundHandler(cb:InteractionCallback):void
		{
			_heroCounters[Model.BODY_HERO_BOTTOM]--;
			
			if (_heroCounters[Model.BODY_HERO_BOTTOM] == 0)
				_heroController.isToGround = false;
		}
		
		private function topToGroundHandler(cb:InteractionCallback):void
		{
			_heroCounters[Model.BODY_GROUND]++;
			
			if (_heroCounters[Model.BODY_GROUND] == 1)
				_heroController.isTopToGround = true;
		}
		
		private function topFromGroundHandler(cb:InteractionCallback):void
		{
			_heroCounters[Model.BODY_GROUND]--;
			
			if (_heroCounters[Model.BODY_GROUND] == 0)
				_heroController.isTopToGround = false;
		}
		
		private function toDustHandler(cb:InteractionCallback):void
		{
			_heroCounters[Model.BODY_CONTAINS_DUST]++;
			
			if (_heroCounters[Model.BODY_CONTAINS_DUST] == 1)
				_hero.isDust = true;
		}
		
		private function fromDustHandler(cb:InteractionCallback):void
		{
			_heroCounters[Model.BODY_CONTAINS_DUST]--;
			
			if (_heroCounters[Model.BODY_CONTAINS_DUST] == 0)
				_hero.isDust = false;
		}
		
		//-----------ground-----------
		
		//-----------side-----------
		private function toTouchGroundHandler(cb:InteractionCallback):void
		{
			_heroCounters[Model.BODY_HERO_SIDE]++;
			
			if (_heroCounters[Model.BODY_HERO_SIDE] == 1)
			{
				_hero.states.directionTNT = cb.int2.castShape.userData.direction;
				_heroController.isTouchingGround = true;
			}
		}
		
		private function fromTouchGroundHandler(cb:InteractionCallback):void
		{
			_heroCounters[Model.BODY_HERO_SIDE]--;
			
			if (_heroCounters[Model.BODY_HERO_SIDE] == 0)
				_heroController.isTouchingGround = false;
		}
		
		private function toTouchBoxHandler(cb:InteractionCallback):void
		{
			_heroCounters[Model.BODY_BOX]++;
			
			if (_heroCounters[Model.BODY_BOX] == 1)
				_heroController.isTouchingBox = true;
		}
		
		private function fromTouchBoxHandler(cb:InteractionCallback):void
		{
			_heroCounters[Model.BODY_BOX]--;
			
			if (_heroCounters[Model.BODY_BOX] == 0)
				_heroController.isTouchingBox = false;
		}
		
		//---box---------------------
		private function boxTouchHandler(cb:InteractionCallback):void
		{
			//trace("boxtouch", cb.int2.castShape.body.cbTypes.has(Model.BODY_WALL));
			
			//if (cb.int2.castShape.body.cbTypes.has(Model.BODY_WALL) || cb.int2.castShape.body.cbTypes.has(Model.BODY_HERO_RADAR))
				//return;
			
			var enemy:Parrot
			const body:Body = cb.int2.castShape.body;
			if (body.userData.bodyClass is Parrot)
				enemy = body.userData.bodyClass as Parrot;
			
			//trace("boxTouchHandler", cb.int1.castShape.body.userData.boomed);
			if ((!enemy || cb.int2.castShape != enemy.attackSensor) && body.userData.type != ImageRes.STAIRS && !cb.int1.castShape.body.userData.boomed)
			{
				const box:Box = cb.int1.castShape.body.userData.bodyClass as Box;
				box.touchHandler(body, killHero);
			}
		}
		
		private function standOnBoxHandler(cb:InteractionCallback):void
		{
			_boxUnderFoot = cb.int1.castBody.userData.bodyClass as Box;
		}
		
		private function getOffBoxHandler(cb:InteractionCallback):void
		{
			_boxUnderFoot = null;
		}
		
		//-----------side-----------
		
		private function tntSetHandler(e:GameEvent):void
		{
			if (_data.progress.currentTNT == 0)
			{
				SoundManager.getInstance().playSFX(SoundRes.SFX_NO_TNT);
				_game.addChild(new Reminder("NO dynamite", Reminder.JUMP, 0.5, 0.9));
				return;
			}
			
			const dx:Number = 10 * _hero.states.directionX;
			var index:int;
			index = Functions.getIndexCell(_hero.base.position.x + dx, _hero.base.position.y + Model.SIZE);
			
			if (isSecond(index, e.index, dx))
				return;
			
			if (_boxUnderFoot && e.index == 0)
			{
				_boxUnderFoot.tntSetHandler(killHero);
				return;
			}
			
			//trace("tnt under: ",_data.cells[index - Model.WIDTH].objects );
			if (e.index == 0 && 
				(index < 0 || 
				(index < _data.cells.length && 
				(_data.cells[index].objects.length == 0 || 
				_hero.base.position.y + Model.SIZE > (Model.HEIGHT + 0.5) * Model.SIZE) ||
				(_data.cells[index - Model.WIDTH].objects.length != 0 && !(_data.cells[index - Model.WIDTH].objects[0] is ActiveBody ||
				(_data.cells[index - Model.WIDTH].objects[0] is Sprite && _data.cells[index - Model.WIDTH].objects[0].name == ImageRes.ROCK_0.toString()))))))
				return;
			
			if (e.index == 1 || e.index == -1) //check for stairs
			{
				const sidePos:Number = _hero.base.position.x + dx + 14 * e.index;
				if (sidePos < 12 || sidePos > (Model.WIDTH + 1) * Model.SIZE + 28)
					return;
				
				var tile:Tile;
				tile = _data.cells[Functions.getIndexCell(sidePos, _hero.base.position.y)];
				if (!tile.isContains(ImageRes.GROUND))
					return;
			}
			
			var type:uint = Dynamite.GROUND;
			if (e.index == 0 &&
				(index >= _data.cells.length || _data.cells[index].isContains(ImageRes.STONE) ||
				_data.cells[index].isContains(ImageRes.PRESS_0) ||
				_data.cells[index].isContains(ImageRes.PRESS_1) ||
				_data.cells[index].isContains(ImageRes.PRESS_2) ||
				_data.cells[index].isContains(ImageRes.ROCK)))
				type = Dynamite.STONE;
			
			const tnt:Dynamite = new Dynamite(_game, e.index, type);
			tnt.addEventListener(GameEvent.DETONATED_DYNAMITE, detonateHandler);
			tnt.addEventListener(GameEvent.HERO_DEAD, tntKillHeroHandler);
			
			if (_data.progress.achievements[ImageRes.A_CRAZY_BLASTER] != 777)
				checkAch();
			
			//SoundManager.getInstance().playSFX(SoundRes.SFX_SET_TNT);
			
			_data.progress.currentTNT--;
			_hero.dispatchEvent(new GameEvent(GameEvent.CHANGE_CAPACITY, true));
			
			if (_hero.states.currentState == States.LYING_UP)
				AchievementController.getInstance().addParam(AchievementController.CRAWL_TNT);
			
			//if (!_data.progress.achievements[ImageRes.A_UNDERMINE_TNT] && (_hero.states.currentState == States.SIT || _hero.states.currentState == States.SIT_AT_ONCE))
				//_hero.startCheckVelocity();
			
			tnt.body.position.setxy(_hero.base.position.x + dx, _hero.base.position.y);
			tnt.view.x = _hero.base.position.x - 15;
			tnt.view.y = _hero.base.position.y - 21;
			tnt.countdown.x = _hero.base.position.x - 17;
			tnt.countdown.y = _hero.base.position.y + 13;
			
			if (e.index == 0)
			{
				if (index < _data.cells.length)
					_targetTiles.push(_data.cells[index]);
				
				tnt.view.x = _data.cells[index - Model.WIDTH].x + Model.SIZE / 2 - tnt.view.width / 2;
				tnt.body.position.x =  _data.cells[index - Model.WIDTH].x + Model.SIZE / 2;//!!!---
				tnt.countdown.x = _data.cells[index - Model.WIDTH].x + Model.SIZE / 2 - tnt.countdown.width / 2;
				
				if (!_data.progress.achievements[ImageRes.A_MINER])
				{
					const bodyList:BodyList = _data.space.bodiesUnderPoint(Vec2.weak(_data.cells[index - Model.WIDTH].x + Model.SIZE / 2, _hero.base.position.y));
					var body:Body;
					if (bodyList.length > 0)
					{
						for (var i:int = 0; i < bodyList.length; i++)
						{
							body = bodyList.at(i);
							if (body.cbTypes.has(Model.BODY_BOX))
								AchievementController.getInstance().addParam(AchievementController.TNT_UNDER_BOX_OR_TROLLEY);
						}
					}
				}
				if (index >= _data.cells.length || _data.cells[index].isContains(ImageRes.STONE) || _data.cells[index].isContains(ImageRes.ROCK))
					AchievementController.getInstance().addParam(AchievementController.TNT_ON_STONE);
			}
			else
				tntSetLeftOrRight(e.index, tnt);
				
			tnt.addRange();
		}
		
		private function isSecond(index:int, eIndex:int, dx:Number):Boolean
		{
			if (_targetTiles.length > 0)
			{
				if (index == _targetTiles[0].index)
					return true;
				
				if ((eIndex == -1 || eIndex == 1) && _data.cells[Functions.getIndexCell(_hero.base.position.x + dx + eIndex * 14, _hero.base.position.y)].index == _targetTiles[0].index)
					return true;
			}
			
			if (_boxUnderFoot && eIndex == 0 && _boxUnderFoot.isDynamite)
				return true;
			
			return false;
		}
		
		private function tntKillHeroHandler(e:GameEvent):void
		{
			e.currentTarget.removeEventListener(GameEvent.HERO_DEAD, tntKillHeroHandler);
			killHero();
		}
		
		private function tntSetLeftOrRight(index:int, tnt:Dynamite):void
		{
			var tile:Tile;
			if (index == -1)
			{
				tile = _data.cells[Functions.getIndexCell(tnt.body.position.x - 14, tnt.body.position.y)];
				if (tile.isContains(ImageRes.GROUND))
				{
					tnt.view.x += Model.SIZE;
					tnt.view.x -= 2;
					tnt.countdown.x -= 26;
					tnt.countdown.y -= 33;
					tnt.view.rotation = 90;
					
					_targetTiles.push(tile);
				}
			}
			else if (index == 1)
			{
				tile = _data.cells[Functions.getIndexCell(tnt.body.position.x + 14, tnt.body.position.y)];
				if (tile.isContains(ImageRes.GROUND))
				{
					tnt.countdown.x += Model.SIZE - 2;
					tnt.countdown.y -= 31;
					tnt.view.y += Model.SIZE;
					tnt.view.rotation = -90;
					
					_targetTiles.push(tile);
				}
			}
		}
		
		private function detonateHandler(e:GameEvent):void
		{
			const tnt:Dynamite = e.currentTarget as Dynamite;
			
			if (tnt.type == Dynamite.GROUND)
				SoundManager.getInstance().playSFX(SoundRes.SFX_DYNAMITE);
			else if (tnt.type == Dynamite.STONE)
				SoundManager.getInstance().playSFX(SoundRes.SFX_STONE_TNT);
			
			e.currentTarget.removeEventListener(GameEvent.DETONATED_DYNAMITE, detonateHandler);
			e.currentTarget.removeEventListener(GameEvent.HERO_DEAD, tntKillHeroHandler);
			
			if (!_hero)
				return;
			
			const tile:Tile = _targetTiles.shift();
			if (tile && tile.isContains(ImageRes.GROUND))
			{
				for each (var object:DisplayObject in tile.imgObjects)
				{
					if (object)
						object.parent.removeChild(object);
				}
				tile.removeDecor();
				tile.getObject(0).parent.removeChild(tile.getObject(0));
				tile.staticBodies[ImageRes.GROUND].space = null;
				tile.clear();
				
				_data.currentObjectLevel.createNextToGroundImage(tile);
			}
		}
		
		private function heroSitHandler(e:GameEvent):void
		{
			if (_selectTiles.length > 0 && e.index == -2) //clear
			{
				for each (var bitmap:Bitmap in _selectTiles)
				{
					Tweener.addTween(bitmap, {_brightness: 0, time: 0.2, transition: "easeInQuart"});
				}
				_selectTiles.length = 0;
			}
			else
			{
				var index:uint = Functions.getIndexCell(_hero.base.position.x + 10 * _hero.states.directionX, _hero.base.position.y + Model.SIZE);
				
				if (e.index == 0)
				{
					if (index >= _data.cells.length || 
						index < 0 || 
						_data.cells[index].objects.length == 0 || 
						_hero.base.position.y + Model.SIZE > (Model.HEIGHT + 0.5) * Model.SIZE ||
						(_data.cells[index - Model.WIDTH].objects.length != 0 && !(_data.cells[index - Model.WIDTH].objects[0] is ActiveBody ||
						(_data.cells[index - Model.WIDTH].objects[0] is Sprite && _data.cells[index - Model.WIDTH].objects[0].name == ImageRes.ROCK_0.toString()))))
						return;
				}
				
				if (e.index == -1 || e.index == 1)
				{
					const sidePos:Number = _hero.base.position.x + 24 * e.index;
					if (sidePos < 12 || sidePos > (Model.WIDTH + 1) * Model.SIZE + 28)
						return;
				}
				
				if (e.index == -1)
					index = Functions.getIndexCell(_hero.base.position.x - 24, _hero.base.position.y);
				else if (e.index == 1)
					index = Functions.getIndexCell(_hero.base.position.x + 24, _hero.base.position.y);
				
				if (index >= _data.cells.length || index < 0 || _data.cells[index].objects.length == 0)
					return;
				
				if (_data.cells[index].isContains(ImageRes.GROUND) && e.index != -2)
				{
					if (_hero.states.currentState == States.SIT || _hero.states.currentState == States.SIT_AT_ONCE || _hero.states.currentState == States.ARM_UP || _hero.states.currentState == States.LYING_UP)
					{
						_selectTiles.unshift(_data.cells[index].getObject(0) as Bitmap);
						Tweener.addTween(_selectTiles[0], {_brightness: 0.3, time: 0.2, transition: "easeOutQuart"});
					}
					
					if (_selectTiles.length > 1)
					{
						Tweener.addTween(_selectTiles[_selectTiles.length - 1], {_brightness: 0, time: 0.2, transition: "easeInQuart"});
						_selectTiles.pop();
					}
				}
			}
		}
		
		private function checkAch():void
		{
			_achCounterTNT++;
			
			if (Controller.juggler.isCallback(resetAchCounter) && _achCounterTNT == 3)
			{
				AchievementController.getInstance().addParam(AchievementController.BLOW_3_FOR_5);
				return;
			}
			
			//trace("_achCounterTNT",_achCounterTNT);
			if (!Controller.juggler.isCallback(resetAchCounter))
				Controller.juggler.addCall(resetAchCounter, 5);
		}
		
		private function resetAchCounter():void
		{
			Controller.juggler.removeCall(resetAchCounter);
			_achCounterTNT = 0;
		}
		
		public function destroy():void
		{
			_hero.removeEventListener(GameEvent.SET_DYNAMITE, tntSetHandler);
			_hero.removeEventListener(GameEvent.HERO_SIT, heroSitHandler);
			
			if (_hero.view)
				_hero.view.removeEventListener(Event.COMPLETE, deadHandler);
			
			resetAchCounter();
			//if (_bloodHero)
			//{
				//_bloodHero.removeEventListener(Event.COMPLETE, bloodHandler);
				//_bloodHero.removeEventListener(Event.COMPLETE, bloodCompleteHandler);
			//}
			//
			_heroCounters = null;
			_hero = null;
			_game = null;
			_data = null;
			_heroController = null;
			
			_targetTiles.length = 0;
			_targetTiles = null;
			
			//_bloodHero = null;
			_caseTNT = null;
			_caseBattery = null;
			_boxUnderFoot = null;
			
			_selectTiles.length = 0;
			_selectTiles = null;
		}
	
	}

}