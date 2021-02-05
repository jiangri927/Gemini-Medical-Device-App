//
//  ForgotPasswordVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 20/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class ForgotPasswordVC: baseVC, UITextFieldDelegate {
    @IBOutlet var txt_forgotPassword: UITextField!

    @IBOutlet var view_EmailValidation: UIView!

    @IBOutlet var view_InvalidEmailAlert: UIView!

    // MARK: - View Controller  Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        txt_forgotPassword.delegate = self
        DispatchQueue.main.async {
            self.txt_forgotPassword.addBottomBorder()
        }
        view_EmailValidation.isHidden = true
        view_InvalidEmailAlert.isHidden = true

        // Do any additional setup after loading the view.
    }

    @IBAction func clk_back(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func clk_forgotPassword(_: Any) {
        validationOfMail()
    }

    func validationOfMail() {
        if txt_forgotPassword.text == "" {
            //   commonClass.showCustomeAlert(self, messageA: "Please enter an email address", MessageColor: "red")
            //  view_EmailValidation.isHidden = false
            view_EmailValidation.fadeIn()
            view_EmailValidation.fadeOut()
        } else if !commonClass.validateEmail(enteredEmail: txt_forgotPassword.text!) {
            view_EmailValidation.fadeIn()
            view_EmailValidation.fadeOut()

            //   commonClass.showCustomeAlert(self, messageA: "Please Enter Proper Email Id", MessageColor: "red")
        } else {
            callApi()
        }
    }

    // MARK: - APICALL

    func callApi() {
        let dicSendData = ["email": txt_forgotPassword.text]

        WebServiceClasses.shared.requestPOSTURL("forgot.php", progress: true, params: dicSendData as [String: AnyObject], headers: ["String": ""], success: { dic in
            print(dic)

            if dic.value(forKey: "status") as! String == "Success" {
                commonClass.showCustomeAlert(self, messageA: "Password reset link sent to your email..! Please check your mail", MessageColor: "green")
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "forgotEmailPasswordVC") as! forgotEmailPasswordVC
                    vc.emailA = self.txt_forgotPassword.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                self.view_InvalidEmailAlert.fadeIn()
                self.view_InvalidEmailAlert.fadeOut()
                // commonClass.showCustomeAlert(self, messageA: dic.value(forKey: "response") as! String, MessageColor: "red")

                print("Not Valid")
            }

        }) { err in
            print(err)
        }
        //        WebServiceClass.shared.jsonCallwithData(dicData: dicSendData, ClassUrl:  "login.php") { (stringaa, err) in
        //
        //            print(stringaa)
        //
        //        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
