//
//  Alert+Block.swift
//
//  Created by Sandip Patel (SM) on 25/05/18.
//  Copyright © 2018 Sandip Patel (SM). All rights reserved.
//

import Foundation
import UIKit

enum AlertAction {
    case Ok
    case Cancel
}

typealias AlertCompletionHandler = ((_ index: AlertAction) -> Void)?
typealias AlertCompletionHandlerInt = ((_ index: Int) -> Void)

class Alert: UIViewController {
    class func showAlert(viewcontroller: UIViewController, title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewcontroller.present(alert, animated: true)
    }

    class func showAlertWithHandler(viewcontroller: UIViewController, title: String?, message: String?, handler: AlertCompletionHandler) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            handler?(AlertAction.Ok)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            handler?(AlertAction.Cancel)
        }))
        viewcontroller.present(alert, animated: true)
    }

    class func showAlertWithHandler(viewcontroller: UIViewController, title: String?, message: String?, okButtonTitle: String, cancelButtionTitle: String, handler: AlertCompletionHandler) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: { _ in
            handler?(AlertAction.Ok)
        }))

        alert.addAction(UIAlertAction(title: cancelButtionTitle, style: .default, handler: { _ in
            handler?(AlertAction.Cancel)
        }))

        viewcontroller.present(alert, animated: true)
    }

    class func showAlertWithHandler(viewcontroller: UIViewController, title: String?, message: String?, buttonsTitles: [String], showAsActionSheet: Bool, handler: @escaping AlertCompletionHandlerInt) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: showAsActionSheet ? .actionSheet : .alert)

        for btnTitle in buttonsTitles {
            alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: { _ in
                handler(buttonsTitles.firstIndex(of: btnTitle)!)
            }))
        }

        viewcontroller.present(alert, animated: true)
    }
}

// MARK: - USage of all above alert

/* import UIKit

 class ViewController: UIViewController {

 override func viewDidLoad() {
     super.viewDidLoad()
     // Do any additional setup after loading the view, typically from a nib.
 }

 override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
     // Dispose of any resources that can be recreated.
 }

 @IBAction func showDefaultAlert(_ sender: Any) {
     Alert.showAlert(title:"Alert", message:"Default Alert")
 }

 @IBAction func showDefaultAlertWithActionBlock(_ sender: Any) {
     Alert.showAlertWithHandler(title:"Alert", message:"Alert with ActionBlock") { (index) in
         switch(index){
         case AlertAction.Ok:
             print("Ok button pressed")
         case AlertAction.Cancel:
             print("Cancel button pressed")
         }
     }
 }

 @IBAction func showAlertWithCustomTitle(_ sender: Any) {

     Alert.showAlertWithHandler(title: "Alert", message: "Alert with custom button text and ActionBlock", okButtonTitle: "YES", cancelButtionTitle: "NO") { (index) in
         switch(index){
         case AlertAction.Ok:
             print("YES button pressed")
         case AlertAction.Cancel:
             print("NO button pressed")
         }
     }
 }

 @IBAction func showAlertWithMoreButtons(_ sender: Any) {
     let buttons = ["First Button", "Second Button", "Third Button", "Forth Button"]

     Alert.showAlertWithHandler(title: "Alert", message: "Alert with four buttons", buttonsTitles: buttons, showAsActionSheet: false) { (index) in
         switch(index){
         case 0:
             print("First button pressed")
         case 1:
             print("Second button pressed")
         case 2:
             print("Third button pressed")
         case 3:
             print("Forth button pressed")
         default:
             print("Nothing")
         }
     }
 }

 @IBAction func showAlertAsActionSheet(_ sender: Any) {
     let buttons = ["First Button", "Second Button", "Third Button", "Cancel"]

     Alert.showAlertWithHandler(title: "Alert", message: "Actionsheet with four buttons", buttonsTitles: buttons, showAsActionSheet: true) { (index) in
         switch(index){
         case 0:
             print("First button pressed")
         case 1:
             print("Second button pressed")
         case 2:
             print("Third button pressed")
         case 3:
             print("Cancel button pressed")
         default:
             print("Nothing")
         }
     }
 }
 }

 */
