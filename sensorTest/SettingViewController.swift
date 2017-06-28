//
//  SettingViewController.swift
//  sensorTest
//
//  Created by brc7tichikawa on 2015/10/29.
//  Copyright (c) 2015年 brc7tichikawa. All rights reserved.
//
import UIKit
import CoreLocation
class SettingViewController: UIViewController, CLLocationManagerDelegate {
    
    
    var define = Define()
    let GO_FROM_TAG = 1
    let GO_TO_TAG = 2
    let RET_FROM_TAG = 3
    let RET_TO_TAG = 4
    let GO_SAT_FROM_TAG = 5
    let GO_SAT_TO_TAG = 6
    let RET_SAT_FROM_TAG = 7
    let RET_SAT_TO_TAG = 8
    
    var selected_label : UILabel!
    
    @IBOutlet weak var seg_controller: UISegmentedControl!
    
    @IBOutlet weak var label_date_from: UILabel!
    @IBOutlet weak var label_date_to: UILabel!
    @IBOutlet weak var label_return_from: UILabel!
    @IBOutlet weak var label_return_to: UILabel!
    @IBOutlet weak var date_picker: UIDatePicker!

    @IBOutlet weak var label_sat_from: UILabel!
    @IBOutlet weak var label_sat_to: UILabel!
    @IBOutlet weak var label_sat_ret_from: UILabel!
    @IBOutlet weak var label_sat_ret_to: UILabel!
    
