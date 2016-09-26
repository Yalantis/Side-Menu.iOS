#Side Menu

[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](http://cocoapods.org/?q=YALSideMenu)
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/Yalantis/Side-Menu.iOS/blob/master/LICENSE)

Animated side menu with customizable UI. 
Made in <a href="https://yalantis.com/?utm_source=github"> Yalantis</a>.<br>
Check this <a href="https://dribbble.com/shots/1689922-Side-Menu-Animation?list=searches&tag=yalantis&offset=0">project on dribbble</a>.<br>
Check this <a href="https://www.behance.net/gallery/20411445/Mobile-Animations-Interactions ">project on Behance</a>.

<img src="https://d13yacurqjgara.cloudfront.net/users/125056/screenshots/1689922/events-menu_1-1-6.gif" />

##Requirements

- iOS 7.x / 8.x / 9.x (see installation instructions)
- Swift 3
- Xcode 8

##Installation

####Using [CocoaPods](http://cocoapods.org)

Simply add the following line to your Podfile:

```ruby
pod 'YALSideMenu', '~> 2.0'
```

*(CocoaPods v0.36 or later required. See [this blog post](http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/) for details.)*

####Manual Installation

> For application targets that do not support embedded frameworks, such as iOS 7, SideMenu can be integrated by including source files from the SideMenu folder directly, optionally wrapping the top-level types into `struct SideMenu` to simulate a namespace. Yes, this sucks.

1. Add SideMenu as a [submodule](http://git-scm.com/docs/git-submodule) by opening the Terminal, `cd`-ing into your top-level project directory, and entering the command `git submodule add https://github.com/yalantis/Side-Menu.iOS.git`
2. Open the `SideMenu` folder, and drag `SideMenu.xcodeproj` into the file navigator of your app project.
3. In Xcode, navigate to the target configuration window by clicking on the blue project icon, and selecting the application target under the "Targets" heading in the sidebar.
4. Ensure that the deployment target of `SideMenu.framework` matches that of the application target.
5. In the tab bar at the top of that window, open the "Build Phases" panel.
6. Expand the "Target Dependencies" group, and add `SideMenu.framework`.
7. Expand the "Link Binary With Libraries" group, and add `SideMenu.framework`
8. Click on the `+` button at the top left of the panel and select "New Copy Files Phase". Rename this new phase to "Copy Frameworks", set the "Destination" to "Frameworks", and add `SideMenu.framework`.

##Usage

1. Import `SideMenu` module

	```swift
	import SideMenu
	```

2. Adopt the `Menu` protocol in your menu view controller, e.g.

	```swift
	class MyFancyMenuViewController: UIViewController, Menu  {
		@IBOutlet var menuItems = [UIView] ()
	}
	```

3. Set `preferredContentSize` in menu view controller to specify the desired menu width
4. In content view controller store an animator, that will animate our menu.

    ```swift
    import SideMenu
    class ContentViewController: UIViewController  {
        var menuAnimator : MenuTransitionAnimator!
    }
    ```
5. Initialize an animator for presentation with parameters

    ```swift
    menuAnimator = MenuTransitionAnimator(mode: .presentation, shouldPassEventsOutsideMenu: false) { [unowned self] in
	    self.dismiss(animated: true, completion: nil)
    }
    ```
    If you want, for example, to dismiss your menu when a tap outside menu takes place, you should pass 'false' to 'shouldPassEventsOutsideMenu' flag and assign a 'tappedOutsideHandler'.In fact, you are free to do whatever you want when a tap outside menu occurs or, if you want to have access to your content view controller, just pass 'true' and assign 'tappedOutsideHandler' to nil.
6. Implement class of UIViewControllerTransitioningDelegate that will return our menuAnimator from method animationControllerForPresentedController and assign it to transitioningDelegate of menu view controller(Don't forget to set .Custom modal presentation style). To dismiss menu you should return MenuTransitionAnimator(mode: .Dismissal) from animationControllerForDismissedController method.

    ```swift
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	    let menu = segue.destination as! MenuViewController
	    menu.transitioningDelegate = self
	    menu.modalPresentationStyle = .custom
    }

    func animationController(forPresented presented: UIViewController, presenting _: UIViewController,
        source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return menuAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuTransitionAnimator(mode: .dismissal)
    }
    ```

## Let us know!

We’d be really happy if you sent us links to your projects where you use our component. Just send an email to github@yalantis.com And do let us know if you have any questions or suggestion regarding the animation. 

P.S. We’re going to publish more awesomeness wrapped in code and a tutorial on how to make UI for iOS (Android) better than better. Stay tuned!
    
## License

	The MIT License (MIT)

	Copyright © 2016 Yalantis

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
