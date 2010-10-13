package shapes {
    import flash.display.Shape;
    
    import org.cove.ape.APEngine;
    import org.cove.ape.AbstractParticle;
    import org.cove.ape.SpringConstraint;

    public class PaperConnector extends SpringConstraint {
        public var currentX:Number;
        public var currentY:Number;
        private var _paperWidth:Number;
        private var _paperHeight:Number;
        private var _paper:Shape;
        
        public function PaperConnector(p1:AbstractParticle, p2:AbstractParticle, paperWidth: Number, paperHeight:Number, _penColor:uint) {
            _paperWidth = paperWidth;
            _paperHeight = paperHeight;
            createPaper(_penColor);
            super(p1, p2, 1, false, 1, 1, false);
        }

        private function createPaper(_penColor:uint) : void {
            _paper = new Shape();
            _paper.graphics.lineStyle(1, 0);
            _paper.graphics.beginFill(0xFFFFFF);
            _paper.graphics.drawRect(-_paperHeight / 2, -_paperWidth / 2, _paperHeight, _paperWidth);
            _paper.graphics.endFill();
            penColor = _penColor;
            APEngine.container.addChild(_paper);
        }

        private function setPaperPosition() : void {            
            _paper.x = center.x;
            _paper.y = center.y;
            _paper.rotation = angle;
        }

        private function inBounds(x:Number, y:Number):Boolean {
            return _paper.getBounds(_paper).contains(x, y);
        }
        
        public function lineTo(x:Number, y:Number):void {
            if (inBounds(currentX, currentY) && inBounds(x, y)) {
                _paper.graphics.lineTo(x, y);
                currentX = x;
                currentY = y;
            }
            else {
                moveTo(x, y);
            }            
        }
        public function set penColor(c:uint) : void {
            _paper.graphics.lineStyle(0.5, c);
        }

        public function moveTo(x:Number, y:Number):void {
            _paper.graphics.moveTo(x, y);
            currentX = x;
            currentY = y;
        }

        public function get paper() : Shape {
            return _paper;
        }

        public override function paint():void {
            super.paint();
            setPaperPosition();
        }
    }
    
}