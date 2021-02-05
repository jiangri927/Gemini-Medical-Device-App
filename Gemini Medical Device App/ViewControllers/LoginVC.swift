//
//  LoginVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 20/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class LoginVC: baseVC, UITextFieldDelegate {
    // MARK: - button outlet

    @IBOutlet var btn_SignIn: UIButton!
    @IBOutlet var txt_password: UITextField!
    @IBOutlet var txt_email: UITextField!

    // MARK: - View controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        txt_email.delegate = self
        txt_password.delegate = self
        DispatchQueue.main.async {
            self.txt_email.addBottomBorder()
            self.txt_password.addBottomBorder()
        }
        btnOpacity()
    }

    override func viewWillAppear(_: Bool) {
        if userDefaults.string(forKey: logginToken) != nil {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: Button Actions

    @IBAction func clk_back(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func clk_signIn(_: Any) {
        //         let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
        //       self.navigationController?.pushViewController(vc, animated: true)
        validation()
    }

    @IBAction func clk_forgotPassword(_: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func clk_forgotEmail(_: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotEmailVc") as! ForgotEmailVc
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Validation

    func validation() {
        if txt_email.text == "" {
            commonClass.showCustomeAlert(self, messageA: "Please Enter Email Id", MessageColor: "red")

        } else if !commonClass.validateEmail(enteredEmail: txt_email.text!) {
            commonClass.showCustomeAlert(self, messageA: "Please Enter valid Email Id", MessageColor: "red")
        } else if txt_password.text == "" {
            commonClass.showCustomeAlert(self, messageA: "Please Enter password", MessageColor: "red")
        } else if userDefaults.string(forKey: "email") != nil {
            if txt_email.text != userDefaults.string(forKey: "email") {
                deviceData.removeAll()
                DeviceListArr.removeAll()
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
            } else {
                view.endEditing(true)
                callApiForLogin()
            }
        } else {
            view.endEditing(true)
            callApiForLogin()
        }
    }

    func btnOpacity() {
        if txt_email.text == "", txt_password.text == "" {
            btn_SignIn.alpha = 0.5
            btn_SignIn.isEnabled = false
        } else {
            btn_SignIn.alpha = 1
            btn_SignIn.isEnabled = true
        }
    }

    // TEXTFIELD METHODS
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txt_email:
            txt_email.resignFirstResponder()
            txt_password.becomeFirstResponder()
        default:
            txt_password.resignFirstResponder()
        }
        return true
    }

    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString _: String) -> Bool {
        if (txt_password.text?.count)! > 0, txt_email.text != "" {
            btnOpacity()
        }
        return true
    }

    // MARK: - API CALl

    func callApiForLogin() {
        let dicSendData = ["email": txt_email.text, "password": txt_password.text] as [String: AnyObject]
        LoginModel.LoginWebService(viewcontroller: self, URL: loginUrl, dicSendData: dicSendData, completionHandler: { Response in
            if Response.status == "Success" {
                commonClass.showCustomeAlertwithCompletion(self, messageA: "Logged-In successfully..!", MessageColor: "green", Duration:2, completionHandler: {
                    flag in
                    if flag {
                        DispatchQueue.main.async {
                            userDefaults.set(Response.token, forKey: logginToken)
                            userDefaults.set(Response.oBJID, forKey: loginObjId)
                            userDefaults.set(self.txt_email.text, forKey: "email")
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                })
            } else {
                commonClass.showCustomeAlert(self, messageA: Response.response!, MessageColor: "red")
            }
            print(Response)
        }) { err in
            commonClass.showCustomeAlert(self, messageA: err.localizedDescription, MessageColor: "red")
        }
    }

    //    {
    //
    //        WebServiceClasses.shared.requestPOSTURL("login.php", params: dicSendData as [String : AnyObject], headers: ["String" : ""], success: { (dic) in
    //            print(dic)
    //
    //
    //
    //
    //            commonClass.addCurrentUserDictToDefaults(dict: dic)
    //            if dic.value(forKey: "status") as! String == "Success" {
    //
    //                commonClass.showCustomeAlertWithAction(self, messageA: "Logged-In successfully..!", butonTitle: "OK", MessageColor: "green", completionHandler: {
    //                    (flag) in
    //
    //                 //   if flag == true {
    //                        DispatchQueue.main.async {
    //                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
    //                            self.navigationController?.pushViewController(vc, animated: true)
    //
    //                 //       }
    //
    //                    }
    //                })
    //
    //
    //
    //
    //
    //
    //            }
    //            else {
    //                commonClass.showCustomeAlert(self, messageA: dic.value(forKey: "response") as! String, MessageColor: "red")
    //
    //                print("Not Valid")
    //            }
    //
    //        }) { (err) in
    //            print(err)
    //        }
    //        //        WebServiceClass.shared.jsonCallwithData(dicData: dicSendData, ClassUrl:  "login.php") { (stringaa, err) in
    //        //
    //        //            print(stringaa)
    //        //
    //        //        }
    //    }
    //
}
