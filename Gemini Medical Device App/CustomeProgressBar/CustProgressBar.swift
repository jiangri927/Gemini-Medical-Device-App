//
//  CustProgressBar.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 14/09/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class CustProgressBar: UIView {
    // MARK: - Constant Variables

    let nibName = "CustProgressBar"
    var timer: Timer?
    var constant = 25

    // MARK: - Setof views

    @IBOutlet var contentView: UIView!

    @IBOutlet var viewCollection: [UIView]!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view4: UIView!
    @IBOutlet var view5: UIView!
    @IBOutlet var view6: UIView!
    @IBOutlet var view7: UIView!
    @IBOutlet var view8: UIView!
    @IBOutlet var view9: UIView!
    @IBOutlet var view10: UIView!
    @IBOutlet var view11: UIView!
    @IBOutlet var view12: UIView!
    @IBOutlet var view13: UIView!
    @IBOutlet var view14: UIView!
    @IBOutlet var view15: UIView!
    @IBOutlet var view16: UIView!
    @IBOutlet var view17: UIView!
    @IBOutlet var view18: UIView!
    @IBOutlet var view19: UIView!
    @IBOutlet var view20: UIView!
    @IBOutlet var view21: UIView!
    @IBOutlet var view22: UIView!

    @IBOutlet var view23: UIView!

    @IBOutlet var view24: UIView!
    @IBOutlet var view25: UIView!

    var view: UIView!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
         // Drawing code
     }
     */

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }

    // MARK: - Xib

    func xibSetUp() {
        ViewSetup()
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        view.clipsToBounds = true
        addSubview(view)
    }

    // MARK: - Load Method

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    // MARK: -  viewset up

    private func ViewSetup() {
        DispatchQueue.main.async {
            for viewS in self.viewCollection {
                viewS.transform = CGAffineTransform(rotationAngle: 35)
                viewS.backgroundColor = #colorLiteral(red: 0.9976231456, green: 0.7529411765, blue: 0.06666666667, alpha: 0.6954922354)
            }
        }
    }

    // MARK: - Function for default subscribed device data

    func scheduledTimerWithTimeInterval() {
        // Scheduling timer to Call the function "updateCounting" with the interval of 15 seconds
        //  if timer == nil {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateCounting), userInfo: nil, repeats: true)
        // }
    }

    func reset() {
        for viewS in viewCollection {
            viewS.backgroundColor = #colorLiteral(red: 0.9976231456, green: 0.7529411765, blue: 0.06666666667, alpha: 0.6954922354)
        }
    }

    func ProgressWithNumbers(i: Int) {
        //  for a in 0..<25 {
        if i % 4 == 0 {
            var a = i / 4
            print(a)
            if a >= viewCollection.count {
                a = viewCollection.count - 1
            }
            for t in 0 ... a {
                viewCollection[t].backgroundColor = #colorLiteral(red: 0.9976231456, green: 0.7971993685, blue: 0.09706369787, alpha: 1)
            }
        }
        // }
    }

    @objc func updateCounting() {
        if constant != 0 {
            constant -= 1
            viewCollection[viewCollection.count - constant - 1].backgroundColor = #colorLiteral(red: 0.9976231456, green: 0.7971993685, blue: 0.09706369787, alpha: 1)
        } else {
            DispatchQueue.main.async {
                for viewS in self.viewCollection {
                    //  viewS.transform = CGAffineTransform(rotationAngle: 35)
                    viewS.backgroundColor = #colorLiteral(red: 0.9976231456, green: 0.7529411765, blue: 0.06666666667, alpha: 0.6954922354)
                }
            }
            constant = 25
        }
    }

    func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }

    public func setProgress(flag: Bool, progress: Int) {
        if flag == true {
            scheduledTimerWithTimeInterval()
        } else {
            ProgressWithNumbers(i: progress)
        }
    }
}
