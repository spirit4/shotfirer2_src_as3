package data
{
	import effects.PhysicalBurst;
	import event.GameEvent;
	import event.WindowEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.space.Space;
	import sound.SoundManager;
	import sound.SoundRes;
	import units.Crab;
	import units.Enemy;
	import units.Hero;
	import units.Parrot;
	import units.States;
	import utils.Arrow;
	import utils.BitmapClip;
	import utils.Functions;
	import utils.Statistics;
	import utils.Tile;
	import view.Game;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class BonusController
	{
		private var _stage:Stage;
		private var _space:Space;
		private var _hero:Hero;
		private var _data:Model;
		private var _game:Game;
		private var _progress:Progress;
		
		private var _enemies:Vector.<Enemy>;
		private var _cells:Vector.<Tile>;
		private var _deletingEnemies:Vector.<Enemy> = new Vector.<Enemy>();
		
		private var _leftKeyDown:Boolean;
		private var _upKeyDown:Boolean;
		private var _rightKeyDown:Boolean;
		private var _downKeyDown:Boolean;
		private var _spaceKeyDown:Boolean;
		
		private var _arrow:Arrow;
		private var _tnts:Vector.<Body> = new Vector.<Body>();
		private var _deleting:Vector.<Body> = new Vector.<Body>();
		
		private var _counter:int;
		private var _counterForce:int;
		private var _forceK:Number = 1;
		private var _isThrow:Boolean;
		
		private var _numberEnemies:uint; //for achievements
		
		public function BonusController(stage:Stage, game:Game)
		{
			_stage = stage;
			_data = Controller.model;
			_space = _data.space;
			_enemies = _data.enemies;
			_cells = _data.cells;
			_hero = _data.hero;
			_progress = _data.progress;
			_game = game;
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
			
			addArrowDirection();
			addHeroSphere();
			
			_numberEnemies = _enemies.length;
		}
		
		private function checkKeysDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ESCAPE)
			{
				//_stage.dispatchEvent(new WindowEvent(WindowEvent.RETURN_TO_MENU));
				_stage.dispatchEvent(new WindowEvent(WindowEvent.RETURN_TO_EDITING));
				removeHandlers();
				return;
			}
			
			if (e.keyCode == Keyboard.R)
			{
				_hero.dispatchEvent(new GameEvent(GameEvent.HERO_DEAD, true));
				removeHandlers();
				return;
			}
			
			if (e.keyCode == Keyboard.M)
			{
				SoundManager.getInstance().isMusic = !SoundManager.getInstance().isMusic;
				SoundManager.getInstance().isSFX = !SoundManager.getInstance().isSFX;
				return;
			}
			
			if (e.keyCode == Keyboard.P || e.keyCode == 19)
			{
				_hero.dispatchEvent(new WindowEvent(WindowEvent.PAUSE, true));
				return;
			}
			
			CONFIG::debug
			{
				if (e.keyCode == Keyboard.Q)
					Model.isDebug = !Model.isDebug;
			}
			
			if (e.keyCode == 37 || e.keyCode == 65) //left---------
				_leftKeyDown = true;
			
			if (e.keyCode == 39 || e.keyCode == 68) //right---------
				_rightKeyDown = true;
			
			if (e.keyCode == 38 || e.keyCode == 87) //up---------
				_upKeyDown = true;
			
			if (e.keyCode == 40 || e.keyCode == 83) //down---------
				_downKeyDown = true;
			
			if (e.keyCode == Keyboard.Z || e.keyCode == Keyboard.SPACE || e.keyCode == Keyboard.CONTROL)
			{
				if (e.keyCode == Keyboard.Z)
					Statistics.tntZ++;
				else if (e.keyCode == Keyboard.SPACE)
					Statistics.tntSpace++;
				else if (e.keyCode == Keyboard.CONTROL)
					Statistics.tntCtrl++;
				
				if (!_spaceKeyDown)
					shootTNT();
				
				_spaceKeyDown = true;
			}
		}
		
		private function checkKeysUp(e:KeyboardEvent):void
		{
			if (e.keyCode == 37 || e.keyCode == 65) //left---------
				_leftKeyDown = false;
			
			if (e.keyCode == 39 || e.keyCode == 68) //right---------
				_rightKeyDown = false;
			
			if (e.keyCode == 38 || e.keyCode == 87) //up---------
				_upKeyDown = false;
			
			if (e.keyCode == 40 || e.keyCode == 83) //down---------
				_downKeyDown = false;
			
			if (e.keyCode == Keyboard.Z || e.keyCode == Keyboard.SPACE || e.keyCode == Keyboard.CONTROL)
			{
				if (_spaceKeyDown && _isThrow)
				{
					_isThrow = false;
					shootTNT();
				}
				
				_spaceKeyDown = false;
			}
		}
		
		public function update():void
		{
			if (_hero)
				_hero.update(); //update view
			
			if (_downKeyDown)
				arrowDown();
			
			if (_upKeyDown)
				arrowUp();
			
			if (_leftKeyDown || _rightKeyDown)
				_counterForce++;
			
			if (_counterForce > 2 && _leftKeyDown)
			{
				arrowLeft();
				_counterForce = 0;
			}
			else if (_counterForce > 2 && _rightKeyDown)
			{
				arrowRight();
				_counterForce = 0;
			}
			
			for each (var body:Body in _tnts)
			{
				body.userData.view.x = body.position.x;
				body.userData.view.y = body.position.y;
				body.userData.view.rotation = body.rotation * 180 / Math.PI;
			}
			
			if (_deleting.length > 0)
				boomTNT();
			
			if (_isThrow)
			{
				_counter++;
				
				if (_counter > 3)
				{
					_forceK += 1;
					_counter = 0;
					_arrow.setForce(int((_forceK - 1) * 100 / 15));
				}
				
				if (_forceK >= 15.5)
					_forceK = 1;
			}
		}
		
		private function addArrowDirection():void
		{
			_arrow = new Arrow(shootTNT, setForce);
			_hero.parent.addChildAt(_arrow, _hero.parent.getChildIndex(_hero) - 1);
			_arrow.mouseEnabled = false;
			
			_arrow.x = _hero.base.position.x;
			_arrow.y = _hero.top.position.y + 30;
			_arrow.rotation = -45;
			
			_hero.base.type = BodyType.STATIC;
		}
		
		private function addHeroSphere():void
		{
			const shape:Circle = new Circle(70);
			const body:Body = new Body(BodyType.STATIC);
			shape.sensorEnabled = true;
			shape.body = body;
			body.position.setxy(_arrow.x, _arrow.y);
			body.cbTypes.add(Model.BODY_BONUS_SPHERE);
			body.space = _space;
			
			_space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, Model.BODY_BONUS_TNT, Model.BODY_BONUS_SPHERE, sphereHandler));
		}
		
		private function sphereHandler(cb:InteractionCallback):void
		{
			const body:Body = cb.int1.castBody;
			body.userData.count++;
			
			if (body.userData.count == 2)
				startBoomTNT(body);
		}
		
		private function shootTNT():void
		{
			if (_progress.currentTNT == 0)
			{
				_hero.dispatchEvent(new GameEvent(GameEvent.HERO_TO_EXIT, true));
				
				_arrow.turnOff();
				
				if (_enemies.length == _numberEnemies)
					AchievementController.getInstance().addParam(AchievementController.BONUS_COMPLETE_LVL_EMPTY);
				
				removeHandlers();
				
				return;
			}
			
			_hero.states.changeState(States.THROW);
			_hero.view.addFrameCallback(5, throwTNT);
		}
		
		private function throwTNT():void
		{
			const shape:Circle = new Circle(6, null, Material.rubber(), Model.FILTER_TNT);
			shape.material.density = 2;
			shape.material.elasticity = 0.3;
			const body:Body = new Body();
			shape.body = body;
			body.position.setxy(_arrow.x, _arrow.y);
			body.cbTypes.add(Model.BODY_BONUS_TNT);
			body.userData.count = 0;
			
			var sprite:Sprite = new Sprite();
			_hero.parent.addChildAt(sprite, _hero.parent.getChildIndex(_hero) - 1);
			
			var clip:BitmapClip;
			clip = new BitmapClip(new <uint>[AnimationRes.TNT_FUSE], new <Array>[null], new Rectangle(0, 0, 32, 32));
			clip.play(AnimationRes.TNT_FUSE, false);
			sprite.addChild(clip);
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_FUSE);
			
			clip.x = -16;
			clip.y = -24;
			
			body.userData.clip = clip;
			body.userData.view = sprite;
			
			_tnts.push(body);
			body.space = _space;
			
			var force:Number = _forceK / 4.8;
			var kx:Number = force;
			var ky:Number = -force;
			
			if (force > 2.5)
				force = 2.5;
			
			if (_arrow.rotation > 0 && _arrow.rotation <= 90)
				kx = ky = force;
			
			if (_arrow.rotation < 0 && _arrow.rotation >= -90)
			{
				kx = force;
				ky = -force;
			}
			
			if (_arrow.rotation < -90)
				kx = ky = -force;
			
			if (_arrow.rotation > 90)
			{
				kx = -force;
				ky = force;
			}
			
			body.applyImpulse(Vec2.weak((_arrow.width - 40) * kx, (_arrow.height - 40) * ky));
			body.applyAngularImpulse(10);
			
			//Controller.juggler.add(clip);
			clip.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
			
			_progress.currentTNT--;
			_hero.dispatchEvent(new GameEvent(GameEvent.CHANGE_CAPACITY, true));
		}
		
		private function completeHandler(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, completeHandler);
			
			const view:BitmapClip = e.currentTarget as BitmapClip;
			//Controller.juggler.remove(view);
			
			for each (var body:Body in _tnts)
			{
				if (body.userData.clip == view)
					break;
			}
			startBoomTNT(body);
		}
		
		private function startBoomTNT(body:Body):void
		{
			if (_deleting.indexOf(body) == -1)
				_deleting.push(body);
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_BONUS_TNT);
			
			const boom:BitmapClip = new BitmapClip(new <uint>[AnimationRes.BONUS_BOOM], new <Array>[null], new Rectangle(0, 0, 128, 128));
			boom.play(AnimationRes.BONUS_BOOM);
			_hero.parent.addChild(boom);
			boom.x = body.position.x - 64;
			boom.y = body.position.y - 64;
			
			//Controller.juggler.add(boom);
			boom.addEventListener(Event.COMPLETE, completeBoomHandler, false, 0, true);
			
			const burst:PhysicalBurst = new PhysicalBurst(_game, _space, 2, PhysicalBurst.GROUND);
			burst.startBurst(body.position.x, body.position.y, 15, 6);
			
			checkTargetHit(body);
			checkGroundHit(body);
		}
		
		private function completeBoomHandler(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, completeBoomHandler);
			//Controller.juggler.remove(e.currentTarget as BitmapClip);
			
			_game.levelLayer.removeChild(e.currentTarget as BitmapClip);
			
			if (_enemies.length == 0)
			{
				_hero.dispatchEvent(new GameEvent(GameEvent.HERO_TO_EXIT, true));
				_arrow.turnOff();
				removeHandlers();
			}
		}
		
		private function checkGroundHit(tnt:Body):void
		{
			const radius:Number = 27;
			const curX:Number = tnt.position.x;
			const curY:Number = tnt.position.y;
			const points:Vector.<Point> = new <Point>[ //
				new Point(curX - radius, curY - radius), //
				new Point(curX, curY - radius), //
				new Point(curX + radius, curY - radius), //
				new Point(curX - radius, curY), //
				new Point(curX + radius, curY), //
				new Point(curX - radius, curY + radius), //
				new Point(curX, curY + radius), //
				new Point(curX + radius, curY + radius), //
				]; //
			
			var index:int;
			var tile:Tile;
			for each (var point:Point in points)
			{
				index = Functions.getIndexCell(point.x, point.y);
				if (index >= _cells.length || index < 0 || _cells[index].objects.length == 0)
					continue;
				
				if (Math.abs(curX - _cells[index].x) > 30)
					continue;
				
				tile = _cells[index];
				if (tile && tile.isContains(ImageRes.GROUND))
				{
					for each (var object:DisplayObject in tile.imgObjects)
					{
						if (object)
							object.parent.removeChild(object);
					}
					tile.getObject(0).parent.removeChild(tile.getObject(0));
					tile.staticBodies[ImageRes.GROUND].space = null;
					tile.clear();
					
					_data.currentObjectLevel.createNextToGroundImage(tile);
				}
			}
		}
		
		private function checkTargetHit(tnt:Body):void
		{
			var type:int = PhysicalBurst.GOLLUM;
			var dx2:Number;
			var dy2:Number;
			const radius2:Number = 2800; //---------------------------------------------------------------------radius
			for each (var enemy:Enemy in _enemies)
			{
				dx2 = (tnt.position.x - enemy.body.position.x) * (tnt.position.x - enemy.body.position.x);
				dy2 = (tnt.position.y - enemy.body.position.y) * (tnt.position.y - enemy.body.position.y);
				
				if (dx2 + dy2 < radius2)
				{
					_deletingEnemies.push(enemy);
					
					const clip:BitmapClip = new BitmapClip(new <uint>[AnimationRes.BLOOD], new <Array>[null], new Rectangle(0, 0, 80, 80));
					clip.play(AnimationRes.BLOOD, false);
					_game.levelLayer.addChildAt(clip, _game.levelLayer.getChildIndex(enemy) - 1);
					clip.x = enemy.body.position.x - 40;
					clip.y = enemy.body.position.y - 40;
					
					//Controller.juggler.add(clip);
					clip.addEventListener(Event.COMPLETE, bloodCompleteHandler, false, 0, true);
					
					if (enemy is Parrot)
						type = PhysicalBurst.PARROT;
					else if (enemy is Crab)
						type = PhysicalBurst.CRAB;
					
					const burst:PhysicalBurst = new PhysicalBurst(_game, _space, 2, type);
					burst.startBurst(enemy.body.position.x, enemy.body.position.y, 10, 9);
					
					if (_enemies.length == 1)
						AchievementController.getInstance().addParam(AchievementController.BONUS_ENEMY_DEATH); //all enemies on level
					
					if (_enemies.length == 1 && _progress.currentTNT == Behavior.tntToLevels[_progress.currentLevel] - _numberEnemies)
						AchievementController.getInstance().addParam(AchievementController.FIVE_BONUS_ENEMY_DEATH);
					
					if (_data.progress.currentStar < 3)
						_data.progress.currentStar++;
				}
			}
		}
		
		private function boomTNT():void
		{
			var index:int
			for each (var body:Body in _deleting)
			{
				index = _tnts.indexOf(body);
				_tnts.splice(index, 1);
				
				body.userData.view.removeChild(body.userData.clip);
				body.userData.view.parent.removeChild(body.userData.view);
				body.userData.view = null;
				body.userData.clip = null;
				
				body.space = null;
			}
			
			_deleting.length = 0;
			
			for each (var enemy:Enemy in _deletingEnemies)
			{
				index = _enemies.indexOf(enemy);
				_enemies.splice(index, 1);
				
				enemy.parent.removeChild(enemy);
				enemy.body.space = null;
				enemy.destroy();
			}
			
			_deletingEnemies.length = 0;
		}
		
		private function bloodCompleteHandler(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, bloodCompleteHandler);
			
			//Controller.juggler.remove(e.currentTarget as BitmapClip);
			_game.levelLayer.removeChild(e.currentTarget as BitmapClip);
		}
		
		private function arrowUp():void
		{
			_arrow.rotation -= 0.5;
			
			if (_arrow.rotation < -90)
				_arrow.rotation = -90;
		}
		
		private function arrowDown():void
		{
			_arrow.rotation += 0.5;
			
			if (_arrow.rotation > 0)
				_arrow.rotation = 0;
		}
		
		private function arrowLeft():void
		{
			_forceK--;
			
			if (_forceK < 1)
				_forceK = 1;
			
			_arrow.setForce(int((_forceK - 1) * 100 / 15));
		}
		
		private function setForce(force:Number):void
		{
			_forceK = force;
		}
		
		private function arrowRight():void
		{
			_forceK++;
			Statistics.bonusArrows++;
			
			if (_forceK > 15)
				_forceK = 15;
			
			_arrow.setForce(int((_forceK - 1) * 100 / 15));
		}
		
		private function removeHandlers():void
		{
			if (_stage)
			{
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
				_stage.removeEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
			}
		}
		
		public function destroy():void
		{
			removeHandlers();
			
			_stage = null;
			_space = null;
			_hero = null;
			_game = null;
			
			_arrow.destroy();
			
			_data = null;
			_cells = null;
			_enemies = null;
			_deletingEnemies.length = 0;
			_deletingEnemies = null;
			_arrow = null;
			_tnts.length = 0;
			_tnts = null;
			_deleting.length = 0;
			_deleting = null;
			
			_progress = null;
		}
	}

}