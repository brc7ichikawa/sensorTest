//
//  WebVewController.swift
//  sensorTest
//
//  Created by brc7tichikawa on 2015/11/09.
//  Copyright (c) 2015年 brc7tichikawa. All rights reserved.
//
import UIKit
class MapWebViewController: UIViewController, UIWebViewDelegate {
    
    var myWebView :UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // WebViewを生成.
        myWebView = UIWebView()
        var define = Define()
        
        // Delegateを設定する.
        myWebView.delegate = self
        
        // WebViewのサイズを設定する.
        myWebView.frame = self.view.bounds
        
        // Viewに追加する.
        self.view.addSubview(myWebView)
        
        // URLを設定する.
        let url = NSURL(string: define.strReplace("%x:", to: "1", input: define.strReplace("%y:", to: "1", input: define.map_url)))
        //let requestURL = NSURL(string: url)
        //let url = NSURL(string: "指定URL")
        if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
        }
        //let req = NSURLRequest(URL: url!)
        //myWebView.loadRequest(req)
    }
    
    /*
    Pageがすべて読み込み終わった時呼ばれるデリゲートメソッド.
    */
    func webViewDidFinishLoad(webView: UIWebView) {
        print("webViewDidFinishLoad")
    }
    
    /*
    Pageがloadされ始めた時、呼ばれるデリゲートメソッド.
    */
    func webViewDidStartLoad(webView: UIWebView) {
        print("webViewDidStartLoad")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getAuthValue() -> String {
        //Authorizationヘッダーの作成
        let username = "****"
        let password = "****"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)

        return base64LoginString
    }
    
    //NSURLConnection delegate method
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        println("Failed with error:\(error.localizedDescription)")
    }
    
    //NSURLConnection delegate method
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        //New request so we need to clear the data object
        //self.data = NSMutableData()
    }
    
    //NSURLConnection delegate method
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        //Append incoming data
        //self.data.appendData(data)
    }
    
    //NSURLConnection delegate method
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        NSLog("connectionDidFinishLoading");
    }
    
}