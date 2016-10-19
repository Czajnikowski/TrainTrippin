source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
    end
  end
end

target 'TrainTrippin' do
  use_frameworks!

  pod 'SWXMLHash', '~> 3.0.0'
  pod 'RxSwift',    '3.0.0-rc.1'
  pod 'RxCocoa',    '3.0.0-rc.1'
  pod 'Alamofire', '~> 4.0'
  pod 'RxAlamofire', '3.0.0-rc.1'
  pod 'RxDataSources', '~> 1.0.0-rc.1'
  pod "AFDateHelper"

  target 'TrainTrippinTests' do
    inherit! :search_paths

  end

end
