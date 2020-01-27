//
//  Extensions.swift
//  Eko_Assignment
//
//  Created by Venugopalan, Vimal on 26/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import UIKit

extension UIViewController{
    func showAlert(withTitle title: String, message : String, completionHandler:(() -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel) { action in
            if let actionHandler = completionHandler{
                actionHandler()
            }
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        return alertController
    }
        
    func activityStartAnimating() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.isUserInteractionEnabled = false
        
        self.view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    func activityStopAnimating() {
        for view in self.view.subviews {
            if let subView = view as? UIActivityIndicatorView {
                subView.removeFromSuperview()
                break
            }
        }
        self.view.isUserInteractionEnabled = true
    }
}