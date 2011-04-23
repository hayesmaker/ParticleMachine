package com.hayesmaker.particles 
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import mx.controls.Alert;
	
	/**
	 * ...
	 * @author Andy Hayes
	 */
	public class Emitter extends Sprite 
	{
		private var _canvasWidth:Number = 500;
		private var _canvasHeight:Number = 400;
		private var _bounds:Point;
		private var _particlesPerFrame:Number = 50;
		private var _isRunning:Boolean = false;
		private var _particles:Array = new Array();
		private var _gravity:Number = 0.5;
		private var _wind:Number = 0;
		private var _spray:Number = 10;
		private var _friction:Number = 1;
		private var _startX:Number = 250;
		private var _startY:Number = 200;
		[Bindable]
		public var actualParticles:uint = 0;
		private var _origin:Sprite;
		private var _particleColour:Number = 0x000000;
		private var _particleShape:String = ParticleShape.SQUARE;
		private var _particleSize:Number = 4;	
		private var _particlesShouldRotate:Boolean = false;
		private var _randomColourMode:Boolean = false;
		private var _particleBlurring:Boolean = false;
		private var _userBitmap:Bitmap = null;
		
		public function Emitter() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_origin = new Sprite();
			_origin.graphics.beginFill(0xff0000, 1);
			_origin.graphics.drawCircle(0, 0, 10);
			_origin.graphics.endFill();
			_origin.x = _startX;
			_origin.y = _startY;
			addChild(_origin);
			_origin.buttonMode = true;
			_origin.addEventListener(MouseEvent.MOUSE_DOWN, onEmitterMouseDown);
			_origin.addEventListener(MouseEvent.MOUSE_UP, onEmitterMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, onEmitterMouseUp);
			stage.addEventListener(Event.MOUSE_LEAVE, stageMouseUp);
		}
		
		private function stageMouseUp(e:Event):void 
		{
			_origin.stopDrag();
		}
		
		private function onEmitterMouseUp(e:MouseEvent):void 
		{
			_origin.stopDrag();
		}
		
		private function onEmitterMouseDown(e:MouseEvent):void 
		{
			_origin.startDrag(false, new Rectangle(0,0,_canvasWidth,_canvasHeight));
		}
	
		public function set isRunning(val:Boolean):void
		{
			_isRunning = val;
			if (val)
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			else
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function get isRunning():Boolean {
			return _isRunning;
		}
		
		public function set particlesPerFrame(value:Number):void 
		{
			removeAllChildren();
			actualParticles = 0;
			_particles = [];
			_particlesPerFrame = value;
		}
		
		private function removeAllChildren():void 
		{
			while (this.numChildren > 1) 
			this.removeChildAt(1);
		}
		
		public function get gravity():Number { return _gravity; }
		
		public function set gravity(value:Number):void 
		{
			_gravity = value/100;
		}
		
		public function get wind():Number { return _wind; }
		
		public function set wind(value:Number):void 
		{
			_wind = value/100;
		}
		
		public function get friction():Number { return _friction; }
		
		public function set friction(value:Number):void 
		{
			_friction = 1-value;
		}
		
		public function get startX():Number { return _startX; }
		
		public function set startX(value:Number):void 
		{
			_startX = value;
		}
		
		public function get startY():Number { return _startY; }
		
		public function set startY(value:Number):void 
		{
			_startY = value;
		}
		
		public function get canvasWidth():Number { return _canvasWidth; }
		
		public function set canvasWidth(value:Number):void 
		{
			_canvasWidth = value;
		}
		
		public function get canvasHeight():Number { return _canvasHeight; }
		
		public function set canvasHeight(value:Number):void 
		{
			_canvasHeight = value;
		}
		
		public function get spray():Number { return _spray; }
		
		public function set spray(value:Number):void 
		{
			_spray = value;
		}
		
		public function get bounds():Point { return _bounds; }
		
		public function set bounds(value:Point):void 
		{
			_bounds = value;
		}
		
		public function get particleColour():Number { return _particleColour; }
		
		public function set particleColour(value:Number):void 
		{
			_particleColour = value;
			particlesPerFrame = _particlesPerFrame;
		}
		
		public function get particleShape():String { return _particleShape; }
		
		public function set particleShape(value:String):void 
		{
			_particleShape = value;
			_userBitmap = null;
			particlesPerFrame = _particlesPerFrame;
		}
		
		public function get particleSize():Number { return _particleSize; }
		
		public function set particleSize(value:Number):void 
		{
			_particleSize = value;
			particlesPerFrame = _particlesPerFrame;
		}
		
		public function get particlesShouldRotate():Boolean { return _particlesShouldRotate; }
		
		public function set particlesShouldRotate(value:Boolean):void 
		{
			_particlesShouldRotate = value;
			particlesPerFrame = _particlesPerFrame;
		}
		
		public function get randomColourMode():Boolean { return _randomColourMode; }
		
		public function set randomColourMode(value:Boolean):void 
		{
			_randomColourMode = value;
			particlesPerFrame = _particlesPerFrame;
		}
		
		public function get particleBlurring():Boolean { return _particleBlurring; }
		
		public function set particleBlurring(value:Boolean):void 
		{
			_particleBlurring = value;
			particlesPerFrame = _particlesPerFrame;
		}
		
		public function get userBitmap():Bitmap { return _userBitmap; }
		
		public function set userBitmap(value:Bitmap):void 
		{
			_userBitmap = value;
			particlesPerFrame = _particlesPerFrame;
		}
		
		private function onEnterFrame(e:Event):void 
		{
			var particleShape:Sprite = new Sprite();
			if (_randomColourMode)
				_particleColour = Math.random() * 0xffffff;
			particleShape.graphics.beginFill(_particleColour, 1);
			switch(_particleShape) {
				case ParticleShape.SQUARE :
				particleShape.graphics.drawRect(-_particleSize/2, -_particleSize/2, _particleSize, _particleSize);
				break;
				case ParticleShape.CIRCLE :
				particleShape.graphics.drawCircle(0, 0, _particleSize);
				break;
			}
			particleShape.graphics.endFill();
			var particlesLen:uint = _particles.length;
			if (particlesLen < _particlesPerFrame)
			{
				var particle:Particle = new Particle(particleShape, particleBlurring);
				addChild(particle);
				if (_userBitmap) particle.setGraphic(new Bitmap(_userBitmap.bitmapData.clone()));
				actualParticles++;
				particle.gravity = _gravity;
				particle.wind = _wind;
				particle.friction = _friction;
				particle.alpha = Math.random();
				particle.xVelocity = Math.random() * _spray - _spray/2;
				particle.yVelocity = Math.random() * _spray - _spray/2;
				particle.x = _origin.x;
				particle.y = _origin.y;
				if (_particlesShouldRotate) particle.rotationVelocity = Math.random() * _spray - spray / 2;
				else particle.rotation = particle.rotationVelocity =  0;
				_particles.push(particle);
			}
			var i:uint;
			for (i = 0; i < particlesLen; i++)
			{
				var particleRef:Particle = _particles[i];
				particleRef.update();
				if (particleRef.x > _canvasWidth + particleRef.width 
				|| particleRef.x < -particleRef.width 
				|| particleRef.y > _canvasHeight + particleRef.height
				|| particleRef.y < - particleRef.height)
				{
					particleRef.gravity = _gravity;
					particleRef.wind = _wind;
					particleRef.friction = _friction;
					particleRef.alpha = Math.random();
					particleRef.xVelocity = Math.random() * _spray - _spray/2;
					particleRef.yVelocity = Math.random() * _spray - _spray / 2;
					if (_particlesShouldRotate) 
						particleRef.rotationVelocity = Math.random() * _spray - spray / 2;
					else 
						particleRef.rotation = particleRef.rotationVelocity = 0
					particleRef.x = _origin.x;
					particleRef.y = _origin.y;
				}
			}
		}
	}
}