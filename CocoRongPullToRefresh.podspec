Pod::Spec.new do |s|
  s.name = 'CocoRongPullToRefresh'
  s.version = '1.1.1'
  s.license = 'MIT'
  s.summary = 'A simple pull to refresh component for iOS written in Swift.'
  s.homepage = 'https://github.com/MellongLau/CocoRongPullToRefresh'
  s.authors = { 'Mellong' => 'tendencystudio@gmail.com' }
  s.source = { :git => 'https://github.com/MellongLau/CocoRongPullToRefresh.git', :tag => s.version }
  s.ios.deployment_target = '12.0'
  s.source_files = 'CocoRongPullToRefresh/*.swift'
  s.swift_version = '5.0'
end
