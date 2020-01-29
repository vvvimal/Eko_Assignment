//
//  GithubWebViewController.swift
//  Eko_Assignment
//
//  Created by Venugopalan, Vimal on 27/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import UIKit
import WebKit

class GithubWebViewController: UIViewController {
    var alert: UIAlertController!
    let webView = WKWebView(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpWebView()
    }
    
    /// Setup web view
    func setUpWebView(){
        webView.translatesAutoresizingMaskIntoConstraints = false
           self.view.addSubview(self.webView)
        webView.isAccessibilityElement = true
        webView.accessibilityLabel = "GithubWebPage"
        // You can set constant space for Left, Right, Top and Bottom Anchors
        NSLayoutConstraint.activate([
            self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
        ])
        self.view.setNeedsLayout()

    }
    
    /// Set selected user to the view
    func setUpWith(user: User) {
        self.title = user.login
        if let url = URL.init(string: user.html_url){
            let urlRequest = URLRequest.init(url: url)
            self.webView.load(urlRequest)
        }
    }

}
