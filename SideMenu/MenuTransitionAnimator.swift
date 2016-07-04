//
//  Copyright © 2014 Yalantis
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at http://github.com/yalantis/Side-Menu.iOS
//

import UIKit

public class MenuTransitionAnimator: NSObject {
    //MARK: Public properties
    @objc public enum Mode : Int { case Presentation, Dismissal }
    
    //MARK: Private properties
    private let duration = 0.5
    private let angle: CGFloat = 2
    private var mode: Mode
    private var shouldPassEventsOutsideMenu : Bool
    private var tappedOutsideHandler : (() -> Void)?
    
    //MARK: Public methods
    public init(mode: Mode, shouldPassEventsOutsideMenu: Bool = true, tappedOutsideHandler: (() -> Void)? = nil) {
        self.mode = mode
        self.tappedOutsideHandler = tappedOutsideHandler
        self.shouldPassEventsOutsideMenu = shouldPassEventsOutsideMenu
        super.init()
    }
    
    //MARK: Private methods
    private func animatePresentation(context: UIViewControllerContextTransitioning) {
        let host = context.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let menu = context.viewControllerForKey(UITransitionContextToViewControllerKey)! 

        let view = menu.view
        view.frame = CGRectMake(0, 0, menu.preferredContentSize.width, host.view.bounds.height)
        view.autoresizingMask = [.FlexibleRightMargin, .FlexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        if shouldPassEventsOutsideMenu == true {
            context.containerView()!.frame = view.frame
        } else {
            let tapButton = UIButton(frame: host.view.frame)
            tapButton.backgroundColor = UIColor.clearColor()
            tapButton.addTarget(self, action: #selector(menuTappedOutside), forControlEvents: .TouchUpInside)
            context.containerView()!.addSubview(tapButton)
        }
        
        context.containerView()!.addSubview(view)
        
        animateMenu(menu as! Menu, startAngle: angle, endAngle: 0) {
            context.completeTransition(true)
        }
    }
    
    @objc private func menuTappedOutside(sender: UIButton) {
        if tappedOutsideHandler != nil {
            tappedOutsideHandler!()
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
//MARK: Extensions
extension MenuTransitionAnimator: UIViewControllerAnimatedTransitioning {
    public func animateTransition(context: UIViewControllerContextTransitioning) {
        switch mode {
            case .Presentation:
                animatePresentation(context)
            case .Dismissal:
                animateDismissal(context)
        }
    }

    public func transitionDuration(context: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}
