//
//  Copyright © 2014 Yalantis
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at http://github.com/yalantis/Side-Menu.iOS
//

import UIKit

class MenuTransitionAnimator: NSObject {
    enum Mode { case Presentation, Dismissal }

    private let mode: Mode
    private let duration = 0.5
    private let angle: CGFloat = 2

    init(_ mode: Mode) {
        self.mode = mode
    }

    private func animatePresentation(context: UIViewControllerContextTransitioning) {
        let host = context.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let menu = context.viewControllerForKey(UITransitionContextToViewControllerKey)!

        let view = menu.view
        view.frame = CGRectMake(0, 0, menu.preferredContentSize.width, host.view.bounds.height)
        view.autoresizingMask = [.FlexibleRightMargin, .FlexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        context.containerView()!.addSubview(view)

        animateMenu(menu as! Menu, startAngle: angle, endAngle: 0) {
            context.completeTransition(true)
        }
    }

    private func animateDismissal(context: UIViewControllerContextTransitioning) {
        if let menu = context.viewControllerForKey(UITransitionContextFromViewControllerKey) {
            animateMenu(menu as! Menu, startAngle: 0, endAngle: angle) {
                menu.view.removeFromSuperview()
                context.completeTransition(true)
            }
        }
    }

    private func animateMenu(menu: Menu, startAngle: CGFloat, endAngle: CGFloat, completion: () -> Void) {
        let animator = MenuItemsAnimator(views: menu.menuItems, startAngle: startAngle, endAngle: endAngle)
        animator.duration = duration
        animator.completion = completion
        animator.start()
    }
}

extension MenuTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func animateTransition(context: UIViewControllerContextTransitioning) {
        switch mode {
            case .Presentation:
                animatePresentation(context)
            case .Dismissal:
                animateDismissal(context)
        }
    }

    func transitionDuration(context: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}