Pod::Spec.new do |s|
  s.name         = "XHNetworkCache-Swift"
  s.version      = "1.0.0"
  s.summary      = "swift,一行代码将请求数据写入沙盒缓存"
  s.homepage     = "https://github.com/CoderZhuXH/XHNetworkCache-Swift"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Zhu Xiaohui" => "977950862@qq.com"}
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/CoderZhuXH/XHNetworkCache-Swift.git", :tag => s.version }
  s.source_files = "XHNetworkCache-Swift", "*.{swift}"
  s.requires_arc = true
    
end
