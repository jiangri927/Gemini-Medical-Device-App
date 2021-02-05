//
//  VersionStatusVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 22/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class VersionStatusVC: baseVC {
    // MARK: - Variables

    let progressBar = TYProgressBar()
    var labeltext = UILabel()
    var timer: Timer!
    var counter: Double = 0
    var isTimerOn = false

    // MARK: - Viewcontroller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressBar()

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    @IBAction func clk_complete(_: Any) {
        commonClass.popViewControllerss(viewcontroller: self, popViews: 2, animated: true)
    }

    func setupProgressBar() {
        progressBar.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width - 50)
        labeltext = UILabel(frame: CGRect(x: 0, y: progressBar.frame.height, width: progressBar.frame.width, height: 100))
        let labelCentertext = UILabel(frame: CGRect(origin: CGPoint(x: progressBar.center.x - 70, y: progressBar.center.y - 40), size: CGSize(width: 150, height: 100)))

        //  progressBar.center = view.center
        progressBar.gradients = [#colorLiteral(red: 1, green: 0.7254901961, blue: 0.06666666667, alpha: 1), #colorLiteral(red: 1, green: 0.7254901961, blue: 0.06666666667, alpha: 1)]
        progressBar.lineDashPattern = [12, 10]
        progressBar.textColor = .white

        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                progressBar.lineHeight = 25
                labeltext.font = UIFont(name: "Arial", size: 20)
                labelCentertext.font = UIFont(name: "Arial", size: 20)
            case 1334:
                progressBar.lineHeight = 30
                labeltext.font = UIFont(name: "Arial", size: 25)
                labelCentertext.font = UIFont(name: "Arial", size: 25)
            default:
                progressBar.lineHeight = 40
                labeltext.font = UIFont(name: "Arial", size: 27)
                labelCentertext.font = UIFont(name: "Arial", size: 27)
            }
        }
        labelCentertext.text = "New Version \n 2.3"
        labelCentertext.numberOfLines = 3
        labelCentertext.textAlignment = .center
        labelCentertext.textColor = .white

        labeltext.numberOfLines = 3
        labeltext.textAlignment = .center
        labeltext.textColor = .white

        view.addSubview(labelCentertext)
        view.addSubview(labeltext)
        view.addSubview(progressBar)
    }

    @objc func handleTap() {
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
            return
        }

        counter += 0.02
        labeltext.text = "INSTALLING \n \(Int(counter * 100))% COMPLETED"
        progressBar.progress = counter
    }

    // MARK: - Button actions

    @IBAction func clk_back(_: Any) {
        navigationController?.popViewController(animated: true)
    }
}
