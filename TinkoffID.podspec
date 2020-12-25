Pod::Spec.new do |s|
  s.name             = 'TinkoffID'
  s.summary          = 'TinkoffID iOS SDK'
  s.version          = '0.0.1'
  s.author           = { 'Дмитрий Оверчук' => 'd.overchuk@tinkoff.ru' }
  s.homepage         = 'https://github.com/tinkoff-mobile-tech/TinkoffID'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.source           = { :git => 'https://github.com/tinkoff-mobile-tech/TinkoffID.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.source_files = 'Development/Source/**/*'
  s.resource_bundles = {
      'TinkoffIdResources' => ['Development/Resources/**/*.{strings,xcassets}']
  }
end
