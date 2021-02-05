//
//  AddAccountVCViewController.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 28/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import AMProgressBar
import UIKit
protocol isBarcodeValidate {
    func BarcodeIsWrong(flag: Bool)
}

class AddAccountVCViewController: baseVC, UITextFieldDelegate {
    // MARK: - OUTLETS

    @IBOutlet var Temp: CustProgressBar!
    @IBOutlet var progressBarBottom: AMProgressBar!
    @IBOutlet var txt_deviceName: UITextField!
    @IBOutlet var progressBarTop: AMProgressBar!
    @IBOutlet var view_ProgressBar: UIView!

    // MARK: - VARIABLES

    var code = String()
    var serialID = String()
    var UId = String()
    var delegate: isBarcodeValidate?
    let progressBar = TYProgressBar()
    var bgView = UIView()
    var labeltext = UILabel()
    var timer: Timer!
    var counter: Double = 0
    var isTimerOn = false

    // MARK: - Viewcontroller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressBar()
        progressBar.isHidden = true
        bgView.isHidden = true
        view_ProgressBar.isHidden = true
        txt_deviceName.delegate = self
        if code != "" {
            let str = code.components(separatedBy: ",")
            if str.count == 2 {
                serialID = str[0]
                UId = str[1]
                UId = UId.replacingOccurrences(of: "\u{1B}", with: "", options: NSString.CompareOptions.literal, range:nil)

                txt_deviceName.text = serialID

                //userDefaults.set(serialID, forKey: "topic")
                //userDefaults.set(UId, forKey: "deviceUID")

            } else {
                commonClass.showCustomeAlertwithCompletion(self, messageA: "This is not our barcode... Please scan proper barocode", MessageColor: "red", Duration:2, completionHandler: { flag in
                    if flag {
                        self.delegate?.BarcodeIsWrong(flag: true)
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_: Bool) {
        progressBar.isHidden = true
        bgView.isHidden = true
    }

    // MARK: - Click actions

    @IBAction func clk_back(_: Any) {
        commonClass.popViewControllerss(viewcontroller: self, popViews: 2, animated: true)
    }

    @IBAction func clk_registerDevice(_: Any) {
        if WebServiceClasses.Connectivity.isConnectedToInternet == false {
            commonClass.showCustomeAlert(self, messageA: "Please check your internet-connection", MessageColor: "red")
        } else {
            validation()
        }
    }

    // MARK: - Custome methods

    func setupProgressBar() {
        bgView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        progressBar.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - 50, y: (UIScreen.main.bounds.height / 2) - 50, width: 100, height: 100)
        labeltext = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 150, y: (UIScreen.main.bounds.height / 2) + 10, width: UIScreen.main.bounds.width, height: 50))

        progressBarBottom.setProgress(progress: 1, animated: false)

        //  progressBar.center = view.center
        progressBar.gradients = [#colorLiteral(red: 1, green: 0.7254901961, blue: 0.06666666667, alpha: 1), #colorLiteral(red: 1, green: 0.7254901961, blue: 0.06666666667, alpha: 1)]
        progressBar.lineDashPattern = [2, 3]
        progressBar.textColor = .white
        //  labeltext.center = view.center
        //labeltext.center = bgView.center
        labeltext.center.x = bgView.center.x

        progressBar.lineHeight = 15

        labeltext.numberOfLines = 3
        labeltext.textAlignment = .center
        labeltext.textColor = .white
        bgView.backgroundColor = .black
        view.addSubview(bgView)
        bgView.addSubview(labeltext)

        bgView.addSubview(view_ProgressBar)
        //  self.bgView.addSubview(progressBar)
    }

    func handleTap() {
        progressBar.isHidden = false
        bgView.isHidden = false
        view_ProgressBar.isHidden = false
        setupProgressBar()
        if isTimerOn {
            guard timer != nil else { return }
            timer?.invalidate()
            timer = nil
            counter = 0

        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ticker), userInfo: nil, repeats: true)
        }

        isTimerOn = !isTimerOn
    }

