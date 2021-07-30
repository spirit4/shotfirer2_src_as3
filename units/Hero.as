package units
{
	import caurina.transitions.Tweener;
	import data.AchievementController;
	import data.AnimationRes;
	import data.Model;
	import event.GameEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.shape.Circle;
	import nape.shape.Shape;
	import sound.SoundManager;
	import sound.SoundRes;
	import utils.BitmapClip;
	import utils.IUpdatable;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class Hero extends Sprite implements IUpdatable
	{
		private var _view:BitmapClip;
		private var _view48:BitmapClip;
		private var _view64:BitmapClip;
		private var _top:Body;
		private var _base:Body;
		
		private var _dusts:Vector.<BitmapClip> = new Vector.<BitmapClip>();
		private var _dustJump:BitmapClip;
		private var _isDust:Boolean = true;
		
		private var _topShape:Shape;
		private var _baseShape:Shape;
		private var _topSensor:Shape;
		private var _bottomSensor:Shape;
		
		private var _massTop:Number;
		private var _massBase:Number;
		
		private var _states:States;
		
		//private var _velocity:Vec2;
		
		public function Hero(top:Body, base:Body, topShape:Shape, baseShape:Shape, topSensor:Shape, bottomSensor:Shape)
		{
			mouseChildren = false;
			mouseEnabled = false;
			
			_top = top;
			_base = base;
			
			_topShape = topShape;
			_baseShape = baseShape;
			_topSensor = topSensor;
			_bottomSensor = bottomSensor;
			_massBase = _base.gravMass;
			_massTop = _top.gravMass;
			
			const animationTypes:Vector.<uint> = new <uint>[0, 1, 2, 3, 4, 5, 10, 12, 13, 32]; //AnimationRes.HERO
			const animationKeys:Vector.<Array> = new <Array>[null, null, null, AnimationRes.HERO_JUMP_UP, AnimationRes.HERO_JUMP_IDLE, AnimationRes.HERO_JUMP_DOWN, null, null, null, null]; //AnimationRes.HERO
			_view48 = _view = new BitmapClip(animationTypes, animationKeys, new Rectangle(0, 0, 48, 64), 30);
			_view64 = new BitmapClip(new <uint>[11,14,15], new <Array>[null, AnimationRes.HERO_SIT_TNT_IN, AnimationRes.HERO_SIT_TNT_OUT], new Rectangle(0, 0, 64, 64));
			addChild(_view48);
			addChild(_view64);
			_view64.visible = false;
			//Controller.juggler.add(_view, 1/30);
			
			_dustJump = new BitmapClip(new <uint>[AnimationRes.DUST_JUMP], new <Array>[null], new Rectangle(0, 0, 64, 32));
			_dustJump.visible = false;
			
			_states = new States(this);
			_states.changeState(States.IDLE_X);
			
			_top.userData.type = "topHero";
			_top.userData.bodyClass = this;
			_base.userData.type = "baseHero";
			_base.userData.bodyClass = this;
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			parent.addChild(_dustJump);
			
			createRadar();
		}
		
		private function createRadar():void
		{
			var circle:Circle;

			const radarState:Vector.<int> = Controller.model.progress.radarStates[Controller.model.progress.radarLevel];
			const coords:Array = [//left, top, right, bottom
				{x: -22, y: 31},//
				{x: 10, y: -1},//
				{x: 42, y: 31},//
				{x: 10, y: 61 },//
				{x: -54, y: 31},//
				{x: 10, y: -33},//
				{x: 74, y: 31},//
				{x: 10, y: 93},//
			];//
			
			for (var j:int = 0; j < coords.length; j++) 
			{
				if (radarState[j] == 1)
				{
					circle = new Circle(13, Vec2.weak(coords[j].x, coords[j].y), null, Model.FILTER_HERO);
					circle.sensorEnabled = true;
					_top.shapes.add(circle);
					circle.cbTypes.add(Model.BODY_HERO_RADAR);
					circle.cbTypes.add(Model.BODY_HERO_SHAPE_ALL);
					circle.material.density = 0;
					circle.userData.radarType = j;//1 and 5 are top
				}
			}
		}
		
		public function playView(type:int = -1, isLoop:Boolean = true, isContinue:Boolean = false, isReverse:Boolean = false):void
		{
			var nextView:BitmapClip;
			if (type != AnimationRes.HERO_CREEP_RIGHT && type != AnimationRes.HERO_SIT_TNT_RIGHT_IN && type != AnimationRes.HERO_SIT_TNT_RIGHT_OUT)
				nextView = _view48;
			else
				nextView = _view64;
			
			if (nextView != _view)
			{
				_view.visible = false;
				Controller.juggler.remove(_view);
				
				_view = nextView;
				_view.visible = true;
				Controller.juggler.add(_view, 1 / 30);
			}
			
			_view.play(type, isLoop, isContinue, isReverse);
			this.scaleX = _states.directionX;
			update();
			//trace("[playView]",type, this.scaleX)
		}
		
		public function stopView():void
		{
			_view.stop();
		}
		
		public function takeStairs():void
		{
			var body:Body;
			for (var i:int = 0; i < _top.arbiters.length; i++)
			{
				if (_top.arbiters.at(i).body2.cbTypes.has(Model.BODY_STAIRS))
					body = _top.arbiters.at(i).body2;
				else if (_top.arbiters.at(i).body1.cbTypes.has(Model.BODY_STAIRS))
					body = _top.arbiters.at(i).body1;
				
				if (body)
				{
					if (body.userData.type == 6)
					{
						_base.position.x = body.position.x - 5;
						_top.position.x = body.position.x - 5;
					}
					else if (body.userData.type == 106)//this only ratated stair
					{
						_base.position.x = body.position.x - 7;
						_top.position.x = body.position.x - 7;
					}
					return;
				}
			}
		}
		
		public function takeExit():void
		{
			var body:Body;
			for (var i:int = 0; i < _base.arbiters.length; i++)
			{
				if (_base.arbiters.at(i).body2.cbTypes.has(Model.BODY_EXIT))
					body = _base.arbiters.at(i).body2;
				else if (_base.arbiters.at(i).body1.cbTypes.has(Model.BODY_EXIT))
					body = _base.arbiters.at(i).body1;
				
				if (body)
				{
					//trace("takeExit", body.userData.index, Controller.model.progress.currentLevel, Controller.model.progress.exits[Controller.model.progress.currentLevel].indexOf(body.userData.index))
					if (Controller.model.progress.exits[Controller.model.progress.currentLevel].indexOf(body.userData.index) == -1)
						Controller.model.progress.exits[Controller.model.progress.currentLevel].push(body.userData.index);
						
					if (Controller.model.progress.exits[Controller.model.progress.currentLevel].length > 1)
						AchievementController.getInstance().addParam(AchievementController.GET_A_FEW_EXITS);
					
					_base.position.x = body.position.x - 1;
					_top.position.x = body.position.x - 1;
					return;
				}
			}
		}
		
		public function setNormalMass():void
		{
			_base.gravMass = _massBase;
			_top.gravMass = _massTop;
		}
		
		public function setNullMass():void
		{
			//trace("nullmass",_states.currentState)
			_base.gravMass = 0;
			_top.gravMass = 0;
		}
		
		public function setCreep():void
		{
			_topShape.sensorEnabled = true;
		}
		
		public function setNoCreep():void
		{
			_topShape.sensorEnabled = false;
		}
		
		//-------------------------------------------------------------------------------------------------------------
		public function update():void
		{
			if (_states.currentState != States.DEATH_0)
			{
				//trace("[Hero update]", this.scaleX)
				if (this.scaleX == 1)//_states.directionX == 1)
					this.x = _base.position.x - _view.width * 0.5;
				else
					this.x = _base.position.x + _view.width * 0.5;
					
				this.y = _base.position.y - _view.height + 15;
			}
			
			if (_states)
				_states.update();
			
			if (_isDust && _states.currentState == States.MOVE_X)
				checkDust();
			
			//checkVelocity();
		}
		
		//private function checkVelocity():void
		//{
			//if (_velocity)
			//{
				//_velocity.x = _base.velocity.x;
				//_velocity.y = _base.velocity.y;
				//
				//if (_velocity.x == 0 && _velocity.y >= 300)
				//{
					//stopCheckVelocity();
					////AchievementController.getInstance().addParam(AchievementController.UNDERMINE_TNT);
				//}
				//else if (_velocity.x != 0)
					//stopCheckVelocity();
			//}
		//}
		//
		//public function startCheckVelocity():void
		//{
			//_velocity = Vec2.weak();
		//}
		//
		//private function stopCheckVelocity():void
		//{
			//_velocity = null;
		//}
		
		private function checkDust():void
		{
			if (_dusts.length == 0 //
			|| (_states.directionX == 1 && _base.position.x - _dusts[0].x >= 32) //
			|| (_states.directionX == -1 && _base.position.x - _dusts[0].x <= 0)) //
				addDust();
		}
		
		private function addDust():void
		{
			const dust:BitmapClip = new BitmapClip(new <uint>[AnimationRes.DUST_RUN], new <Array>[null], new Rectangle(0, 0, 32, 32));
			parent.addChild(dust);
			dust.play(AnimationRes.DUST_RUN, false);
			const dx:Number = Math.random() * 6;
			dust.x = _base.position.x - 13 - dx;
			dust.y = _base.position.y - 20;
			
			_dusts.unshift(dust);
			//Controller.juggler.add(dust);
			dust.addEventListener(Event.COMPLETE, dustCompleteHandler);
		}
		
		private function dustCompleteHandler(e:Event):void
		{
			const dust:BitmapClip = e.currentTarget as BitmapClip;
			dust.removeEventListener(Event.COMPLETE, dustCompleteHandler);
			//Controller.juggler.remove(dust);
			
			dust.parent.removeChild(dust);
			_dusts.pop();
		}
		
		public function playDustJump():void
		{
			_dustJump.visible = true;
			_dustJump.play(AnimationRes.DUST_JUMP, false);
			_dustJump.x = _states.directionX == 1 ? this.x - 10 : this.x + 10;
			_dustJump.y = this.y + 27;
			_dustJump.scaleX = _states.directionX;
			
			_dustJump.addEventListener(Event.COMPLETE, dustJumpCompleteHandler);
		}
		
		public function dustJumpCompleteHandler(e:Event = null):void
		{
			_dustJump.removeEventListener(Event.COMPLETE, dustJumpCompleteHandler);
			
			_dustJump.visible = false;
		}
		
		public function playDeath():void
		{
			const clip:BitmapClip = new BitmapClip(new <uint>[AnimationRes.HERO_DEATH_RIGHT], new <Array>[null], new Rectangle(0, 0, 64, 64));
			//trace("playDeath",clip)
			addChildAt(clip, 0);
			clip.x -= 8;
			Tweener.addTween(clip, {alpha: 0, y: -70, time: 0.7, transition: "linear", onComplete: deathCompleteHandler});
			
			Tweener.addTween(_view, {alpha: 0, time: 0.1, transition: "linear"});
		}
		
		private function deathCompleteHandler():void
		{
			dispatchEvent(new GameEvent(GameEvent.HERO_DEAD, true));
		}
		
		public function get view():BitmapClip
		{
			return _view;
		}
		
		public function get top():Body
		{
			return _top;
		}
		
		public function get base():Body
		{
			return _base;
		}
		
		public function get bottomSensor():Shape
		{
			return _bottomSensor;
		}
		
		public function get topSensor():Shape
		{
			return _topSensor;
		}
		
		public function get baseShape():Shape
		{
			return _baseShape;
		}
		
		public function get topShape():Shape
		{
			return _topShape;
		}
		
		public function get states():States
		{
			return _states;
		}
		
		public function set isDust(value:Boolean):void
		{
			if (_states.currentState == States.MOVE_X)
			{
				if (_isDust && !value)
					SoundManager.getInstance().playLoop(SoundRes.LOOP_MOVE_SOLID);
				else if (!_isDust && value)
					SoundManager.getInstance().playLoop(SoundRes.LOOP_MOVE_SOFT);
			}
			
			_isDust = value;
			
			if (_states.currentState == States.JUMP_DOWN && _isDust)
				playDustJump();
		}
		
		public function get isDust():Boolean
		{
			return _isDust;
		}
		
		public function destroy():void
		{
			_states.destroy();
			_states = null;
			
			for each (var dust:BitmapClip in _dusts)
			{
				dust.removeEventListener(Event.COMPLETE, dustCompleteHandler);
			}
			
			_dusts.length = 0;
			_dusts = null;
			
			while (numChildren)
				removeChildAt(0);
			
			_dustJump.removeEventListener(Event.COMPLETE, dustJumpCompleteHandler);
			if (_dustJump.parent)
				_dustJump.parent.removeChild(_dustJump);
			
			_dustJump = null;
			
			//_velocity = null;
			
			_topShape = null;
			_baseShape = null;
			_topSensor = null;
			_bottomSensor = null;
			_view = null;
			_view48 = null;
			_view64 = null;
			_top = null;
			_base = null;
		}
	}

}