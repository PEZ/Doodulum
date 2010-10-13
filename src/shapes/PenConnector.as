package shapes
{
    import org.cove.ape.AbstractParticle;
    import org.cove.ape.SpringConstraint;
    import org.cove.ape.APEVector;

    public class PenConnector extends SpringConstraint
    {
        private var _penLength:Number;
        private var _color:uint;
        
        public function PenConnector(p1:AbstractParticle, p2:AbstractParticle, penLength:Number, penColor:uint)
        {
            _penLength = penLength;
            _color = penColor;
            super(p1, p2, 1, false, 1, 1, false);
        }
        
        public function get pen() : APEVector {
            var a:Number = (angle - 90) * Math.PI / 180;
            return new APEVector(center.x + Math.cos(a) * _penLength, center.y + Math.sin(a) * _penLength);
        }

        public override function paint():void {
            super.paint();
            if (displayObject == null) {
                sprite.graphics.moveTo(center.x, center.y);
                sprite.graphics.lineTo(pen.x, pen.y);
                _paintPen();
            }   
        }

        private function _paintPen() : void {
            sprite.graphics.lineStyle(1, _color);
            sprite.graphics.drawCircle(pen.x, pen.y, 1);            
            sprite.graphics.drawCircle(pen.x, pen.y, 2);            
            sprite.graphics.drawCircle(pen.x, pen.y, 3);            
        }
        
        public function set color(c:uint) : void {
            _color = c;
        } 
    }
}