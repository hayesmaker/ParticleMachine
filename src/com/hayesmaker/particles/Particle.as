package com.hayesmaker.particles 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	
	/**
	 * ...
	 * @author Andy Hayes
	 */
	public class Particle extends Sprite 
	{
		private var _xVelocity:Number;
		private var _yVelocity:Number;
		private var _gravity:Number;
		private var _friction:Number;
		private var _wind:Number;
		private var _graphic:DisplayObject;
		private var _rotationVelocity:Number = 0;
		private var _blur:BlurFilter;
		
		public function Particle(graphic:Sprite, shouldBlur:Boolean = false) 
		{
			
			//this.cacheAsBitmap = true;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			_graphic = graphic;
			this.addChild(graphic);
			if (shouldBlur) {
				_blur = new BlurFilter(6,6);
				graphic.filters = [_blur];
			}
		
		}
		
		public function setGraphic(newGraphic:DisplayObject):void 
		{
			if (_graphic) removeChild(_graphic);
			_graphic = newGraphic;
			addChild(_graphic);
			_graphic.x = -_graphic.width / 2;
			_graphic.y = -_graphic.height / 2;
			if (_blur) _graphic.filters = [_blur];
		}
		
		public function update():void 
		{
			_xVelocity *= _friction;
			_yVelocity *= _friction;
			_yVelocity += _gravity;
			_xVelocity += _wind;
			this.x += _xVelocity;
			this.y += _yVelocity;
			if (_rotationVelocity!=0) this.rotation += _rotationVelocity;
		}
		
		public function get gravity():Number { return _gravity; }
		
		public function set gravity(value:Number):void 
		{
			_gravity = value;
		}
		
		public function get friction():Number { return _friction; }
		
		public function set friction(value:Number):void 
		{
			_friction = value;
		}
		
		public function get wind():Number { return _wind; }
		
		public function set wind(value:Number):void 
		{
			_wind = value;
		}
		
		public function get xVelocity():Number { return _xVelocity; }
		
		public function set xVelocity(value:Number):void 
		{
			_xVelocity = value;
		}
		
		public function get yVelocity():Number { return _yVelocity; }
		
		public function set yVelocity(value:Number):void 
		{
			_yVelocity = value;
		}
		
		public function get rotationVelocity():Number { return _rotationVelocity; }
		
		public function set rotationVelocity(value:Number):void 
		{
			_rotationVelocity = value;
		}
	}
}