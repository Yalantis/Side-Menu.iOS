//
//  Copyright © 2014 Yalantis
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at http://github.com/yalantis/Side-Menu.iOS
//

import UIKit

class CircularRevealTransitionAnimator: NSObject {
    fileprivate let duration = 0.5
    fileprivate let center: CGPoint

    init(center: CGPoint) {
        self.center = center
    }
}

extension CircularRevealTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        let frame = context.finalFrame(for: context.viewController(forKey: UITransitionContextViewControllerKey.to)!)

        let source = context.view(forKey: UITransitionContextViewKey.from)!
        let target = context.view(forKey: UITransitionContextViewKey.to)!

        target.frame = frame
        context.containerView.insertSubview(target, aboveSubview: source)

        let center = target.convert(self.center, from: nil)
        let radius: CGFloat = {
            let x = max(center.x, frame.width - center.x)
            let y = max(center.y, frame.height - center.y)
            return sqrt(x * x + y * y)
        }()

        let animator = CircularRevealAnimator(layer: target.layer, center: center, startRadius: 0, endRadius: radius)
        animator.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animator.duration = transitionDuration(using: context)
        animator.completion = {
            source.removeFromSuperview()
            context.completeTransition(true)
        }
        animator.start()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
