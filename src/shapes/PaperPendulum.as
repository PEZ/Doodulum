package shapes
{
    import org.cove.ape.AbstractParticle;
    import org.cove.ape.SpringConstraint;
    import org.cove.ape.APEVector;

    public class PaperPendulum extends Pendulum
    {
        private var paperWidth:Number;
        private var paperHeight:Number;
        private var _penColor:uint;
        private var _connector:PaperConnector;
        private var _hv:Number;
        private var _wv:Number;
        
        public function PaperPendulum(_doodelums:Doodulums, _x:Number, _y:Number, _length:Number, _colorA:uint, _colorB:uint, _anchor:AbstractParticle,
            _paperWidth:Number, _paperHeight:Number, penColor:uint) {
            paperWidth = _paperWidth;
            paperHeight = _paperHeight;
            _penColor = penColor;
            super(_doodelums, _x, _y, _length, _colorA, _colorB, _anchor);
        }

        public override function createConnector(anchor:AbstractParticle, weight:AbstractParticle) : SpringConstraint {
            _connector = new PaperConnector(anchor, weight, paperWidth, paperHeight, _penColor);
            _connector.setStyle(2, colorB);
            addConstraint(_connector);
            return _connector;
        }
        
        public function draw(pen:APEVector) : void {
            var c:PaperConnector = connector as PaperConnector;
            var lastWV:Number = _wv;
            var lastHV:Number = _hv;
            _wv = pen.x - c.currentX;
            _hv = pen.y - c.currentY;
            
            c.lineTo(pen.x, pen.y);
        }
        
        public function set penColor(c:uint) : void {
            _penColor = c;
            _connector.penColor = c;
        }
    }
}