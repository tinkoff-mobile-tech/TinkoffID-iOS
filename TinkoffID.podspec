Pod::Spec.new do |s|
  s.name             = 'TinkoffID'
  s.summary          = 'TinkoffID iOS SDK'
  s.version          = '1.2.0'
  s.author           = { 'Дмитрий Оверчук' => 'd.overchuk@tinkoff.ru' }
  s.homepage         = 'https://github.com/tinkoff-mobile-tech/TinkoffID'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.source           = { git: 'https://github.com/tinkoff-mobile-tech/TinkoffID.git', tag: s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/**/*.swift'
  s.resources = 'Sources/**/*.{xcassets,lproj}'
  s.dependency 'TCSSSLPinningPublic', '~> 4.0'

  s.test_spec('Tests') do |test_spec|
    test_spec.source_files = 'Tests/**/*.{swift}'
  end
end
