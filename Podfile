# add the Firebase pod for Google Analytics
target 'TRACE' do
platform :ios, '14.1'
workspace '/Users/Matt/Projects/Workspace/TRACE-beta'

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
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
