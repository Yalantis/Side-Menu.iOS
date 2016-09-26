//
//  Copyright © 2014 Yalantis
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at http://github.com/yalantis/Side-Menu.iOS
//

import QuartzCore

private func SquareAroundCircle(_ center: CGPoint, radius: CGFloat) -> CGRect {
    assert(0 <= radius, "radius must be a positive value")
    return CGRect(origin: center, size: CGSize.zero).insetBy(dx: -radius, dy: -radius)
}

class CircularRevealAnimator {
    
    var completion: (() -> Void)?

    fileprivate let layer: CALayer
    fileprivate let mask: CAShapeLayer
    fileprivate let animation: CABasicAnimation

    var duration: TimeInterval {
        get { return animation.duration }
        set(value) { animation.duration = value }
    }

    var timingFunction: CAMediaTimingFunction! {
        get { return animation.timingFunction }
        set(value) { animation.timingFunction = value }
    }

    init(layer: CALayer, center: CGPoint, startRadius: CGFloat, endRadius: CGFloat) {
        let startPath = CGPath(ellipseIn: SquareAroundCircle(center, radius: startRadius), transform: nil)
        let endPath = CGPath(ellipseIn: SquareAroundCircle(center, radius: endRadius), transform: nil)

        self.layer = layer

        mask = CAShapeLayer()
        mask.path = endPath

        animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath
        animation.toValue = endPath
        animation.delegate = AnimationDelegate {
            layer.mask = nil
            self.completion?()
            self.animation.delegate = nil
        }
    }

    func start() {
        layer.mask = mask
        mask.frame = layer.bounds
        mask.add(animation, forKey: "reveal")
    }
}
