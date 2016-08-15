# XHNetworkCacheSwift
#### 一行代码将网络数据持久化
####[OC版本请戳这里>>>](https://github.com/CoderZhuXH/XHNetworkCache)
###技术交流群(群号:537476189)
## 使用方法:
### 1.(同步)写入/更新
```objc
//将数据(同步)写入磁盘缓存(参数1:服务器返回的JSON数据, 参数2:数据请求URL)
//[按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
if XHNetworkCache.saveJsonResponseToCacheFile(responseObject, URL: URLString)
{
     print("(同步)保存/更新成功")
}
else
{
    print("(同步)保存/更新失败")
}

```
### 2.(异步)写入/更新
```objc
//将数据(异步)写入磁盘缓存(参数1:服务器返回的JSON数据, 参数2:数据请求URL)
//[按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
XHNetworkCache.save_asyncJsonResponseToCacheFile(responseObject, URL: URLString) { (result) in
if(result)
{
     print("(异步)保存/更新成功")
}    
else
{
     print("(异步)保存/更新成功")
}
}

```
### 3.获取缓存数据
```objc
//获取缓存数据(参数:请求URL,返回:JSON数据)
if let json = XHNetworkCache.cacheJsonWithURL(URLString)
{
    print(json)
}
```
### 4.获取缓存路径
```objc
//获取缓存路径
let path = XHNetworkCache.cachePath()

```
### 5.清除缓存
```objc
//清除缓存
if XHNetworkCache.clearCache()
{
     print("清除缓存成功")
}
else
{
     print("清除缓存失败")
}
```

### 6.获取缓存总大小(M)
```objc
//获取缓存总大小(M)
let size = XHNetworkCache.cacheSize()
```
##  安装
### 手动添加:<br>
*   1.将 XHNetworkCacheSwift 文件夹添加到工程目录中<br>
*   2.在项目`Bridging-Header.h` 桥接文件中 `#import<CommonCrypto/CommonCrypto.h>`
*   3.`Bridging-Header.h`桥接文件怎么创建??? 请自行Google或百度

##  系统要求
*   该项目最低支持 iOS 8.0 和 Xcode 7.3

##  许可证
    XHNetworkCacheSwift 使用 MIT 许可证，详情见 LICENSE 文件