//
//  UIviewController+Alert.swift
//  Media
//
//  Created by Apple on 17/12/2022.
//

import UIKit

extension UIViewController {
     func showAlert(title:String,message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
