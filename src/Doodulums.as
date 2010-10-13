package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.cove.ape.APEngine;
	import org.cove.ape.Group;
	import org.cove.ape.APEVector;
	import org.cove.ape.VectorForce;
	
	import shapes.PaperConnector;
	import shapes.PaperPendulum;
	import shapes.PenConnector;
	import shapes.PenPendulum;
	import shapes.Pendulum;

	public class Doodulums extends Sprite {
	    private static const DAMPING:Number = 1.0000000002;
	    private static var application:DoodulumApp;
        private static var colorA:uint = 0x333333;
        private static var colorB:uint = 0x666666;
        private var _engineActive:Boolean = false;
        private var _activePendulum:Pendulum;
        private var _paperPendulum:PaperPendulum;
        private var _penPendulum:PenPendulum;
        private var _groups:Dictionary;
        private var _paper:Shape;
        private var _w:Number = 1200;
        private var _h:Number = 1000;
        private var _color:uint;
        
		public function Doodulums(app:DoodulumApp, w:Number, h:Number) {
		    _color = app.color.selectedColor;
		    application = app;
			APEngine.init();
			APEngine.container = this;
			createDoodelum(_w / 2, 20, _h * 0.6, colorA, colorB);
			APEngine.addForce(new VectorForce(false, 0, 5));
            addEventListener(Event.ENTER_FRAME, enterFrame);
            scaleToFit(w, h);
		}

        public function createDoodelum(x:uint, y:uint, length:uint, colorA:uint, colorB:uint) : void {
            var gA:Group = new Group();
            var gB:Group = new Group();
            //gA.addCollidable(gB);

            _paperPendulum = new PaperPendulum(this, x, y, length, colorA, colorB, null, length * 1.25, length * 0.9, application.color.selectedColor);
            _paper = (_paperPendulum.connector as PaperConnector).paper; 
            gA.addComposite(_paperPendulum);
            APEngine.addGroup(gA);
            APEngine.container.removeChild(_paper);
            APEngine.container.addChild(_paper);
            attachChaos(gB, _paperPendulum);            

            _penPendulum = new PenPendulum(this, x + x * 0.8, y, length, colorA, colorB, null, x * 0.8, _color)
            gB.addComposite(_penPendulum);
            attachChaos(gB, _penPendulum);            
            APEngine.addGroup(gB);

            activePendulum = _paperPendulum;
        }
        
        private function attachChaos(g:Group, p:Pendulum) : Pendulum {
            var c:Pendulum = new Pendulum(this, p.weight.px, p.weight.py, p.length / 2.2, p.colorA, p.colorB, p.weight);
            g.addComposite(c);
            return c;
        }
        
        private function detachChaos(g:Group, c:Pendulum) : void {
            g.removeComposite(c);
        }
        
        public function set activePendulum(pendulum:Pendulum) : void {
            if (_activePendulum != null && _activePendulum != pendulum) {
                _activePendulum.active = false;
            }
            _activePendulum = pendulum;
            _activePendulum.active = true;
            application.activePendulumChanged(_activePendulum);
        }
        
        public function get activePendulum() : Pendulum {
            return _activePendulum;
        }

		public function update(app:DoodulumApp) : void {
		    _activePendulum.mass = app.pendulumSize.value;
		    _penPendulum.color = app.color.selectedColor;
		    _paperPendulum.penColor = app.color.selectedColor;
            APEngine.paint();
		}
		
		public function toggleEngine() : void {
		    _engineActive = !_engineActive;
		    if (_engineActive) {
		        var pen:APEVector = penPosition();
                (_paperPendulum.connector as PaperConnector).moveTo(pen.x, pen.y);
		    }
		}
		
		public function get engineActive() : Boolean {
		    return _engineActive;
		}

        public function scaleToFit(w:Number, h:Number):void {
            var scale:Number = Math.min(w / _w, h / _h);;
            this.scaleX = scale;
            this.scaleY = scale;
        }
        
        private function penPosition() : APEVector {
            var _penCenter:APEVector = (_penPendulum.connector as PenConnector).pen;
            var global:Point = localToGlobal(new Point(_penCenter.x, _penCenter.y));
            var local:Point = _paper.globalToLocal(global);
            return new APEVector(local.x, local.y);
        }
        
        private function draw() : void {
            if (_engineActive) {
                APEngine.damping = DAMPING;
                var pen:APEVector = penPosition();
                _paperPendulum.draw(pen);
            }
            else {
                APEngine.damping = 0.0;             
            }
            APEngine.step();
            APEngine.paint();
        }

		private function enterFrame(event:Event):void {
		    for (var i:int = 0; i < 4; i++) {
		        draw();
		    }
		}
	}
}