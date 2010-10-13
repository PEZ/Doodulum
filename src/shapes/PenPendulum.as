package shapes
{
    import org.cove.ape.AbstractParticle;
    import org.cove.ape.SpringConstraint;

    public class PenPendulum extends Pendulum
    {
        private var penLength:Number;
        private var penColor:uint;
        private var _connector:PenConnector;
        
        public function PenPendulum(_doodelums:Doodulums, _x:Number, _y:Number, _length:Number, _colorA:uint, _colorB:uint, _anchor:AbstractParticle, _penLength:Number, _penColor:uint)
        {
            penLength = _penLength;
            penColor = _penColor;
            super(_doodelums, _x, _y, _length, _colorA, _colorB, _anchor);
        }

        public override function createConnector(anchor:AbstractParticle, weight:AbstractParticle) : SpringConstraint {
            _connector = new PenConnector(anchor, weight, penLength, penColor);;
            connector = _connector;
            connector.setStyle(2, colorB);
            addConstraint(connector);
            return connector;
        }
        
        public function set color(color:uint) : void {
            _connector.color = color;
        }
    }
}