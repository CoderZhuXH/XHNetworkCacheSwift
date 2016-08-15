Pod::Spec.new do |s|
  s.name         = "XHNetworkCacheSwift"
  s.version      = "1.0.0"
  s.summary      = "swift,一行代码将网络数据持久化"
  s.homepage     = "https://github.com/CoderZhuXH/XHNetworkCacheSwift"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Zhu Xiaohui" => "977950862@qq.com"}
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/CoderZhuXH/XHNetworkCacheSwift.git", :tag => s.version }
  s.source_files = "XHNetworkCacheSwift", "*.{swift}"
  s.requires_arc = true
    
end
