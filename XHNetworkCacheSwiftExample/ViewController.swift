//
//  ViewController.swift
//  XHNetworkCacheSwiftExample
//
//  Created by xiaohui on 16/8/12.
//  Copyright © 2016年 qiantou. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHNetworkCacheSwift

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLab: UILabel!
    
    /**
     *  模拟数据请求URL
     */
    let URLString = "http://www.returnoc.com"
    
    /**
     *  模拟服务器请求数据
     */
    let responseObject = [
        "time" : "1444524177",
        "isauth" : "0",
        "openid" : "1728484287",
        "sex" : "男",
        "city" : "",
        "cover" : "http://tp4.sinaimg.cn/1728484287/180/5736236738/1",
        "logintime" : "1445267749",
        "name" : "",
        "group" : "3",
        "loginhit" : "4",
        "id" : "234328",
        "phone" : "",
        "nicheng" : "辉Allen",
        "apptoken" : "bae4c30113151270174f724f450779bc",
        "face" : "http://tp4.sinaimg.cn/1728484287/180/5736236738/1",
        "desc" : "比你牛B的人都在努力,你还有什么理由偷懒!",
        "infoverify" : "1"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "XHNetworkCacheSwiftExample"
        
        textLab.text = "请看控制台打印 \n 详见Github: https://github.com/CoderZhuXH/XHNetworkCache-Swift"
        

        // Do any additional setup after loading the view.
    }
    
    /**
     *  (同步)写入/更新缓存
     */
    @IBAction func save(sender: UIButton) {
        
      if XHNetworkCache.saveJsonResponseToCacheFile(responseObject, URL: URLString)
      {
         print("(同步)保存/更新成功")
      }
      else
      {
        
         print("(同步)保存/更新失败")
      }
        
    }
    
    /**
     *  (异步)写入/更新缓存
     */
    @IBAction func save_async(sender: UIButton) {
        
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
        
    }
    
    /**
     *  获取缓存数据
     */
    @IBAction func getCache(sender: UIButton) {
   
        if let json = XHNetworkCache.cacheJsonWithURL(URLString)
        {
            print(json)
        }
    }
    
    /**
     *  缓存数据大小(M)
     */
    @IBAction func cacheSize(sender: UIButton) {
   
    
        let size = XHNetworkCache.cacheSize()
        
         print("缓存大小(M)=\(size)")
        
    }
    
    /**
     *  缓存路径
     */
    @IBAction func cachePath(sender: UIButton) {
    
        let path = XHNetworkCache.cachePath()
         print("缓存路径=" + path)
    
    }
    
    /**
     *  清除缓存
     */
    @IBAction func clearCache(sender: UIButton) {
    
        if XHNetworkCache.clearCache()
        {
            print("清除缓存成功")
        }
        else
        {
            print("清除缓存失败")
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
