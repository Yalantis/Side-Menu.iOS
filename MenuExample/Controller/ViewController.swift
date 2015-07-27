//
//  Copyright © 2014 Yalantis
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at http://github.com/yalantis/Side-Menu.iOS
//

import UIKit

class ViewController: UIViewController {
    private var selectedIndex = 0
    private var transitionPoint: CGPoint!
    private var contentType: ContentType = .Music
    private var navigator: UINavigationController!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier, segue.destinationViewController) {
            case (.Some("presentMenu"), let menu as MenuViewController):
                menu.selectedItem = selectedIndex
                menu.delegate = self
            case (.Some("embedNavigator"), let navigator as UINavigationController):
                self.navigator = navigator
                self.navigator.delegate = self
            default:
                super.prepareForSegue(segue, sender: sender)
        }
    }
}

extension ViewController: MenuViewControllerDelegate {
    func menu(_: MenuViewController, didSelectItemAtIndex index: Int, atPoint point: CGPoint) {
        contentType = !contentType
        transitionPoint = point
        selectedIndex = index

        let content = storyboard!.instantiateViewControllerWithIdentifier("Content") as! ContentViewController
        content.type = contentType
        self.navigator.setViewControllers([content], animated: true)

        dispatch_async(dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func menuDidCancel(_: MenuViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(_: UINavigationController, animationControllerForOperation _: UINavigationControllerOperation,
        fromViewController _: UIViewController, toViewController _: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return CircularRevealTransitionAnimator(center: transitionPoint)
    }
}

