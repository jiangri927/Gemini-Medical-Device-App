//
//  DownloadVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 22/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import AMProgressBar
import UIKit
protocol circularProgressStatus {
    func Status(_ Sender: Int)
}

protocol DeviceResponseDelegate: class {
    func ResponseOfDevice(_ payload: [Payload])
}

@available(iOS 10.0, *)
class DownloadVC: baseVC {
    // MARK: - outlets

    @IBOutlet var progressBarTop: AMProgressBar!

    @IBOutlet var progressBarBottom: AMProgressBar!
    @IBOutlet var btn_install: UIButton!
    @IBOutlet var View_circularProgressBar: CircularProgressBar!

    // MARK: - Viewcontroller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        View_circularProgressBar.delegate = self
        progressBarBottom.setProgress(progress: CGFloat(1), animated: true)
        progressBarTop.setProgress(progress: 0.01, animated: true)
        btn_install.isEnabled = false
        btn_install.alpha = 0.20

        // print("Download screen",deviceData)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_: Bool) {
        commonClass.DefaultDeviceSubscriptionDataForApp { po in
            deviceData = [po]
            // print("Download", deviceData)
//            if let progress = deviceData[0].updating {
//                self.Status(progress)
//            }
        }
        //    progressBarTop.setProgress(progress: CGFloat(0.0), animated: true)
        // progressBarBottom.setProgress(progress: CGFloat(1.0), animated: false)
    }

    // MARK: - Button Actions

    @IBAction func clk_back(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func clk_download(_: Any) {
        //       AWSConfig.shared.publish()
        DispatchQueue.main.async {
            for i in 0 ..< 100 {
                self.progressBarTop.setProgress(progress: CGFloat(i / 100), animated: true)

                //   self.Status(i)
            }
        }

//        View_circularProgressBar.labelSize = 20
//        View_circularProgressBar.lineWidth = 5
//
//        View_circularProgressBar.safePercent  = 98
//        View_circularProgressBar.setProgress(to: 1, withAnimation: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.progressBarTop.setProgress(progress: 0.5, animated: true)
//            self.progressBar2.setProgress(progress: 0, animated: true)
//            self.progressBar3.setProgress(progress: 0, animated: true)
//            self.progressBar4.setProgress(progress: 0, animated: true)
//            self.progressBar5.setProgress(progress: 0, animated: true)
//            self.progressBar6.setProgress(progress: 0, animated: true)
        }
    }

    @IBAction func clk_install(_: Any) {
        install()
        let vc = storyboard?.instantiateViewController(withIdentifier: "VersionStatusVC") as! VersionStatusVC
        navigationController?.pushViewController(vc, animated: true)
    }

    func install() {
        //    AWSConfig.shared.publish()
        let vc = storyboard?.instantiateViewController(withIdentifier: "InstallingVC") as! InstallingVC
        navigationController?.pushViewController(vc, animated: true)
    }
}

@available(iOS 10.0, *)
extension DownloadVC: circularProgressStatus {
    func Status(_ Sender: Int) {
        if Sender >= 98 {
            btn_install.isEnabled = true
            btn_install.alpha = 1.0
            //  install()
        }
        progressBarTop.setProgress(progress: CGFloat(Sender / 100), animated: true)
        print(Sender)
    }
}

@available(iOS 10.0, *)
extension DownloadVC: DeviceResponseDelegate {
    func ResponseOfDevice(_: [Payload]) {}
}
