#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint wonder_payment_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'wonder_payment_plugin'
  s.version          = '1.0.6'
  s.summary          = 'Wonder Payment Plugin.'
  s.description      = <<-DESC
Wonder Flutter Payment SDK for iOS and Android devices.
                       DESC
  s.homepage         = 'https://wonder.app/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Jax' => 'jax.xu@bindo.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.dependency 'WonderPaymentSDK', '0.8.3'
  s.static_framework = true
end
