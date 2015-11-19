//
//  Copyright © 2014 Yalantis
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at http://github.com/yalantis/Side-Menu.iOS
//

import UIKit

class CircularRevealTransitionAnimator: NSObject {
    private let duration = 0.5
    private let center: CGPoint

    init(center: CGPoint) {
        self.center = center
    }
}

extension CircularRevealTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func animateTransition(context: UIViewControllerContextTransitioning) {
        let frame = context.finalFrameForViewController(context.viewControllerForKey(UITransitionContextToViewControllerKey)!)

        let source = context.viewForKey(UITransitionContextFromViewKey)!
        let target = context.viewForKey(UITransitionContextToViewKey)!

        target.frame = frame
        context.containerView()!.insertSubview(target, aboveSubview: source)

        let center = target.convertPoint(self.center, fromView: nil)
        let radius: CGFloat = {
            let x = max(center.x, frame.width - center.x)
            let y = max(center.y, frame.height - center.y)
            return sqrt(x * x + y * y)
        }()

        let animator = CircularRevealAnimator(layer: target.layer, center: center, startRadius: 0, endRadius: radius)
        animator.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animator.duration = transitionDuration(context)
        animator.completion = {
            source.removeFromSuperview()
            context.completeTransition(true)
        }
        animator.start()
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}