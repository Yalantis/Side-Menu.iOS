Pod::Spec.new do |spec|

  spec.name         = 'YALSideMenu'
  spec.version      = '1.2.1'
  spec.summary      = 'Animated side menu with customizable UI'
  spec.screenshot   = 'https://d13yacurqjgara.cloudfront.net/users/125056/screenshots/1689922/events-menu_1-1-6.gif'

  spec.homepage     = 'https://github.com/Yalantis/Side-Menu.iOS'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = 'Yalantis'
  spec.social_media_url   = 'https://twitter.com/yalantis'

  spec.platform     = :ios, '8.0'
  spec.ios.deployment_target = '8.0'

  spec.source       = { :git => 'https://github.com/Yalantis/Side-Menu.iOS.git', :tag => '1.2.1' }
  spec.source_files = 'SideMenu/*.swift'
  spec.module_name  = 'SideMenu'
  spec.requires_arc = true

end
