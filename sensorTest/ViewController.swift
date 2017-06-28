//
//  ViewController.swift
//  sensorTest
//
//  Created by brc7tichikawa on 2015/06/26.
//  Copyright (c) 2015年 brc7tichikawa. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate{
    @IBOutlet weak var outButton: UIButton!

    @IBOutlet weak var sw_automate: UISwitch!
    @IBOutlet weak var sw_power_on_off: UISwitch!
    @IBOutlet weak var sw_mask: UISwitch!
    @IBOutlet weak var label_x: UILabel!
    @IBOutlet weak var label_y: UILabel!
    @IBOutlet weak var label_update_date: UILabel!
    @IBOutlet weak var label_msg: UILabel!
    
    var mlocation : CLLocationManager!
    var x_loc : String?
    var y_loc : String?
    var geo_log_model : GeoLogModel!
    
    // 定数
    var define : Define!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // let myButton = UIButton();
        // myButton.

        define = Define();
        geo_log_model = GeoLogModel() // 実体化
        self.restoreRequest();
        initLocation()
        mlocation.startUpdatingLocation()

    }
    
    @IBAction func webViewOnTouchDown(sender: AnyObject) {
        let url = NSURL(string: define.strReplace("%x:", to: "1", input: define.strReplace("%y:", to: "1", input: define.map_url)))
        //let requestURL = NSURL(string: url)
        //let url = NSURL(string: "指定URL")
        if UIApplication.sharedApplication().canOpenURL(url!){
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    @IBAction func touchAutomateSw(sender: AnyObject) {
        
    }
 
    // 位置情報初期化
    private func initLocation () {
        mlocation = CLLocationManager()
        mlocation.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.NotDetermined) {
            self.mlocation.requestAlwaysAuthorization()
        }
        mlocation.desiredAccuracy == kCLLocationAccuracyBest
        mlocation.distanceFilter = 100
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 自動制御オンオフ
    @IBAction func swAutomateDidChange(sender: AnyObject) {
        var sw_ : UISwitch = sender as! UISwitch
        if(sw_.on) {
            updateAutomateOnRequestWeb()
        } else {
            updateAutomateOffRequestWeb()
        }
        //mlocation.startUpdatingLocation()
    }

    @IBAction func swPowerDidChange(sender: AnyObject) {
        var sw_ : UISwitch = sender as! UISwitch
        if(sw_.on) {
            updatePowerOnRequestWeb()
        } else {
            updatePowerOffRequestWeb()
        }
        //mlocation.startUpdatingLocation()
    }
    
    @IBAction func buttonAutomateOnTouchDown(sender: AnyObject) {
        updateAutomateOnRequestWeb()
    }
    
    @IBAction func buttonAutomateOffTouchDown(sender: AnyObject) {
        updateAutomateOffRequestWeb()
    }
    
    @IBAction func buttonOnTouchDown(sender: UIButton) {
        label_x.text = "取得中"
        label_y.text = "取得中"
        label_update_date.text = "取得中"
        mlocation.startUpdatingLocation()
        //startRequestWeb()
    }

    @IBAction func buttonJsTestTouchDown(sender: AnyObject) {
        self.jsonDecodeTest()
    }
    
    
//    func updateTimer () {
//        mlocation.startUpdatingLocation()
//    }
    
    // 経度緯度取得成功
    func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
        y_loc = "\(manager.location.coordinate.latitude)"
        x_loc = "\(manager.location.coordinate.longitude)"
        //var now = NSDate()
        
        label_y.text = maskString(y_loc!)
        label_x.text = maskString(x_loc!)
        
//      var dateFormatter = NSDateFormatter()
//      dateFormatter.locale = NSLocale(localeIdentifier: "en_US") // ロケールの設定
//      dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss" // 日付フォーマットの設定

        var date_time_now = define.getTimeNow()
        label_update_date.text = date_time_now//dateFormatter.stringFromDate(now)
        // web リクエスト開始
        self.startRequestWeb()
    }
    
    // 位置情報取得に失敗した時に呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        print("error" + error.localizedDescription)
        label_msg.text = error.localizedDescription
    }
    
    // WEBリクエスト開始
    func startRequestWeb () {
        var input_url : String = define.url
        commonRequestUrl(input_url, completionHandler :self.fetchResponse)
    }
    
    // 自動制御オンリクエスト
    func updateAutomateOnRequestWeb() {
        commonRequestUrl(define.automate_on_url, completionHandler :self.fetchResponse)
    }
    
    // 自動制御オフリクエスト
    func updateAutomateOffRequestWeb () {
        commonRequestUrl(define.automate_off_url, completionHandler :self.fetchResponse)
    }
    
    //
    func updatePowerOnRequestWeb() {
        commonRequestUrl(define.power_on_url, completionHandler :self.fetchResponse)
    }
    
    //
    func updatePowerOffRequestWeb () {
        commonRequestUrl(define.power_off_url, completionHandler :self.fetchResponse)
    }
    
    // json テストコード
    func jsonDecodeTest () {
        var url = define.strReplace("%y:", to: "1", input: define.strReplace("%x:", to: "1", input:  define.strReplace("getMyPoint", to: "jsonTest", input: self.define.url)))
        
        define.commonRequestUrl(url, completionHandler: { (res, data, error) -> Void in
            
            if(error == nil) {
                var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
                var status = json.objectForKey("status") as! String
                var is_automate = json.objectForKey("is_automate") as! String
//                for value in json {
//                    println( "\(value.key) : \(value.value)" )
//                }
            }
            
        })
    }
    
    // webリクエスト共通化
    func commonRequestUrl (input_url : String, completionHandler collback:  (NSURLResponse!, NSData!, NSError!) -> Void ) {
        var url = (string : input_url.stringByReplacingOccurrencesOfString("%x:", withString: x_loc!).stringByReplacingOccurrencesOfString("%y:", withString : y_loc!))
        self.define.commonRequestUrl(url, completionHandler: collback);

    }
    
    /**
     * 通信エラー分GPS情報をサーバ側に追加する
     */
    func restoreRequest () {
        var request_url = define.restore_url.stringByReplacingOccurrencesOfString("%x:", withString: "1").stringByReplacingOccurrencesOfString("%y:", withString : "1") + self.makeRestoreParam()
        request_url = request_url.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        self.define.commonRequestUrl(request_url, completionHandler: self.retchRestore)
    }
    
    /**
     *
     */
    func makeRestoreParam () -> String {
        let all_data = self.geo_log_model.SelectAll()
        var data_count = all_data.count
        var param = "&";
        for var i = 0; i < all_data.count; ++i {
            let data = all_data[i];
            for (var key_, var val_) in data {
                let val2_ = val_ as String
                key_ = (key_ == "geo_point_y" ? "y" : key_)
                key_ = (key_ == "geo_point_x" ? "x" : key_)
                param += key_ + "_\(i)=" + val2_ + "&"
                //print (key_ + "=" + val2_ + " : ;")
            }
            if i == 19 {
                data_count = 20
                break
            }
            //println("")
        }
        param += "data_count=\(data_count)"

        return param
    }
    
    //レスポンス 情報取得
    func fetchResponse(res: NSURLResponse!, data: NSData!, error: NSError!) {
        
        if error == nil {
            var myData: String = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            
            var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
            var status = (json.objectForKey("status") as! String).toInt()
            var is_automate = (json.objectForKey("is_automate") as! String).toInt()
            var message = json.objectForKey("message") as! String
            //var statu =
            sw_automate.setOn(false, animated:false)
            sw_power_on_off.setOn(false, animated:false)
            
            if is_automate == 1 {
                sw_automate.setOn(true, animated:false)
            }
            if status == 1 {
                sw_power_on_off.setOn(true, animated:false)
            }
            label_msg.text = message
        } else {
            //データ補足用バックアップ
            geo_log_model.insert(x_loc!, y: y_loc!, status: "0")
            label_msg.text = "エラーのため取得できませんでした"
        }
    }
    
    /**
     *
     */
    func retchRestore (res : NSURLResponse!, data : NSData!, error:NSError!) {
        if error == nil {
            var myData: String = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            self.label_msg.text = myData
            let ids = myData.componentsSeparatedByString(",")
            var flg = false
            for var i = 0; i < ids.count; i++ {
                if ids[i] != "" {
                    geo_log_model.deleteOne(ids[i])
                    if(!flg) {flg = true}
                }
            }
            
            if flg {
                self.restoreRequest()
            }
            //geo_log_model.deleteAll()
        }
        
    }
    
    // GPS情報をマスクする
    func maskString (input : String) -> String {
        var output : String = input
        if(sw_mask.on) {
            var output_ : String = "*"
            var input_str_count : Int = count(input);
            input_str_count--;
            output = "".stringByPaddingToLength(input_str_count, withString: output_ , startingAtIndex: 0)
            //output = NSString( format :"%*" + input_str_count.description, output)
        }
        return output
    }


}

