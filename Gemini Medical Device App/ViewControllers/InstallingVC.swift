//
//  InstallingVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 07/06/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import AMProgressBar
import UIKit
protocol linearProgressData {
    func ProgressStatus(_ status: Double)
    func ProgressComplete(_ status: Int)
}

class InstallingVC: baseVC {
    // MARK: - Variables

    var timer: Timer!
    var counter: Double = 0
    var countDown = 15
    var countBack = 3
    var isTimerOn = false
    var Payloadpublish = [Payload]()
    var TempVar = 0.0

    // MARK: - Outlets

    @IBOutlet var Temp: CustProgressBar!
    @IBOutlet var lbl_Percentage: UILabel!
    @IBOutlet var btn_Install: UIButton!
    @IBOutlet var btn_updateStatus: UIButton!
    @IBOutlet var btn_TickupdateComplete: UIButton!
    @IBOutlet var btn_RetryUpdate: UIButton!
    @IBOutlet var progressBarBottom: AMProgressBar!
    @IBOutlet var progressBarTop: AMProgressBar!
    @IBOutlet var viewProgressBar: UIView!

    // MARK: - Viewcontroller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        progressBarTop.setProgress(progress: 0.8, animated: true)
        commonClass.delegate = self
        btn_updateStatus.isHidden = true
        btn_RetryUpdate.isHidden = true
        btn_TickupdateComplete.isHidden = true
        DispatchQueue.main.async {
            self.progressBarBottom.setProgress(progress: 1, animated: true)
        }

        progressBarTop.setProgress(progress: CGFloat(0.0), animated: true)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_: Bool) {
        btn_Install.isEnabled = true
    }

    // MARK: - Button Actions

    @IBAction func clk_Install(_: Any) {
        btn_Install.isEnabled = false
        btn_Install.setTitle("Installing", for: .normal)
        AWSConfig.shared.publish(topicA: userDefaults.string(forKey: "topic")!, deviceUId: userDefaults.string(forKey: "deviceUID")!)

        countDown = 15
        //  self.Temp.setProgress(flag: false, progress: 100)
        TimerForFive()

        //    commonClass.popViewControllerss(viewcontroller: self, popViews: 2, animated: true)
    }

    @IBAction func clk_updateStatus(_: Any) {
        if btn_updateStatus.titleLabel?.text == "UPDATE COMPLETED" {
            stopTimer()
            print("Timer Stopped")
            navigationController?.popViewController(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func clk_tickUpdateComplete(_: Any) {
        stopTimer()
        print("Timer Stopped")
        navigationController?.popViewController(animated: true)
    }

    @IBAction func clk_RetryUpdate(_: Any) {
        Temp.reset()
        viewProgressBar.isHidden = false
        lbl_Percentage.text = "0 %"
        btn_Install.isHidden = false
        btn_Install.isEnabled = true
        btn_RetryUpdate.isHidden = true
        btn_updateStatus.isHidden = true
        AWSConfig.shared.publish(topicA: userDefaults.string(forKey: "topic")!, deviceUId: userDefaults.string(forKey: "deviceUID")!)
        btn_Install.setTitle("Install", for: .normal)
        lbl_Percentage.isHidden = false
    }

    func handleTap() {
//        progressBar.isHidden = false
//        bgView.isHidden = false
//        view_ProgressBar.isHidden  = false

        if isTimerOn {
            guard timer != nil else { return }
            timer?.invalidate()
            timer = nil
            counter = 0
            btn_Install.isHidden = true
            viewProgressBar.isHidden = true
            btn_TickupdateComplete.isHidden = false
            btn_updateStatus.isHidden = false

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
        if deviceData[0].updating != nil {
            counter += Double(deviceData[0].updating!) / 100.0
        }

//        labeltext.text = "CREATING ACCOUNT"
//        progressBar.progress = counter
//
        progressBarTop.setProgress(progress: CGFloat(counter), animated: true)
    }

    @objc func countThree() {
        if countBack != 0 {
            countBack -= 1
            print(countBack)
        } else {
            timer?.invalidate()
            timer = nil
            // countBack = 3
            print("Pop view call")
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @objc func countfive() {
        if countDown != 0 {
            countDown -= 1
            print(countDown)
        } else {
            timer?.invalidate()
            timer = nil
            countDown = 1
            print("Its Fail ")
            DispatchQueue.main.async {
                self.btn_RetryUpdate.isHidden = false
                self.btn_updateStatus.isHidden = false
                self.btn_updateStatus.backgroundColor = .red
                self.btn_updateStatus.setTitle("UPDATE FAILED", for: .normal)
                self.lbl_Percentage.isHidden = true
                self.btn_Install.isHidden = true
                self.viewProgressBar.isHidden = true
            }
        }
    }

    func TimerForFive() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(countfive), userInfo: nil, repeats: true)
    }

    func TimerForThree() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(countThree), userInfo: nil, repeats: true)
    }

    func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }

//    deinit {
//        stopTimer()
//    }
}

extension InstallingVC: linearProgressData {
    func ProgressComplete(_ status: Int) {
        if status == 1 {
            DispatchQueue.main.async {
                self.Temp.setProgress(flag: false, progress: Int(100))
                self.lbl_Percentage.isHidden = true
                self.btn_Install.isHidden = true
                self.viewProgressBar.isHidden = true
                self.btn_TickupdateComplete.isHidden = false
                self.btn_updateStatus.isHidden = false
                // self.btn_updateStatus.backgroundColor =
                self.btn_updateStatus.setTitle("UPDATE COMPLETED", for: .normal)
                self.TimerForThree()
            }
        } else {
            DispatchQueue.main.async {
                self.Temp.reset()
                self.lbl_Percentage.text = "0 %"
                self.btn_RetryUpdate.isHidden = false
                self.btn_updateStatus.isHidden = false
                self.btn_updateStatus.backgroundColor = .red
                self.btn_updateStatus.setTitle("UPDATE FAILED", for: .normal)
                self.lbl_Percentage.isHidden = true
                self.btn_Install.isHidden = true
                self.viewProgressBar.isHidden = true
            }
        }
    }

    func ProgressStatus(_ status: Double) {
        DispatchQueue.main.async {
            if status > self.TempVar {
                self.TempVar = status
                if status == 100 {
                    self.countDown = 10000
                    self.stopTimer()
                } else {
                    self.countDown = 5
                    print(self.TempVar)
                }
            }
            print("--------- Status :-", status)
            self.lbl_Percentage.text = "\(Int(status)) %"

            let statusProgrss: CGFloat = CGFloat(status / 100.0)
            self.progressBarTop.setProgress(progress: CGFloat(statusProgrss), animated: true)
            self.Temp.setProgress(flag: false, progress: Int(status))
        }
    }
}
