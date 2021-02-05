//
//  PurchasePlansDetailListVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 22/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class PurchasePlansDetailListVC: baseVC {
    // MARK: - Outlets

    @IBOutlet var tblView: UITableView!

    @IBOutlet var lbl_info: UILabel!
    @IBOutlet var lbl_DaysLeft: UILabel!
    @IBOutlet var lbl_EndDate: UILabel!

    @IBOutlet var view_Top_Height: NSLayoutConstraint!
    @IBOutlet var view_Top: UIView!

    // MARK: - Viewcontroller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func clk_back(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_: Bool) {
        if userDefaults.string(forKey: "warrantyLength") != "0", userDefaults.string(forKey: "warrantyStartDate") != nil {
            let dateFormatter = DateFormatter()
            let dateformatter2 = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let dateofDeviceLength = userDefaults.string(forKey: "warrantyStartDate")!
            let date2 = dateFormatter.date(from: dateofDeviceLength)
            lbl_DaysLeft.text = "\(date2?.days(from: Date()).description ?? "0") Days"
            dateformatter2.dateFormat = "MMMM dd, yyyy"
            let dateofEnd = dateformatter2.date(from: dateofDeviceLength)
            lbl_EndDate.text = dateformatter2.string(from: date2!)
            tblView.isHidden = true
            lbl_info.isHidden = true
            view_Top.isHidden = false
            view_Top_Height.constant = 100

        } else {
            view_Top_Height.constant = 0
            tblView.isHidden = false
            lbl_info.isHidden = false
            view_Top.isHidden = true
        }
    }
}

// MARK: - TableView controller

extension PurchasePlansDetailListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        let leftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        let rightLabel = UILabel(frame: CGRect(x: tableView.frame.width - 110, y: 0, width: 200, height: 50))
        if section == 0 { leftLabel.text = "2 YEARS"

            rightLabel.text = "US$ 1,200.00"
        } else {
            leftLabel.text = "3 YEARS"

            rightLabel.text = "US$ 1,500.00"
        }

        viewHeader.backgroundColor = .black
        rightLabel.font = UIFont.boldSystemFont(ofSize: 16)
        // UIFont(name: "Arial-Bold", size: 17)
        leftLabel.font = UIFont.boldSystemFont(ofSize: 16)
        // UIFont(name: "Arial-Bold", size: 17)
        leftLabel.textColor = .white
        rightLabel.textColor = .white

        view.addSubview(viewHeader)
        viewHeader.addSubview(leftLabel)
        viewHeader.addSubview(rightLabel)
        return viewHeader
    }

    func tableView(_: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let Footer = UIView()
        Footer.frame = CGRect(x: 00, y: 00, width: tblView.frame.width,
                              height: 200)
        Footer.backgroundColor = .black
        let leftLabel = UILabel(frame: CGRect(x: 0, y: 5, width: tblView.frame.width, height: 130))
        leftLabel.text = "Extend the factory warranty on your Gemini laser by \(section + 2) years beyond the original expiration date. The same terms and conditions apply as the original factory warranty. See your Gemini User Manual for warranty details."

        if UIDevice.current.isIphone5S() {
            leftLabel.font = UIFont(name: "Arial", size: 15)
            leftLabel.textColor = .white
            leftLabel.numberOfLines = 11
        } else {
            leftLabel.font = UIFont(name: "Arial", size: 17)
            leftLabel.textColor = .white
            leftLabel.numberOfLines = 12
        }
        view.addSubview(Footer)
        Footer.addSubview(leftLabel)
        return Footer
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return 130
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PurchasePlanVC") as! PurchasePlanVC
        if indexPath.section == 0 {
            vc.ammount = 1200.00
            vc.amountString = "$ 1,200.00"
            vc.Wlength = 2
        } else {
            vc.ammount = 1500.00
            vc.amountString = "$ 1,500.00"
            vc.Wlength = 3
        }

        navigationController?.pushViewController(vc, animated: true)
    }
}
