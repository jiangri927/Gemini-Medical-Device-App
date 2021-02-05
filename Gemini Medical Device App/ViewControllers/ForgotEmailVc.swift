//
//  ForgotEmailVc.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 11/06/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class ForgotEmailVc: baseVC {
    // MARK: - Outlets

    @IBOutlet var view_EmailValidation: UIView!
    @IBOutlet var txt_forgotEmail: UITextField!

    // MARK: - Viewcontroller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        txt_forgotEmail.addBottomBorder()
        // Do any additional setup after loading the view.
    }

    // MARK: - Button Back

    @IBAction func clk_Back(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func clk_ForgotEmail(_: Any) {}

    func validationOfMail() {
        if txt_forgotEmail.text == "" {
            //   commonClass.showCustomeAlert(self, messageA: "Please enter an email address", MessageColor: "red")
            //  view_EmailValidation.isHidden = false
            view_EmailValidation.fadeIn()
            view_EmailValidation.fadeOut()
        } else if !commonClass.validateEmail(enteredEmail: txt_forgotEmail.text!) {
            view_EmailValidation.fadeIn()
            view_EmailValidation.fadeOut()

            //   commonClass.showCustomeAlert(self, messageA: "Please Enter Proper Email Id", MessageColor: "red")
        } else {}
    }
}
