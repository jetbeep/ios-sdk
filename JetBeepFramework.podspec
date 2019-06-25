Pod::Spec.new do |s|  
    s.name              = 'JetBeepFramework'
    s.version           = '1.0.12'
    s.summary           = 'JetBeep SDK.'
    s.homepage          = 'https://github.com/jetbeep/ios-sdk'

    s.author            = { "Oleh Hordiichuk" => "oleh.hordiichuk@jetbeep.com"  }
    s.license           = { :type => 'The MIT License (MIT)', :file => 'LICENSE' }
	s.source            = { :http => "https://github.com/jetbeep/ios-sdk/raw/master/JetBeepFramework.zip"}
    s.platform          = :ios
	s.swift_version     = '5.0'
	
	s.dependency 'PromisesSwift', '~> 1.2.4'
	s.dependency 'CryptoSwift', '~> 1'	
	s.dependency 'SQLite.swift', '~> 0.11.5'
	s.dependency 'Repeat', '~> 0.5.7'
	s.dependency 'DeepDiff', '~> 2.2.0'


    s.ios.deployment_target = '10.0'
    s.ios.vendored_frameworks = 'JetBeepFramework.framework'
end  