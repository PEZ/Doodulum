package shapes {
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    
    import org.cove.ape.AbstractParticle;
    import org.cove.ape.Composite;
    import org.cove.ape.DragableCircleParticle;
    import org.cove.ape.RectangleParticle;
    import org.cove.ape.SpringConstraint;
    
	public class Pendulum extends Composite {
	    private static const MASS : Number = 10;
        protected var doodelums:Doodulums;        
        protected var x:Number;
        protected var y:Number;
	    public var weight:DragableCircleParticle;
	    public var connector:SpringConstraint;
        public var length:Number;
        public var colorA:uint;
        public var colorB:uint;

		public function Pendulum(_doodelums:Doodulums, _x:Number, _y:Number, _length:Number, _colorA:uint, _colorB:uint, _anchor:AbstractParticle) {
		    doodelums = _doodelums;
            x = _x;
            y = _y;
            length = _length;
		    colorA = _colorA;
		    colorB = _colorB;
            var anchor:AbstractParticle
            anchor = _anchor != null ? _anchor : createAnchor();
            weight = createWeight();
            connector = createConnector(anchor, weight);
            addParticle(weight);
            weight.sprite.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        }

        private function mouseDownHandler(evt:MouseEvent) : void {
            doodelums.activePendulum = this;
        }

        public function createConnector(anchor:AbstractParticle, weight:AbstractParticle) : SpringConstraint {
            var connector:SpringConstraint = new SpringConstraint(anchor, weight, 1);
            connector.setStyle(2, colorB);
            addConstraint(connector);
            return connector;
        }
        
        private function createAnchor() : RectangleParticle {
            var anchor:RectangleParticle = new RectangleParticle(x, y, 10, 10, 0, true);
            anchor.collidable = false;
            anchor.setStyle(1, colorA, 1, colorB);
            addParticle(anchor);
            return anchor;
        }

        private function createWeight() : DragableCircleParticle {
            var angle:Number = 90 * Math.PI / 180;
            weight = new DragableCircleParticle(x + Math.cos(angle) * length, y + Math.sin(angle) * length, size(MASS), false, MASS, 0.0, 0.0);
            weight.setStyle(1, colorA, 1, colorB);
            return weight;
        }               
        
        public function set active(v:Boolean) : void {
            weight.sprite.filters = (v ? [new GlowFilter(0x888888)] : []);
        }
        
        public function get mass() : Number {
            return weight.mass;
        }
        
        public function set mass(v:Number) : void {
            weight.mass = v;
            weight.radius = size(v);
        }
        
        private function size(mass:Number) : Number {
            return mass * 2;
        }
	}
}