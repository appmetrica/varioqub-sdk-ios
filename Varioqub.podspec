Pod::Spec.new do |s|

  s.name = "Varioqub"
  s.version = '1.1.1'
  s.summary = "Varioqub"

  s.homepage = "https://varioqub.ru"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.authors = { "AppMetrica" => "admin@appmetrica.io" }
  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'
  s.source = { :git => "https://github.com/appmetrica/varioqub-sdk-ios.git", :tag=>s.version.to_s }

  s.swift_versions = "5.8"
  s.pod_target_xcconfig = {
      'APPLICATION_EXTENSION_API_ONLY' => 'YES',
      'DEFINES_MODULE' => 'YES',
      'OTHER_SWIFT_FLAGS' => '$(inherited) -DVQ_LOGGER',
  }

  s.frameworks = 'Foundation'

  s.default_subspec = 'Core'

  s.subspec "Core" do |core|
    core.source_files = [
      "Sources/Varioqub/**/*.swift",
      "Sources/VarioqubLogger/**/*.swift",
      "Sources/VarioqubNetwork/**/*.swift",
      "Sources/VarioqubUtils/**/*.swift",
    ]
    
    core.dependency 'SwiftProtobuf', '~> 1.31'
  end

  s.subspec "ObjC" do |objc|
    objc.source_files = [
        "Sources/VarioqubObjC/**/*.swift"
    ]

    objc.dependency 'Varioqub/Core'
  end

end
