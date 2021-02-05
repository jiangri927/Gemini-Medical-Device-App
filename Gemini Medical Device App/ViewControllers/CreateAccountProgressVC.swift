//
//  CreateAccountProgressVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 04/04/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import AMProgressBar
import UIKit

class CreateAccountProgressVC: baseVC {
    let progressBar = TYProgressBar()

    // MARK: - Outlets

    @IBOutlet var progressBarBackground: AMProgressBar!
    @IBOutlet var progressBarBackGround: AMProgressBar!
    @IBOutlet var progressbarTop: AMProgressBar!

    // MARK: - variables

    var labeltext = UILabel()
    var timer: Timer!
    var counter: Double = 0
    var isTimerOn = false

    // MARK: - Viewcontroller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressBar()
        progressBarBackGround.setProgress(progress: CGFloat(1), animated: true)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    func setupProgressBar() {
        progressBar.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - 50, y: (UIScreen.main.bounds.height / 2) - 100, width: 100, height: 100)
        labeltext = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 150, y: (UIScreen.main.bounds.height / 2) - 50, width: UIScreen.main.bounds.width, height: 100))

        //  progressBar.center = view.center
        progressBar.gradients = [#colorLiteral(red: 1, green: 0.7254901961, blue: 0.06666666667, alpha: 1), #colorLiteral(red: 1, green: 0.7254901961, blue: 0.06666666667, alpha: 1)]
        progressBar.lineDashPattern = [2, 3]
        progressBar.textColor = .white
        labeltext.center = view.center
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                progressBar.lineHeight = 15
                labeltext.font = UIFont(name: "Arial", size: 10)

            case 1334:
                progressBar.lineHeight = 20
                labeltext.font = UIFont(name: "Arial", size: 25)

            default:
                progressBar.lineHeight = 20
                labeltext.font = UIFont(name: "Arial", size: 15)
            }
        }
        labeltext.numberOfLines = 3
        labeltext.textAlignment = .center
        labeltext.textColor = .white
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
            isTimerOn = !isTimerOn
            handleTap()
            return
        }

        counter += 0.02
        labeltext.text = "CREATING ACCOUNT"
        progressBar.progress = counter
        progressbarTop.setProgress(progress: CGFloat(counter), animated: true)
    }
}
