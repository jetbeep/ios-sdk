Pod::Spec.new do |s|  
    s.name              = 'JetBeepFramework'
    s.version           = '1.0.87'
    s.summary           = 'JetBeep SDK.'
    s.homepage          = 'https://github.com/jetbeep/ios-sdk'

    s.author            = { "Oleh Hordiichuk" => "oleh.hordiichuk@jetbeep.com"  }
    s.license           = { :type => 'The MIT License (MIT)', :file => 'LICENSE' }
	s.source            = { :http => "https://github.com/jetbeep/ios-sdk/raw/master/JetBeepFramework-1.0.87.zip"}
	s.pod_target_xcconfig = {
	    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
	  }
	s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.platform          = :ios
	s.swift_version     = '5.0'
	
	s.dependency 'PromisesSwift'
	s.dependency 'CryptoSwift'
	s.dependency 'SQLite.swift'
	s.dependency 'Repeat'
	s.dependency 'DeepDiff'
    s.dependency 'CocoaLumberjack/Swift'


    s.ios.deployment_target = '10.0'
    s.ios.vendored_frameworks = 'JetBeepFramework.framework'
end  