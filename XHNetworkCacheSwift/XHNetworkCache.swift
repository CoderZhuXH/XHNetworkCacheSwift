//
//  XHNetworkCache.swift
//  XHNetworkCacheSwiftExample
//
//  Created by xiaohui on 16/8/12.
//  Copyright © 2016年 qiantou. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHNetworkCacheSwift

/**
 *  注意: 使用前请在'-Bridging-Header.h' 桥接文件中导入 #import<CommonCrypto/CommonCrypto.h>
 */

import UIKit

extension XHNetworkCache
{
    /**
     写入/更新缓存(同步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
     
     - parameter jsonResponse: 要写入的数据(JSON)
     - parameter URL:           数据请求URL
     
     - returns: 是否写入成功
     */
    public class func saveJsonResponseToCacheFile(jsonResponse: AnyObject,URL: String) -> Bool {
        
        let data = jsonToData(jsonResponse)
        return NSFileManager.defaultManager().createFileAtPath(cacheFilePathWithURL(URL), contents: data, attributes: nil)
        
    }
    
    /**
     写入/更新缓存(异步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
     
     - parameter jsonResponse: 要写入的数据(JSON)
     - parameter URL:          数据请求URL
     - parameter completed:    异步完成回调(主线程回调)
     */
    public class func save_asyncJsonResponseToCacheFile(jsonResponse: AnyObject,URL: String, completed:(Bool) -> ()) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let result = saveJsonResponseToCacheFile(jsonResponse, URL: URL)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                completed(result)
            })
        }
    }
    
    /**
     获取缓存的对象(同步)
     
     - parameter URL: 数据请求URL
     
     - returns: 缓存对象
     */
    public class func cacheJsonWithURL(URL: String) -> AnyObject? {
        let path: String = self.cacheFilePathWithURL(URL)
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(path, isDirectory: nil) == true {
            let data: NSData = fileManager.contentsAtPath(path)!
            return self.dataToJson(data)
        }
        
        return nil
    }
    
    /**
     获取缓存路径
     
     - returns: 缓存路径
     */
    public class func cachePath() -> String {
        
        let pathOfLibrary = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
        let path = pathOfLibrary.stringByAppendingPathComponent("XHNetworkCache")
        return path
    }
    
    /**
     清除缓存
     */
    public class func clearCache() -> Bool{
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        let path: String = self.cachePath()
        do
        {
            try fileManager.removeItemAtPath(path)
            self.checkDirectory(self.cachePath())
            return true
        }
        catch let error as NSError
        {
            print("clearCache failed , error = \(error)")
            return false
        }
    }
    
    /**
     获取缓存大小
     
     - returns: 缓存大小(单位:M)
     */
    public class func cacheSize()-> Float {
        
        let cachePath = self.cachePath()
        do
        {
            let fileArr = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(cachePath)
            var size:Float = 0
            for file in fileArr{
                let path = cachePath.stringByAppendingString("/\(file)")
                let floder = try! NSFileManager.defaultManager().attributesOfItemAtPath(path)
                for (abc, bcd) in floder {
                    if abc == NSFileSize {
                        size += bcd.floatValue
                    }
                }
            }
            let total = size / 1024.0 / 1024.0
            return total
        }
        catch
        {
            return 0;
        }
    }

}

public class XHNetworkCache {
    
    //MARK: - private
    private class func jsonToData(jsonResponse: AnyObject) -> NSData? {
        
        do{
            
            let data = try NSJSONSerialization.dataWithJSONObject(jsonResponse, options: NSJSONWritingOptions.PrettyPrinted)
            return data;
            
        }catch
        {
            return nil
        }
    }
    
    private class func dataToJson(data: NSData) -> AnyObject? {
        
        do{
            
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            return json
            
        }
        catch
        {
            return nil
        }
    }
    
    private class func cacheFilePathWithURL(URL: String) -> String {
        var path: String = self.cachePath()
        self.checkDirectory(path)
        //check路径
        let cacheFileNameString: String = "URL:\(URL) AppVersion:\(self.appVersionString())"
        let cacheFileName: String = self.md5StringFromString(cacheFileNameString)
        path = path + "/" + cacheFileName
        return path
    }
    
    private class func checkDirectory(path: String) {
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        
        var isDir = ObjCBool(false) //isDir判断是否为文件夹
        
        fileManager.fileExistsAtPath(path, isDirectory: &isDir)
        
        if !fileManager.fileExistsAtPath(path, isDirectory: &isDir) {
            
            self.createBaseDirectoryAtPath(path)
            
        } else {
            
            if !isDir {
                
                do
                {
                    try fileManager.removeItemAtPath(path)
                    self.createBaseDirectoryAtPath(path)
                }
                catch let error as NSError
                {
                    print("create cache directory failed, error = %@", error)
                    
                }
            }
        }
    }
    
    private class func createBaseDirectoryAtPath(path: String) {
        
        do
        {
            try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
            print("path ="+path)
            self.addDoNotBackupAttribute(path)
        }
        catch let error as NSError
        {
            print("create cache directory failed, error = %@", error)
            
        }
    }
    
    private class func addDoNotBackupAttribute(path: String) {
        let url: NSURL = NSURL.fileURLWithPath(path)
        
        do
        {
            try  url.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey)
        }
        catch let error as NSError
        {
            print("error to set do not backup attribute, error = %@", error)
            
        }
    }
    
    private class func md5StringFromString(string: String) -> String {
        
        let str = string.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
        
        CC_MD5(str!, strLen, result);
        
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.destroy();
        
        return String(format: hash as String)
    }
    
    private class func appVersionString() -> String {
        
        return NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
    }
}

