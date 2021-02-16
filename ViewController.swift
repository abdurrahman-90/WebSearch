//
//  ViewController.swift
//  WebSearch
//
//  Created by Akdag on 16.02.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController  {

    @IBOutlet weak var ProgressBar: UIProgressView!
    @IBOutlet weak var reloadBtn: UIBarButtonItem!
    @IBOutlet weak var forwardBtn: UIBarButtonItem!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var searchText: UITextField!
    
    
    var urlStr : String = "https://www.apple.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        
        backBtn.isEnabled = false
        forwardBtn.isEnabled = false
        
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.load(urlStr)
       
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading"{
            backBtn.isEnabled = webView.canGoBack
            forwardBtn.isEnabled = webView.canGoForward
        }else if keyPath == "estimatedProgress"{
            ProgressBar.isHidden = webView.estimatedProgress == 1
            ProgressBar.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }

    @IBAction func Back(_ sender: Any) {
        webView.goBack()
        
    }
    @IBAction func Forward(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func ReloadBtn(_ sender: Any) {
        webView.reload()
    }
}
extension ViewController :UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchText.resignFirstResponder()
    
        if let str = textField.text {
            urlStr = "https://" + str
            webView.load(urlStr)
        }
        return false
    }
    
}
extension ViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        searchText.text = webView.url?.absoluteString
        
        ProgressBar.setProgress(0.0, animated: true)
    }
}

extension WKWebView {
    func load( _ urlString : String){
        
        if let url = URL(string: urlString){
            let request = URLRequest(url: url)
            load(request)
        }
        
    }
}
