Pod::Spec.new do |s|
  s.name = 'CocoRongPullToRefresh'
  s.version = '1.0'
  s.license = 'MIT'
  s.summary = 'A simple pull to refresh component for iOS written in Swift.'
  s.homepage = 'https://github.com/MellongLau/CocoRongPullToRefresh'
  s.social_media_url = 'http://www.devlong.com'
  s.authors = { 'Mellong' => '121382647@qq.com' }
  s.source = { :git => 'https://github.com/MellongLau/CocoRongPullToRefresh.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'CocoRongPullToRefresh/*.swift'
end
