Pod::Spec.new do |s|
  s.name             = 'ViewExtensions'
  s.version          = '0.2.1'
  s.summary          = 'UIView Extensions'
  s.homepage         = 'https://github.com/vysotskiyserhiy/ViewExtensions'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Serhiy Vysotskiy' => 'vysotskiyserhiy@gmail.com' }
  s.source           = { :git => 'https://github.com/vysotskiyserhiy/ViewExtensions.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'ViewExtensions/Classes/**/*'
  s.frameworks = 'UIKit'
  s.dependency 'Atom'
  s.dependency 'RxSwift'
end
