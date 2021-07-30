package units
{
	import data.AchievementController;
	import data.AnimationRes;
	import data.ImageRes;
	import data.Model;
	import effects.PhysicalBurst;
	import effects.Shaker;
	import event.GameEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nape.phys.Body;
	import nape.shape.Shape;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.BitmapClip;
	import utils.Functions;
	import utils.Tile;
	import view.Game;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class BoxTNT extends Box
	{
		private var _enemies:Vector.<Enemy>;
		
		private var _cells:Vector.<Tile>;
		private var _callback:Function;
		
		public function BoxTNT(body:Body, sensor:Shape, boxes:Vector.<Box>, enemies:Vector.<Enemy>, levelLayer:Sprite, cells:Vector.<Tile>, callback:Function)
		{
			super(body, sensor, boxes, levelLayer);

			_enemies = enemies;
			_cells = cells;
			_callback = callback;
		}
		
		override protected function detonateHandler(e:GameEvent):void
		{
			e.currentTarget.removeEventListener(GameEvent.DETONATED_DYNAMITE, detonateHandler);
			e.currentTarget.removeEventListener(GameEvent.HERO_DEAD, tntKillHeroHandler);
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_BOX_GROUND_TNT);
			
			boom();
			_levelLayer.removeChild(this);
			_body.userData.view = null;
			checkTargetHit();
		}
		
		override public function touchHandler(body:Body, callbackKillHero:Function):void
		{
			//trace("test touch1", _isVelocityPhysicalBurst, _body.userData.view, _body.velocity.y);
			_callbackKillHero = callbackKillHero;
			
			if (_isVelocityPhysicalBurst && _body.userData.view && this.parent)
			{
				_body.userData.boomed = true;//TEST
				boom();
				//trace("[BOOM1]: ", _body.userData.index);
				_levelLayer.removeChild(this);
				_body.userData.view = null;
				
				checkTargetHit();
			}
		}
		
		//from other boxes
		public function checkTargetHit():void
		{
			var type:int = PhysicalBurst.GOLLUM;
			var dx2:Number;
			var dy2:Number;
			const radius2:Number = 2700;// 2304; //---------------------------------------------------------------------radius
			const queueToDie:Array = [];
			for each (var enemy:Enemy in _enemies)
			{
				dx2 = (_body.position.x - enemy.body.position.x) * (_body.position.x - enemy.body.position.x);
				dy2 = (_body.position.y - enemy.body.position.y) * (_body.position.y - enemy.body.position.y);
				
				if (dx2 + dy2 < radius2)
				{
					if (enemy is Parrot)
						type = PhysicalBurst.PARROT;
					else if (enemy is Crab)
						type = PhysicalBurst.CRAB;
					const burst:PhysicalBurst = new PhysicalBurst(_levelLayer.parent as Game, _body.space, 2, type);
					burst.startBurst(enemy.body.position.x, enemy.body.position.y, 10, 9);
					
					queueToDie.push(enemy.body);
				}
			}
			
			var ev:GameEvent;
			for each (var body:Body in queueToDie) 
			{
				ev = new GameEvent(GameEvent.ENEMY_DIED);
				ev.body = body;
				_levelLayer.dispatchEvent(ev);
			}
			
			var boxTNT:BoxTNT;
			for each (var box:Box in _boxes)
			{
				//trace("[BOOM20]: ", box == this, box.body.userData.index);
				if (box == this)
					continue;
				
				dx2 = (_body.position.x - box.body.position.x) * (_body.position.x - box.body.position.x);
				dy2 = (_body.position.y - box.body.position.y) * (_body.position.y - box.body.position.y);
				
				if (dx2 + dy2 < radius2)
				{
					//trace("[BOOM21]: ", box == this, box.body.userData.index);
					//trace("[BOOM22]: ", box.body.userData.index, box is BoxTNT, box.parent);
					if (box is BoxTNT && box.parent)
					{
						boxTNT = box as BoxTNT;
						boxTNT.boom();
						_levelLayer.removeChild(boxTNT);
						boxTNT.body.userData.view = null;
						
						boxTNT.checkTargetHit();
					}
					//else
						//box.boomHandler(); //for simple box maybe later
				}
			}
			
			const hero:Hero = Controller.model.hero;
			dx2 = (_body.position.x - hero.top.position.x) * (_body.position.x - hero.top.position.x);
			dy2 = (_body.position.y - hero.top.position.y) * (_body.position.y - hero.top.position.y);
			if (dx2 + dy2 < radius2)
				_callbackKillHero();
		}
		
		override public function update():void
		{
			if (_body.velocity.y > 210)
			{
				//trace("update touch velocity: ", _body.velocity.y);
				_isVelocityPhysicalBurst = true;
			}
			
			if (_body.userData.view)
			{
				//trace(_body.userData.view.x, _body.position.x, _body.userData.view.parent)
				//_body.userData.view.x = _body.position.x - 15;
				//_body.userData.view.y = _body.position.y - 16;
				this.x = body.position.x - Model.SIZE / 2 + 2;
				this.y = body.position.y - Model.SIZE / 2 - 1;
			}
		}
		
		//from other boxes
		public function boom():void
		{
			const game:Game = _levelLayer.parent as Game;
			const shaker:Shaker = new Shaker(game, game, 7, 14);
			
			_boom = new BitmapClip(new <uint>[AnimationRes.TNT_BOOM_BIG], new <Array>[null], new Rectangle(0, 0, 96, 96));
			_boom.play(AnimationRes.TNT_BOOM_BIG);
			_levelLayer.addChild(_boom);
			_boom.x = _body.position.x - 48;
			_boom.y = _body.position.y - 48;
			
			//Controller.juggler.add(_boom);
			_boom.addEventListener(Event.COMPLETE, boomCompleteHandler);
			
			//AchievementController.getInstance().addParam(AchievementController.BURST_BOX_TNT);
			
			checkTiles();
		}
		
		private function boomCompleteHandler(e:Event):void
		{
			if ((e.currentTarget as BitmapClip).parent)
				(e.currentTarget as BitmapClip).parent.removeChild(e.currentTarget as BitmapClip);
			
			//trace(e.currentTarget)
			e.currentTarget.removeEventListener(Event.COMPLETE, boomCompleteHandler);
			
			//Controller.juggler.remove(_boom);
			//_levelLayer.removeChild(_boom);
			_boom = null;
			
			//blow by another box
			if (!_boxes)
				return;
			
			_boxes.splice(_boxes.indexOf(this), 1);
			_body.userData.bodyClass = null;
			_body.userData.view = null;
			_body.space = null;
			
			destroy();
		}
		
		private function checkTiles():void
		{
			var tile:Tile;
			const index:int = Functions.getIndexCell(_boom.x + 48, _boom.y + 48);
			var indexes:Vector.<int> = new <int>[index - Model.WIDTH - 1, index - Model.WIDTH + 1, index - 1, index + 1, index + Model.WIDTH - 1, index + Model.WIDTH, index + Model.WIDTH + 1];
			
			if (index % Model.WIDTH == 0)
				indexes = new <int>[index - Model.WIDTH + 1, index + 1, index + Model.WIDTH, index + Model.WIDTH + 1];
			
			if ((index + 1) % Model.WIDTH == 0)
				indexes = new <int>[index - Model.WIDTH - 1, index - 1, index + Model.WIDTH - 1, index + Model.WIDTH];
			
			explodeBox(index);
			
			createParticles(indexes);
			
			const len:int = indexes.length;
			for (var i:int = 0; i < len; i++)
			{
				if (indexes[i] >= _cells.length)
					continue;
				
				tile = _cells[indexes[i]];
				if (tile.isContains(ImageRes.GROUND))
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
					
					_callback(tile);
				}
			}
			
			SoundManager.getInstance().playSFX(SoundRes.SFX_BOX_GROUND_TNT);
		}
		
		private function explodeBox(index:int):void
		{
			var burst:PhysicalBurst = new PhysicalBurst(_levelLayer.parent as Game, _body.space, 2, PhysicalBurst.BOX);
			burst.startBurst(_cells[index].x + 16, _cells[index].y + 16, 10, 6);
		}
		
		private function createParticles(indexes:Vector.<int>):void
		{
			var tile:Tile;
			var direction:int;
			var burst:PhysicalBurst;
			const game:Game = _levelLayer.parent as Game;
			
			direction = -1;
			tile = _cells[indexes[0]];
			burst = new PhysicalBurst(game, _body.space, direction, PhysicalBurst.GROUND);
			burst.startBurst(tile.x + 16, tile.y + 16, 6);
			
			tile = _cells[indexes[2]];
			burst = new PhysicalBurst(game, _body.space, direction, PhysicalBurst.GROUND);
			burst.startBurst(tile.x + 16, tile.y + 16, 6);
			
			direction = 1;
			tile = _cells[indexes[1]];
			burst = new PhysicalBurst(game, _body.space, direction, PhysicalBurst.GROUND);
			burst.startBurst(tile.x + 16, tile.y + 16, 6);
			
			tile = _cells[indexes[3]];
			burst = new PhysicalBurst(game, _body.space, direction, PhysicalBurst.GROUND);
			burst.startBurst(tile.x + 16, tile.y + 16, 6);
			
			direction = 0;
			for each (var index:int in indexes)
			{
				if (index + 4 > indexes[indexes.length - 1] && index < _cells.length)
				{
					tile = _cells[index];
					burst = new PhysicalBurst(game, _body.space, direction, PhysicalBurst.GROUND);
					burst.startBurst(tile.x + 16, tile.y + 16, 6);
				}
			}
		}
		
		override public function destroy():void
		{
			//trace("[destroy tnt box]", this);
			_enemies = null;
			_cells = null;
			_callback = null;
			super.destroy();
		}
	}

}