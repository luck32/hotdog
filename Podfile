# Uncomment this line to define a global platform for your project
platform :ios, '7.0'

source 'https://github.com/CocoaPods/Specs.git'

target :HOTDOG do

pod 'MBProgressHUD', '~> 0.8'
pod 'SVProgressHUD'
pod 'AFNetworking'
pod 'AFNetworking+ImageActivityIndicator'
pod 'SZTextView', '< 1.1.0'
pod 'Cloudinary', '~> 1.0.14'

pod 'Fabric'
pod 'TwitterKit'
pod 'TwitterCore'
pod 'Crashlytics'

pod 'IQKeyboardManager'

pod "FBSDKCoreKit"
pod "FBSDKLoginKit"
pod "FBSDKShareKit"

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end

end



