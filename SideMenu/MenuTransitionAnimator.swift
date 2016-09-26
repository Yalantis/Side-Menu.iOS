//
//  Copyright © 2014 Yalantis
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at http://github.com/yalantis/Side-Menu.iOS
//

import UIKit

open class MenuTransitionAnimator: NSObject {
    //MARK: Public properties
    @objc public enum Mode : Int { case presentation, dismissal }
    
    //MARK: Private properties
    fileprivate let duration = 0.5
    fileprivate let angle: CGFloat = 2
    fileprivate var mode: Mode
    fileprivate var shouldPassEventsOutsideMenu : Bool
    fileprivate var tappedOutsideHandler : (() -> Void)?
    
    //MARK: Public methods
    public init(mode: Mode, shouldPassEventsOutsideMenu: Bool = true, tappedOutsideHandler: (() -> Void)? = nil) {
        self.mode = mode
        self.tappedOutsideHandler = tappedOutsideHandler
        self.shouldPassEventsOutsideMenu = shouldPassEventsOutsideMenu
        super.init()
    }
    
    //MARK: Private methods
    fileprivate func animatePresentation(_ context: UIViewControllerContextTransitioning) {
        let host = context.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let menu = context.viewController(forKey: UITransitionContextViewControllerKey.to)! 

        let view = menu.view
        view?.frame = CGRect(x: 0, y: 0, width: menu.preferredContentSize.width, height: host.view.bounds.height)
        view?.autoresizingMask = [.flexibleRightMargin, .flexibleHeight]
        view?.translatesAutoresizingMaskIntoConstraints = true
        
        if shouldPassEventsOutsideMenu == true {
            context.containerView.frame = (view?.frame)!
        } else {
            let tapButton = UIButton(frame: host.view.frame)
            tapButton.backgroundColor = UIColor.clear
            tapButton.addTarget(self, action: #selector(menuTappedOutside), for: .touchUpInside)
            context.containerView.addSubview(tapButton)
        }
        
        context.containerView.addSubview(view!)
        
        animateMenu(menu as! Menu, startAngle: angle, endAngle: 0) {
            context.completeTransition(true)
        }
    }
    
    @objc fileprivate func menuTappedOutside(_ sender: UIButton) {
        if tappedOutsideHandler != nil {
            tappedOutsideHandler!()
        }
    }
    
    fileprivate func animateDismissal(_ context: UIViewControllerContextTransitioning) {
        if let menu = context.viewController(forKey: UITransitionContextViewControllerKey.from) {
            animateMenu(menu as! Menu, startAngle: 0, endAngle: angle) {
                menu.view.removeFromSuperview()
                context.completeTransition(true)
            }
        }
    }

    fileprivate func animateMenu(_ menu: Menu, startAngle: CGFloat, endAngle: CGFloat, completion: @escaping () -> Void) {
        let animator = MenuItemsAnimator(views: menu.menuItems, startAngle: startAngle, endAngle: endAngle)
        animator.duration = duration
        animator.completion = completion
        animator.start()
    }
}
//MARK: Extensions
extension MenuTransitionAnimator: UIViewControllerAnimatedTransitioning {
    public func animateTransition(using context: UIViewControllerContextTransitioning) {
        switch mode {
            case .presentation:
                animatePresentation(context)
            case .dismissal:
                animateDismissal(context)
        }
    }

    public func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
