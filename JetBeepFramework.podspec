Pod::Spec.new do |s|  
    s.name              = 'JetBeepFramework'
    s.version           = '1.0.125'
    s.summary           = 'JetBeep SDK.'
    s.homepage          = 'https://github.com/jetbeep/ios-sdk'

    s.author            = { "Oleh Hordiichuk" => "oleh.hordiichuk@jetbeep.com"  }
    s.license           = { :type => 'The MIT License (MIT)', :file => 'LICENSE.txt' }
	s.source            = { :http => "https://github.com/jetbeep/ios-sdk/raw/master/JetBeepFramework-1.0.125.zip"}
	s.pod_target_xcconfig = {
	    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
	  }
	s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.platform          = :ios
	s.swift_version     = '5.0'
	
	s.dependency 'PromisesSwift'
	s.dependency 'CryptoSwift'
	s.dependency 'SQLite.swift', '< 0.14.0'
	s.dependency 'DeepDiff'
    s.dependency 'CocoaLumberjack/Swift'
	s.dependency 'Repeat'


    s.ios.deployment_target = '13.0'
    s.ios.vendored_frameworks = 'JetBeepFramework.xcframework'
end  