    @objc func ticker() {
        if counter > 1 {
            timer.invalidate()
            counter = 0
            isTimerOn = !isTimerOn
            handleTap()
            return
        }

        counter += 0.02
        labeltext.text = "CREATING ACCOUNT"
        progressBar.progress = counter
        Temp.setProgress(flag: true, progress: 0)
        progressBarTop.setProgress(progress: CGFloat(counter), animated: true)
    }

    // MARK: - validations

    func validation() {
        if code == "" {
            commonClass.showCustomeAlert(self, messageA: "Please scan barcode again", MessageColor: "red")
        } else if commonClass.getloginDetails().oBJID == "" || commonClass.getloginDetails().token == "" {
            commonClass.showCustomeAlert(self, messageA: "There is an issue with your login,  \n Please login again.", MessageColor: "red")
        }
//        else if txt_deviceName.text == "" || txt_deviceName.text?.count == 0 {
//              commonClass.showCustomeAlert(self, messageA: "Please add device nick name. ", MessageColor: "red")
//        }
        else {
            view.endEditing(true)
            callApiToRegisterDevice()
        }
    }

    // MARK: - API CALL

    func callApiToRegisterDevice() {
        handleTap()
        let uID = UId as String
        let dicdata = ["LoginID": commonClass.getloginDetails().oBJID, "token": commonClass.getloginDetails().token, "SerialNumber": serialID, "UID": UId, "Nickname": txt_deviceName.text ?? ""] as [String: AnyObject]
        RegisterDeviceModel.RegisterDeviceWebService(viewcontroller: self, progress: false, DicData: dicdata, completionHandler: { responseData in
//            self.isTimerOn = true
//            self.labeltext.text = "Account Created"
            
            let data = responseData as! Dictionary<String, Any>
            let status = data["status"] as! String
            
            if (status != "Error") {
                
                DispatchQueue.main.async {
                    if self.labeltext.text == "CREATING ACCOUNT" {
                        self.labeltext.text = "ACCOUNT CREATED"
                    }
                }

                if (self.timer != nil) {
                    self.timer.invalidate()
                }
                
                self.isTimerOn = true
                self.progressBarTop.setProgress(progress: CGFloat(1), animated: true)
                self.progressBar.progress = 1
                commonClass.showCustomeAlertwithCompletion(self, messageA: "Device registed successfully!", MessageColor: "green", Duration:2, completionHandler: { flag in
                    if flag {
                        userDefaults.set(self.UId, forKey: "deviceUID")
                        userDefaults.set(self.serialID, forKey: "topic")
                        userDefaults.set(self.txt_deviceName.text, forKey: "deviceHeader")
                        commonClass.DefaultDeviceSubscriptionDataForApp(Completion: { po in
                            print("After scanning device", po)
                        })
                        self.bgView.isHidden = true
                        if WebServiceClasses.Connectivity.isWifiConnected == true {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StepOneViewController") as! StepOneViewController

                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StepOneViewController") as! StepOneViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                })
                
            } else {
                self.bgView.isHidden = true
                if (self.timer != nil) {
                    self.timer.invalidate()
                }
                //commonClass.showCustomeAlert(self, messageA: response, MessageColor: "red")
                let response = data["response"] as! String
                
                let alert = UIAlertController(title: response, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    self.backNavigation()
                }))
                self.present(alert, animated: true, completion: nil)
            }

        }) { err in
            self.bgView.isHidden = true
            self.timer.invalidate()
            commonClass.showCustomeAlert(self, messageA: err.localizedDescription, MessageColor: "red")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func backNavigation() {
        
        let MainMenu: UIViewController = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
        
        NSLog("nav count: %d", navigationController!.viewControllers.count)
        if navigationController!.viewControllers.count > 6 {
            let vc = navigationController!.viewControllers[navigationController!.viewControllers.count - 5]
            let nav: UIViewController = storyboard?.instantiateViewController(withIdentifier: "TermsAndCondtitionsVCViewController") as! TermsAndCondtitionsVCViewController

            if vc.isKind(of: nav.classForCoder) {
                let Nvc = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
                navigationController?.pushViewController(Nvc, animated: true)
            } else {
                for controller in navigationController!.viewControllers as Array {
                    if controller.isKind(of: MainMenu.classForCoder) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }

        } else {
            for controller in navigationController!.viewControllers as Array {
                if controller.isKind(of: MainMenu.classForCoder) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
}
