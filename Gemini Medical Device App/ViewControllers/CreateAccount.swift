//
//  CreateAccount.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 20/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class CreateAccount: baseVC, UITextFieldDelegate {
    // MARK: - Button Outlet

    @IBOutlet var txt_FirstName: UITextField!
    @IBOutlet var txt_LastName: UITextField!
    @IBOutlet var btnCreate: UIButton!
    @IBOutlet var txt_email: UITextField!
    @IBOutlet var txt_password: UITextField!
    @IBOutlet var txt_conformPassword: UITextField!

    // MARK: - VARIABLES

    var bottomLine = CALayer()

    // MARK: - VIEW CONTROLLER LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        txt_email.delegate = self
        txt_password.delegate = self
        txt_conformPassword.delegate = self
        txt_FirstName.delegate = self
        txt_LastName.delegate = self
        DispatchQueue.main.async {
            self.txt_FirstName.addBottomBorder()
            self.txt_LastName.addBottomBorder()
            self.txt_email.addBottomBorder()
            self.txt_password.addBottomBorder()
            self.txt_conformPassword.addBottomBorder()
        }
        btnOpacity()

        // Do any additional setup after loading the view.
    }

    func btnOpacity() {
        if txt_email.text == "", txt_password.text == "", txt_conformPassword.text == "" {
            btnCreate.alpha = 0.5
            btnCreate.isEnabled = false
        } else {
            btnCreate.alpha = 1
            btnCreate.isEnabled = true
        }
    }

    // MARK: - Button actions

    @IBAction func clk_back(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func clk_createAccount(_: Any) {
        validation()
    }

    func validation() {
        if txt_FirstName.text == "" {
            commonClass.showCustomeAlert(self, messageA: "Please Enter First Name", MessageColor: "red")
        } else if txt_LastName.text == "" {
            commonClass.showCustomeAlert(self, messageA: "Please Enter Last Name", MessageColor: "red")
        } else if txt_email.text == "" {
            commonClass.showCustomeAlert(self, messageA: "Please Enter Email Id", MessageColor: "red")

        } else if !commonClass.validateEmail(enteredEmail: txt_email.text!) {
            commonClass.showCustomeAlert(self, messageA: "Please enter valid Email Id", MessageColor: "red")
        } else if txt_password.text == "" {
            commonClass.showCustomeAlert(self, messageA: "Please enter password", MessageColor: "red")
        } else if !commonClass.isPasswordValid(txt_password.text!) {
            commonClass.showCustomeAlert(self, messageA: "Password must contain 1 character, 1 special  character and minimum length 8....", MessageColor: "red")
        } else if txt_conformPassword.text == "" {
            commonClass.showCustomeAlert(self, messageA: "Please enter confirm password", MessageColor: "red")
        } else if txt_password.text != txt_conformPassword.text {
            commonClass.showCustomeAlert(self, messageA: "Please enter password and confirm password same", MessageColor: "red")
        } else if userDefaults.string(forKey: "email") != nil {
            if txt_email.text != userDefaults.string(forKey: "email") {
                deviceData.removeAll()
                DeviceListArr.removeAll()
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
            }
        } else {
            view.endEditing(true)
            callApiForCreateAccount()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txt_FirstName:
            txt_FirstName.resignFirstResponder()
            txt_LastName.becomeFirstResponder()
        case txt_LastName:

            txt_email.becomeFirstResponder()
        case txt_email:
            txt_email.resignFirstResponder()
            txt_password.becomeFirstResponder()
        case txt_password:
            txt_conformPassword.becomeFirstResponder()
        default:
            txt_conformPassword.resignFirstResponder()
        }
        return true
    }

    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString _: String) -> Bool {
        if (txt_password.text?.count)! > 0, txt_email.text != "", txt_FirstName.text != "", txt_LastName.text != "" {
            btnOpacity()
        }
        return true
    }

    // MARK: - APICALL

    func callApiForCreateAccount() {
        let dicSendData = ["email": txt_email.text, "password": txt_password.text]

        LoginModel.LoginWebService(viewcontroller: self, URL: registerUrl, dicSendData: dicSendData as [String: AnyObject], completionHandler: { Response in
            if Response.status == "Success" {
                commonClass.showCustomeAlertwithCompletion(self, messageA: "Great, let's continue!", MessageColor: "green", Duration:1, completionHandler: {
                    flag in
                    if flag {
                        DispatchQueue.main.async {
                            userDefaults.set(Response.token, forKey: logginToken)
                            userDefaults.set(Response.oBJID, forKey: loginObjId)
                            userDefaults.set(self.txt_email.text, forKey: "email")
                            /*commonClass.showCustomeAlert(self, messageA:"Registration Complete", MessageColor: "green")*/
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndCondtitionsVCViewController") as! TermsAndCondtitionsVCViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                            // let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScanYourDevice") as! ScanYourDevice
                            // self.navigationController?.pushViewController(vc, animated: true)
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
        //        WebServiceClass.shared.jsonCallwithData(dicData: dicSendData, ClassUrl:  "login.php") { (stringaa, err) in
        //
        //            print(stringaa)
        //
        //        }
    }
}
