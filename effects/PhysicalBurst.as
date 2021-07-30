package effects
{
	import data.ImageRes;
	import data.Model;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.shape.Circle;
	import nape.space.Space;
	import utils.RandUtils;
	import view.Game;
	
	/**
	 * ...
	 * @author spirit2
	 */
	public class PhysicalBurst extends EventDispatcher
	{
		static public const GROUND:uint = 0;
		static public const GOLLUM:uint = 1;
		static public const PARROT:uint = 2;
		static public const CRAB:uint = 3;
		static public const HERO:uint = 4;
		static public const BOX:uint = 5;
		
		private var _game:Game;
		private var _space:Space;
		
		private var _partsForAdd:Vector.<Body>;
		private var _partsFlying:Vector.<Body>;
		private var _timesPartFlying:Vector.<uint>;
		private var _counterTime:uint = 0;
		private var _delay:uint = 2;
		private var _direction:int = 0;
		
		private var _type:uint;
		
		static private var _poolGrounds:Vector.<Body> = new Vector.<Body>();
		
		static private const RAD_TO_DEG:Number = 180 / Math.PI;
		private var pieceOfGround0:BitmapData = ImageRes.elementImages[ImageRes.EL_BOOM_PIECE_0];
		private var pieceOfGround1:BitmapData = ImageRes.elementImages[ImageRes.EL_BOOM_PIECE_1];
		private var pieceOfGround2:BitmapData = ImageRes.elementImages[ImageRes.EL_BOOM_PIECE_2];
		private var pieceOfGround3:BitmapData = ImageRes.elementImages[ImageRes.EL_BOOM_PIECE_3];
		
		public function PhysicalBurst(game:Game, space:Space, direction:int, type:uint)
		{
			if (_poolGrounds.length > 30)
				_poolGrounds.length = 30;
			
			_direction = direction;
			if (_direction == 2)
				_delay = 1;
			
			_space = space;
			_game = game;
			_type = type;
			_game.levelLayer.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		public function startBurst(x:Number, y:Number, number:int = 12, maxSize:Number = 8):void
		{
			//trace("_poolGrounds",number)
			
			_partsForAdd = new Vector.<Body>();
			_partsFlying = new Vector.<Body>();
			_timesPartFlying = new Vector.<uint>();
			
			var size:Number;
			var shape:Circle;
			var body:Body;
			var newX:Number;
			var newY:Number;
			
			var newNumber:int = int(Math.random() * 2 + number);
			
			if (_type == HERO)
				newNumber = 3;
			
			for (var i:int = 0; i < newNumber; i++)
			{
				size = RandUtils.getFloat(1, maxSize);
				
				if (_type == HERO)
					size = i== 2 ? 8 : 3;
				
				if (_type == GROUND && _poolGrounds.length > 0)
				{
					body = _poolGrounds.shift();
				}
				else
				{
					shape = new Circle(size, null, null, Model.FILTER_TNT_PARTICLES);
					body = new Body();
					shape.body = body;
				}
				
				newX = Math.random() * maxSize * 3 - maxSize + x;
				newY = Math.random() * maxSize * 3 - maxSize + y;
				body.position.setxy(newX, newY);
				
				_partsForAdd.push(body);
			}
			
			_game.activeBursts.push(this); //for update
		}
		
		public function update():void
		{
			var body:Body;
			var force:Number = (_type == GOLLUM) || (_type == PARROT) || (_type == CRAB) ? 30 : 70;
			var direct:Number;
			var vec:Vec2;
			
			if (_type == HERO)
				force = 20;
			
			if (_partsForAdd.length > 0 && _counterTime % _delay == 0)
			{
				body = _partsForAdd[0];
				body.space = _space;
				
				direct = Math.random() * force - force / 2;
				if (_direction == 0)
					vec = Vec2.weak(direct, -40);
				else if (_direction == -1)
					vec = Vec2.weak(40, direct);
				else if (_direction == 1)
					vec = Vec2.weak(-40, direct);
				else if (_direction == 2)
				{
					vec = Vec2.weak(direct, Math.random() * force - force / 2);
				}
				
				body.applyImpulse(vec);
				
				_partsFlying.push(body);
				_timesPartFlying.push(0);
				_partsForAdd.shift();
				
				addBitmap(body);
			}
			
			var image:Sprite;
			var pos:Vec2;
			var len:int = _timesPartFlying.length;
			for (var i:int = 0; i < len; i++)
			{
				_timesPartFlying[i]++;
				
				body = _partsFlying[i];
				image = body.userData.view as Sprite;
				pos = body.position;
				
				image.x = pos.x;
				image.y = pos.y;
				image.rotation = body.rotation * RAD_TO_DEG;
				
				if (_timesPartFlying[i] > 60)
				{
					_timesPartFlying.shift();
					len--;
					
					_game.levelLayer.removeChild(image);
					body.angularVel = 0;
					body.velocity.setxy(0, 0);
					body.space = null;
					
					if (_type == GROUND)
						_poolGrounds.push(_partsFlying.shift());
					else
					{
						body.userData.view = null;
						_partsFlying.shift();
					}
					
					break;
				}
			}
			
			if (_partsFlying.length == 0)
				destroy();
			
			_counterTime++;
		}
		
		private function addBitmap(body:Body):void
		{
			var radius:Number = (body.shapes.at(0) as Circle).radius;
			//trace("[addBitmap]",radius, body.userData.view);
			var bitmap:Bitmap;
			var sprite:Sprite;
			if (!body.userData.view)
				sprite = new Sprite(); //for rotation
			else
				sprite = body.userData.view;
			
			if (_type == GROUND)
			{
				if (!body.userData.view) //not from pool
				{
					if (radius > 5)
						bitmap = new Bitmap(pieceOfGround0);
					else if (radius <= 5 && radius > 4)
						bitmap = new Bitmap(pieceOfGround1);
					else if (radius <= 4 && radius > 3)
						bitmap = new Bitmap(pieceOfGround2);
					else if (radius <= 3)
						bitmap = new Bitmap(pieceOfGround3);
				}
			}
			else if ((_type == GOLLUM) || (_type == PARROT) || (_type == CRAB))
			{
				if (radius > 7)
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_MEAT_5]);
				else if (radius <= 7 && radius > 6)
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_MEAT_4]);
				else if (radius <= 6 && radius > 5)
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_MEAT_3]);
				else if (radius <= 5 && radius > 4)
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_MEAT_2]);
				else if (radius <= 4 && radius > 3)
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_MEAT_1]);
				else if (radius <= 3)
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_MEAT_0]);
			}
			else if (_type == HERO)
			{
				if (radius > 4)
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_HERO_MEAT_2]);
				else
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_HERO_MEAT_0]);

			}
			else if (_type == BOX)
			{
				if (radius > 5)
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_BOX_0]);
				else if (radius <= 5 && radius > 4)
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_BOX_1]);
				else if (radius <= 4 && radius > 2.5)
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_BOX_2]);
				else if (radius <= 2.5)
					bitmap = new Bitmap(ImageRes.elementImages[ImageRes.EL_BOX_3]);
			}
			
			body.userData.view = sprite;
			
			if (bitmap)
			{
				sprite.addChild(bitmap);
				bitmap.x = -bitmap.width / 2;
				bitmap.y = -bitmap.height / 2;
			}
			
			_game.levelLayer.addChild(sprite);
			sprite.x = body.position.x;
			sprite.y = body.position.y;
			sprite.rotation = body.rotation * RAD_TO_DEG;
		}
		
		private function destroy(e:Event = null):void
		{
			_game.levelLayer.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_game.activeBursts[_game.activeBursts.indexOf(this)] = null;
			
			_game = null;
			_space = null;
			_partsForAdd.length = 0;
			_partsFlying.length = 0;
			_timesPartFlying.length = 0;
			_partsForAdd = null;
			_partsFlying = null;
			_timesPartFlying = null;
			
			pieceOfGround0 = null;
			pieceOfGround1 = null;
			pieceOfGround2 = null;
			pieceOfGround3 = null;
			
			if (_type == HERO && !e)
				dispatchEvent(new Event(Event.COMPLETE));
		}
	}

}