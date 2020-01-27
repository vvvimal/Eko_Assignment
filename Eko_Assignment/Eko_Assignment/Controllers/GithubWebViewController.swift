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

    private let webView = WKWebView(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setUpWebView()
    }
    
    func setUpWebView(){
        webView.translatesAutoresizingMaskIntoConstraints = false
           self.view.addSubview(self.webView)
        // You can set constant space for Left, Right, Top and Bottom Anchors
                            NSLayoutConstraint.activate([
                                self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                                self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                                self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                ])
            // For constant height use the below constraint and set your height constant and remove either top or bottom constraint
            //self.webView.heightAnchor.constraint(equalToConstant: 200.0),

            self.view.setNeedsLayout()
//            var request = URLRequest(url: URL.init(string: "https://www.google.com"))
//            self.webView.load(request)
    }
    
    /// Set selected tag name to viewmodel
    func setUpWith(user: User) {
        if let url = URL.init(string: user.html_url){
            let urlRequest = URLRequest.init(url: url)
            self.webView.load(urlRequest)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
