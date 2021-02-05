//
//  PurchasePlanVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 22/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import Braintree
import BraintreeDropIn
import UIKit

class PurchasePlanVC: baseVC, UITextFieldDelegate {
    let request = BTDropInRequest()

    // MARK: - Outlets

    @IBOutlet var lblAdditionalWarranty: UILabel!
    @IBOutlet var lbl_Price: UILabel!
    @IBOutlet var txt_Email: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    // MARK: - Variables

    var ammount = Double()
    var Wlength = Int()
    var token: String?
    var amountString = String()
    let toKinizationKey = "sandbox_24nbkcxf_g5gppcy3yx2rgxyb"
    // Production Key : - production_4xqjp2xh_wfh3yg733qxd8xr7
    //  let toKinizationKey = "sandbox_24nbkcxf_g5gppcy3yx2rgxyb"
    // sandbox_24nbkcxf_g5gppcy3yx2rgxyb

    // MARK: - Viewcontroller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        txt_Email.delegate = self

        lbl_Price.text = amountString
        if Wlength == 2 {
            lblAdditionalWarranty.text = "Extended - 2 Additional years"
        } else {
            lblAdditionalWarranty.text = "Extended - 3 Additional years"
        }

        // Do any additional setup after loading the view
        if userDefaults.string(forKey: "email") != "" {
            txt_Email.text = userDefaults.string(forKey: "email")
        }
    }

    @IBAction func clk_back(_: Any) {
        //        commonClass.popViewControllerss(viewcontroller: self, popViews: 2, animated: true)
        //    self.popViewControllerss(popViews: 2)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func clk_PlaceMyOrder(_: Any) {
        getToken()
    }

    //  makeTransactionWithPaymentMethodNonce
    // BraintreeDemoTransactionServiceThreeDSecureRequiredStatusRequired
    func sendRequestPaymentToServer(nonce: String, amount: String) {
        PaymentGatewayResponse.paymentMethodResponse(viewcontroller: self, nonce: nonce, amount: amount, WarrantyLength: Wlength.description, UID: userDefaults.string(forKey: "deviceUID")!, SerialNumber: userDefaults.string(forKey: "topic")!, Completion: { res in
            if res[0].uID != "" {
                let deviceDataList = res
                userDefaults.set(deviceDataList[0].warrantyLength, forKey: "warrantyLength")
                userDefaults.set(deviceDataList[0].warrantyStartDate, forKey: "warrantyStartDate")
                self.navigationController?.popViewController(animated: true)
                //                Alert.showAlertWithHandler(viewcontroller: self, title: AppName, message: "Successfully charged. Thanks So Much :)", handler: { (callback) in
                //
                //                })

                print(res)
            }
        }) { err in
            Alert.showAlert(viewcontroller: self, title: "Error", message: err.localizedDescription)
        }
    }

    func show(message: String) {
        DispatchQueue.main.async {
            //     self.activityIndicator.stopAnimating()

            let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func getToken() {
        WebServiceClasses.shared.requestGet(tokenUrlString ?? "", success: { dic in
            //            let json = JSON(dic)
            //            let objUserA = try! JSONDecoder().decode(DataWithToken.self, from: json.rawData())
            //            let t = objUserA.data
            // self.token =   t?.token
            self.token = dic.description
            if self.token != "" {
                //                if userDefaults.string(forKey: "warrantyLength") == nil &&   userDefaults.string(forKey: "warrantyStartDate") == nil {

                let request = BTDropInRequest()

                request.applePayDisabled = false
                request.paypalDisabled = false

                let dropIn = BTDropInController(authorization: self.token!, request: request)
                { [unowned self] controller, result, error in

                    if let error = error {
                        self.show(message: error.localizedDescription)

                    } else if result?.isCancelled == true {
                        self.show(message: "Transaction Cancelled")
                    } else if let nonce = result?.paymentMethod?.nonce {
                        self.sendRequestPaymentToServer(nonce: nonce, amount: self.ammount.description)
                    }

                    controller.dismiss(animated: true, completion: nil)
                }

                self.present(dropIn!, animated: true, completion: nil)
                //   }
                //                else {
                //
                //                    Alert.showAlertWithHandler(viewcontroller: self, title: AppName, message: "Payement is already done") { (res) in
                //                        self.navigationController?.popViewController(animated: true)
                //
                //                    }
                //                }
            }
            print(dic)

        }) { err in
            print(err)
        }

        //        self.braintree = Braintree(clientToken: clientToken)
        //                self.payButton.userInteractionEnabled = true
    }
}

extension PurchasePlanVC {
    func textFieldShouldReturn(_: UITextField) -> Bool {
        txt_Email.resignFirstResponder()
        return true
    }
}
