Pod::Spec.new do |spec|
  spec.name         = "Requester"
  spec.version      = "1.0.5"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.description  = "Lightweight REST client"
  spec.summary      = "Lightweight REST client"
  spec.homepage     = "https://github.com/ILYA2606/Requester"
  spec.license      = { :type => "MIT" }
  spec.author       = { "Ilya Shkolnik" => "dev@darknessproduction.com" }
  spec.platform     = :ios, '9.0'
  spec.source       = { :git => "https://github.com/ILYA2606/Requester.git", :tag => spec.version }
  spec.source_files  = 'Sources/**/*.{swift,m,h}'
end
