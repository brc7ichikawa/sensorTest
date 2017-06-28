//
//  Define.swift
//  sensorTest
//
//  Created by brc7tichikawa on 2015/08/19.
//  Copyright (c) 2015年 brc7tichikawa. All rights reserved.
//

import Foundation
import UIKit
class Define {
    var host = ""
    var hash_str : String = ""
    var top_url : String = "";
    var url : String = ""

    var automate_on_url : String = ""
    var automate_off_url : String = ""
    var power_on_url : String = ""
    var power_off_url : String = ""
    var restore_url : String = ""
    var setting_url : String = ""
    var setting_save_url: String = ""
    var map_url: String = ""
    
    init() {
        let dic = self.getDefinePlist("define.plist")
        self.host = dic.objectForKey("domain") as! String
        self.hash_str = dic.objectForKey("hash_str") as! String
        self.top_url = dic.objectForKey("top_url") as! String
        self.url = dic.objectForKey("url") as! String
        
        self.top_url = strReplace("%host", to: self.host, input : self.top_url)
        self.url = top_url + url + hash_str
        self.automate_on_url = strReplace("getMyPoint", to: "updateAutomateOn", input: url )
        self.automate_off_url = strReplace("getMyPoint", to: "updateAutomateOff", input: url)
        self.power_on_url = strReplace("getMyPoint", to: "updatePowerOn", input: url)
        self.power_off_url = strReplace("getMyPoint", to: "updatePowerOff", input: url)
        self.restore_url = strReplace("getMyPoint", to: "restoreData", input: url)
        self.setting_url =  strReplace("getMyPoint", to: "getMyTimeCSV", input: url)
        self.setting_save_url = strReplace("getMyPoint", to: "updateMyTime", input: url)
        self.map_url = strReplace("getMyPoint", to: "index", input: strReplace("GeoLoc", to: "Map", input: url))
        
    }
    
    func getTimeNow() -> String {
        return self.makeTime(NSDate(), format : "yyyy/MM/dd HH:mm:ss")
    }
    
    func makeTime (date_ : NSDate, format : String)-> String {
        //var now = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") // ロケールの設定
        dateFormatter.dateFormat = format // 日付フォーマットの設定
        return dateFormatter.stringFromDate(date_)
    }
    
    /**
     * P リスト読み込み
     */
    func getDefinePlist (file_name : String) -> NSDictionary {
        var filePath = NSBundle.mainBundle().pathForResource(file_name, ofType: nil )
        var dic = NSDictionary(contentsOfFile:filePath!)
        //let arr:NSArray = dic!.objectForKey("Root") as! NSArray
        
        return dic!
    }
    
    // webリクエスト共通化
    func commonRequestUrl (input_url : String, completionHandler collback:  (NSURLResponse!, NSData!,  NSError!) -> Void )  {
//        var url = NSURL(string : input_url.stringByReplacingOccurrencesOfString("%x:", withString: x_loc!).stringByReplacingOccurrencesOfString("%y:", withString : y_loc!))
        var req = NSURLRequest(URL: NSURL(string :input_url)!)
        
        //geo_log_model.insert(x_loc!, y: y_loc!, status: "1")
        
        var connection: NSURLConnection = NSURLConnection(request: req, delegate: self, startImmediately: false)!
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: collback)
    }
    
    // POSTリクエスト
    func commonRequetPost (input_url: String, param : String, completionHandler  handle: ((NSData!, NSURLResponse!, NSError!) -> Void)) {
        
        //let str = "name=taro&pw=tarospw"
        let strData = param.dataUsingEncoding(NSUTF8StringEncoding)
        
        var url = NSURL(string : input_url)!
        var request = NSMutableURLRequest(URL: url)
        

        request.HTTPMethod = "POST"
        request.HTTPBody = strData
        
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler : handle)
        task.resume()
    }
    
    func strReplace (from : String, to: String, input : String) -> String {
        return input.stringByReplacingOccurrencesOfString(from, withString: to)
    }
    
    func alert (message: String) -> UIAlertController {
        // UIAlertControllerを作成する.
        let myAlert: UIAlertController = UIAlertController(title: "メッセージ", message: message, preferredStyle: .Alert)
        
        // OKのアクションを作成する.
        let myOkAction = UIAlertAction(title: "OK", style: .Default) { action in
            //print("Action OK!!")
        }
        
        // OKのActionを追加する.
        myAlert.addAction(myOkAction)
        
        return myAlert
        // UIAlertを発動する.
        //presentViewController(myAlert, animated: true, completion: nil)
    }
}