//
//  XHNetworkCache.swift
//  XHNetworkCacheSwiftExample
//
//  Created by xiaohui on 16/8/12.
//  Copyright © 2016年 CoderZhuXH. All rights reserved.
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
    public class func saveJsonResponseToCacheFile(_ jsonResponse: AnyObject,URL: String) -> Bool {
        
        let data = jsonToData(jsonResponse)
        return FileManager.default.createFile(atPath: cacheFilePathWithURL(URL), contents: data, attributes: nil)
        
    }
    
    /**
     写入/更新缓存(异步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
     
     - parameter jsonResponse: 要写入的数据(JSON)
     - parameter URL:          数据请求URL
     - parameter completed:    异步完成回调(主线程回调)
     */
    public class func save_asyncJsonResponseToCacheFile(_ jsonResponse: AnyObject,URL: String, completed:@escaping (Bool) -> ()) {
        
        DispatchQueue.global().async{
            
            let result = saveJsonResponseToCacheFile(jsonResponse, URL: URL)
            
            DispatchQueue.main.async(execute: {
                
                completed(result)
            })
        }
    }
    
    /**
     获取缓存的对象(同步)
     
     - parameter URL: 数据请求URL
     
     - returns: 缓存对象
     */
    public class func cacheJsonWithURL(_ URL: String) -> AnyObject? {
        let path: String = self.cacheFilePathWithURL(URL)
        let fileManager: FileManager = FileManager.default
        if fileManager.fileExists(atPath: path, isDirectory: nil) == true {
            let data: Data = fileManager.contents(atPath: path)!
            return self.dataToJson(data)
        }
        
        return nil
    }
    
    /**
     获取缓存路径
     
     - returns: 缓存路径
     */
    public class func cachePath() -> String {
        
        let pathOfLibrary = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        let path = pathOfLibrary.appendingPathComponent("XHNetworkCache")
        return path
    }
    
    /**
     清除缓存
     */
    public class func clearCache() -> Bool{
        let fileManager: FileManager = FileManager.default
        let path: String = self.cachePath()
        do
        {
            try fileManager.removeItem(atPath: path)
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
            let fileArr = try FileManager.default.contentsOfDirectory(atPath: cachePath)
            var size:Float = 0
            for file in fileArr{
                let path = cachePath + "/\(file)"
                let floder = try! FileManager.default.attributesOfItem(atPath: path)
                for (abc, bcd) in floder {
                    if abc == FileAttributeKey.size {
                        size += (bcd as AnyObject).floatValue
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

open class XHNetworkCache {
    
    //MARK: - private
    fileprivate class func jsonToData(_ jsonResponse: AnyObject) -> Data? {
        
        do{
            
            let data = try JSONSerialization.data(withJSONObject: jsonResponse, options: JSONSerialization.WritingOptions.prettyPrinted)
            return data;
            
        }catch
        {
            return nil
        }
    }
    
    fileprivate class func dataToJson(_ data: Data) -> AnyObject? {
        
        do{
            
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return json as AnyObject?
            
        }
        catch
        {
            return nil
        }
    }
    
    fileprivate class func cacheFilePathWithURL(_ URL: String) -> String {
        var path: String = self.cachePath()
        self.checkDirectory(path)
        //check路径
        let cacheFileNameString: String = "URL:\(URL) AppVersion:\(self.appVersionString())"
        let cacheFileName: String = self.md5StringFromString(cacheFileNameString)
        path = path + "/" + cacheFileName
        return path
    }
    
    fileprivate class func checkDirectory(_ path: String) {
        let fileManager: FileManager = FileManager.default
        
        var isDir = ObjCBool(false) //isDir判断是否为文件夹
        
        fileManager.fileExists(atPath: path, isDirectory: &isDir)
        
        if !fileManager.fileExists(atPath: path, isDirectory: &isDir) {
            
            self.createBaseDirectoryAtPath(path)
            
        } else {
            
            if !isDir.boolValue {
                
                do
                {
                    try fileManager.removeItem(atPath: path)
                    self.createBaseDirectoryAtPath(path)
                }
                catch let error as NSError
                {
                    print("create cache directory failed, error = %@", error)
                    
                }
            }
        }
    }
    
    fileprivate class func createBaseDirectoryAtPath(_ path: String) {
        
        do
        {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            print("path ="+path)
            self.addDoNotBackupAttribute(path)
        }
        catch let error as NSError
        {
            print("create cache directory failed, error = %@", error)
            
        }
    }
    
    fileprivate class func addDoNotBackupAttribute(_ path: String) {
        let url: URL = URL(fileURLWithPath: path)
        
        do
        {
            try  (url as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)
        }
        catch let error as NSError
        {
            print("error to set do not backup attribute, error = %@", error)
            
        }
    }
    
    fileprivate class func md5StringFromString(_ string: String) -> String {
        
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);
        
        CC_MD5(str!, strLen, result);
        
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.deinitialize();
        
        return String(format: hash as String)
    }
    
    fileprivate class func appVersionString() -> String {
        
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
    }
}

