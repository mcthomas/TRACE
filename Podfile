# add the Firebase pod for Google Analytics
target 'TRACE' do
platform :ios, '14.1'
workspace '/Users/Matt/Projects/Workspace/TRACE'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

pod 'Firebase'
pod 'FirebaseUI'
pod 'Firebase/Auth'
pod 'GoogleSignIn'
pod 'Firebase/Analytics'
pod 'Firebase/Core'
pod 'FirebaseUI/Auth'
pod 'FirebaseUI/Email'
pod 'FirebaseUI'
pod 'FirebaseUI/Auth'
pod 'FirebaseUI/OAuth'
pod 'Firebase/Auth'
pod 'Firebase/Storage'
pod 'Firebase/Database'
pod 'FirebaseUI/OAuth'


end

target 'TRACETests' do
platform :ios, '14.1'
pod 'Firebase'
pod 'FirebaseUI'
pod 'Firebase/Auth'
pod 'GoogleSignIn'
pod 'Firebase/Analytics'
pod 'Firebase/Core'
pod 'FirebaseUI/Auth'
pod 'FirebaseUI/Email'
pod 'FirebaseUI'
pod 'FirebaseUI/Auth'
pod 'FirebaseUI/OAuth'
pod 'Firebase/Auth'
pod 'Firebase/Storage'
pod 'Firebase/Database'
pod 'FirebaseUI/OAuth'
end

target 'TRACEUITests' do
platform :ios, '14.1'
pod 'Firebase'
pod 'FirebaseUI'
pod 'Firebase/Auth'
pod 'GoogleSignIn'
pod 'Firebase/Analytics'
pod 'Firebase/Core'
pod 'FirebaseUI/Auth'
pod 'FirebaseUI/Email'
pod 'FirebaseUI'
pod 'FirebaseUI/Auth'
pod 'FirebaseUI/OAuth'
pod 'Firebase/Auth'
pod 'Firebase/Storage'
pod 'Firebase/Database'
pod 'FirebaseUI/OAuth'
end


# add pods for any other desired Firebase products
# https://firebase.google.com/docs/ios/setup#available-pods
