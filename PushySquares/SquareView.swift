import UIKit
import SwiftyUtils
import DynamicColor
import SwiftyAnimate

@IBDesignable
class SquareView: UIView {
    static var animDuration: TimeInterval = 0.5
    
    override func draw(_ rect: CGRect) {
        let strokeWidth = self.width / 8
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.width - strokeWidth / 2, y: 0))
        path.addLine(to: CGPoint(x: self.width - strokeWidth / 2, y: self.height - strokeWidth / 2))
        path.addLine(to: CGPoint(x: 0, y: self.height - strokeWidth / 2))
        self.backgroundColor?.darker().setStroke()
        path.lineWidth = strokeWidth
        path.stroke()
    }
    
    var moveUp: Animate {
        return transform(duration: SquareView.animDuration, transforms: [
            .move(x: 0, y: -self.height * 1.125)
            ])
    }
    
    var moveDown: Animate {
        return transform(duration: SquareView.animDuration, transforms: [
            .move(x: 0, y: self.height * 1.125)
            ])
    }
    
    var moveLeft: Animate {
        return transform(duration: SquareView.animDuration, transforms: [
            .move(x: -self.width * 1.125, y: 0)
            ])
    }
    
    var moveRight: Animate {
        return transform(duration: SquareView.animDuration, transforms: [
            .move(x: self.width * 1.125, y: 0)
            ])
    }
    
    var destroyed: Animate {
        return transform(duration: SquareView.animDuration, transforms: [
            .scale(x: 0, y: 0)
            ]).do { [weak self] in
                self?.removeFromSuperview()
        }
    }
    
    var appear: Animate {
        return Animate(duration: SquareView.animDuration) {
            [weak self] in
            self?.alpha = 1
        }
    }
}
