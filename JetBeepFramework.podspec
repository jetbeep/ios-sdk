Pod::Spec.new do |s|  
    s.name              = 'JetBeepFramework'
    s.version           = '1.0.1'
    s.summary           = 'JetBeep SDK.'
    s.homepage          = 'https://github.com/jetbeep/ios-sdk'

    s.author            = { "Oleh Hordiichuk" => "oleh.hordiichuk@jetbeep.com"  }
    s.license           = { :type => 'The MIT License (MIT)', :file => 'LICENSE' }
	s.source            = { :http => "https://github.com/jetbeep/ios-sdk/raw/master/JetBeepFramework.zip"}
    s.platform          = :ios
	s.swift_version     = '4.0'
	
	s.dependency 'PromisesSwift', '~> 1.2.4'
	s.dependency 'CryptoSwift', '~> 0.7.2'	
	s.dependency 'SQLite.swift', '~> 0.11.5'

    s.ios.deployment_target = '10.0'
    s.ios.vendored_frameworks = 'JetBeepFramework.framework'
end  