Pod::Spec.new do |s|
  s.name             = 'ZYGCDTimer'
  s.version          = '0.1.0'
  s.summary          = "A timer that doesn't retain the target and supports being used with GCD queues"
  s.homepage         = 'https://github.com/ripperhe/ZYGCDTimer'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ripperhe' => 'ripperhe@qq.com' }
  s.source           = { :git => 'https://github.com/ripperhe/ZYGCDTimer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'ZYGCDTimer/**/*'

  # s.resource_bundles = {
  #   'ZYGCDTimer' => ['ZYGCDTimer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