    var pickerDataSource = ["MASK", "DETAIL"];
    var selected_value = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestSetting()
    }
    
    // サーバ側に保存
    @IBAction func buttonSaveTouchDown(sender: AnyObject) {
        var url = self.define.strReplace("%x:", to: "1", input: define.setting_save_url)
        url = self.define.strReplace("%y:", to: "1", input: url)
        self.define.commonRequetPost(url, param: self.makePostData(), completionHandler:{ data, response, error in
            
            //if succeed post
            if (error == nil) {
                var result = NSString(data:data, encoding: NSUTF8StringEncoding)!
                //結果を出力
                if result == "1" {
                    self.presentViewController(self.define.alert("保存しました"), animated: true, completion: nil)
                }
            } else {
                println(error)
                self.presentViewController(self.define.alert("エラー"), animated: true, completion: nil)
            }
        })
    }

    // セッティング情報取得リクエスト
    func requestSetting () {
        var url = define.setting_url;
        url = define.setting_url.stringByReplacingOccurrencesOfString("%x:", withString: "1").stringByReplacingOccurrencesOfString("%y:", withString : "1")
        var request_url = url.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        define.commonRequestUrl(request_url, completionHandler: { (res, data, error) -> Void in
            if error == nil {
                var myData: String = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
                var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
                
                self.label_date_from.text = self.define.strReplace(":", to: "時", input: json.objectForKey("go_from") as! String) + "分"
                self.label_date_to.text = self.define.strReplace(":", to: "時", input: json.objectForKey("go_to") as! String) + "分"
                self.label_return_from.text = self.define.strReplace(":", to: "時", input: json.objectForKey("back_from") as! String) + "分"
                self.label_return_to.text = self.define.strReplace(":", to: "時", input: json.objectForKey("back_to") as! String) + "分"
                self.label_sat_from.text = self.define.strReplace(":", to: "時", input: json.objectForKey("sat_go_from") as! String) + "分"
                self.label_sat_to.text = self.define.strReplace(":", to: "時", input: json.objectForKey("sat_go_to") as! String) + "分"
                self.label_sat_ret_from.text = self.define.strReplace(":", to: "時", input: json.objectForKey("sat_back_from") as! String) + "分"
                self.label_sat_ret_to.text = self.define.strReplace(":", to: "時", input: json.objectForKey("sat_back_to") as! String) + "分"
                
                var selected_index = 0
                if json.objectForKey("map_type") as! String == "DETAIL"  {
                        selected_index = 1
                }
                self.selected_value = json.objectForKey("map_type") as! String
//                    self.picker_view.selectRow(selected_index, inComponent: 0, animated: false)
                self.seg_controller.selectedSegmentIndex = selected_index

            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    @IBAction func dateButtonTouchDown(sender: AnyObject) {
        
        switch (sender.tag) {
            case GO_FROM_TAG:
                self.selected_label = label_date_from
                break
            case GO_TO_TAG:
                self.selected_label = label_date_to
                break
            case RET_FROM_TAG:
                self.selected_label = label_return_from
                break
            case RET_TO_TAG:
                self.selected_label = label_return_to
                break
            case GO_SAT_FROM_TAG:
                self.selected_label = label_sat_from
                break
            case GO_SAT_TO_TAG:
                self.selected_label = label_sat_to
                break
            case RET_SAT_FROM_TAG:
                self.selected_label = label_sat_ret_from
                break
            case RET_SAT_TO_TAG:
                self.selected_label = label_sat_ret_to
                break
            default :
                break
        }
        
        if date_picker.hidden == true {
            date_picker.hidden = false
        }
        
        var date_sp_str = self.selected_label.text
        var date_sp_str_uw = date_sp_str!.stringByReplacingOccurrencesOfString("時", withString : ":").stringByReplacingOccurrencesOfString("分", withString : "")
        var date_sp = date_sp_str_uw.componentsSeparatedByString(":")
        if date_sp.count == 2 {
            var dateString = "1979-01-01 " + date_sp_str_uw + ":00"
            self.date_picker.setDate(makeTimeDefalutDatePicker(dateString), animated: true)
        }
    }
    
    private func makeTimeDefalutDatePicker ( dateString : String) -> NSDate {
        var df = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "ja")
        df.dateFormat = "yyyy/MM/dd HH:mm:ss"
        var date = df.dateFromString(dateString)
        
        return date!
    }
    
    private func makePostData () -> String {
        let g_f = define.strReplace("分", to: "", input: define.strReplace("時", to: ":", input: self.label_date_from.text!))
        let g_t = define.strReplace("分", to: "", input: define.strReplace("時", to: ":", input: self.label_date_to.text!))
        let b_f = define.strReplace("分", to: "", input: define.strReplace("時", to: ":", input: self.label_return_from.text!))
        let b_t = define.strReplace("分", to: "", input: define.strReplace("時", to: ":", input: self.label_return_to.text!))
        let s_g_f = define.strReplace("分", to: "", input: define.strReplace("時", to: ":", input: self.label_sat_from.text!))
        let s_g_t = define.strReplace("分", to: "", input: define.strReplace("時", to: ":", input: self.label_sat_to.text!))
        let s_b_f = define.strReplace("分", to: "", input: define.strReplace("時", to: ":", input: self.label_sat_ret_from.text!))
        let s_b_t = define.strReplace("分", to: "", input: define.strReplace("時", to: ":", input: self.label_sat_ret_to.text!))
        
        var param = "go_from=\(g_f)&go_to=\(g_t)&back_from=\(b_f)&back_to=\(b_t)&sat_go_from=\(s_g_f)&sat_go_to=\(s_g_t)&sat_back_from=\(s_b_f)&sat_back_to=\(s_b_t)&map_type=" + self.selected_value
        return param
    }
    
    @IBAction func datePickerValueChanged(sender: AnyObject) {
        self.selected_label.text = self.define.makeTime(date_picker.date, format: "HH時mm分")
    }
    
    @IBAction func segValueChanged(sender: AnyObject) {
        var seg_index = seg_controller.selectedSegmentIndex
        self.selected_value = pickerDataSource[seg_index]
        
    }

    // 戻るボタン
    @IBAction func returnButtonOnTouchDown(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if self.date_picker.hidden == false {
            self.date_picker.hidden = true
        }
    }
    

}