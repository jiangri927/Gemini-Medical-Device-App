//
//  StatisticVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 26/08/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import Charts
import UIKit

// let parties = ["810" , "Dual" , "980"]
class StatisticVC: UIViewController {
    @IBOutlet var tblView: UITableView!
    var maxVal = Float()
    var Section1 = [Procedures]()
    var Section2 = [Procedures]()
    var Section3 = [Procedures]()

    // MARK: - Outlets

    @IBOutlet var constrainTimeUsageHeight: NSLayoutConstraint!
    @IBOutlet var lbl_Time: UILabel!
    var StatisticsData = [Statistics]()

    // MARK: - View Controller  Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
        tblView.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_: Bool) {
        if userDefaults.string(forKey: "topic") != nil {
            CallAPI()
        } else {
            Alert.showAlert(viewcontroller: self, title: AppName, message: "Please Select Device !")
        }
    }

    // MARK: - Button Actions / Clicks

    @IBAction func clk_back(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Call Functions

    // MARK: - API CALL

    func CallAPI() {
        let dicData = [
            "LoginID": userDefaults.string(forKey: loginObjId) as Any,
            "SerialNumber": userDefaults.string(forKey: "topic")!,
            "UID": userDefaults.string(forKey: "deviceUID")!,
            "token": userDefaults.string(forKey: logginToken)!,

        ] as [String: AnyObject]
        StatisticsModel.StatisticsService(viewcontroller: self, URL: "statistics.php", dicSendData: dicData, completionHandler: { Response in

            self.StatisticsData = [Response]
            if self.StatisticsData.count > 0 {
                let a = self.StatisticsData[0].procedures!
                let max = a.max(by: { (a, b) -> Bool in

                    a.PbBar < b.PbBar
                })
                if (self.StatisticsData[0].modes?.count)! > 0 {
                    let time = self.StatisticsData[0].modes![0]
                    let Mode810 = Int(time.mode_810 ?? "0")!
                    let Mode980 = Int(time.mode_980 ?? "0")!
                    let ModeDual = Int(time.mode_Dual ?? "0")!
                    let Total = Mode810 + Mode980 + ModeDual
                    self.lbl_Time.text = self.secondsToHoursMinutesSeconds(seconds: Total)
                }

                self.maxVal = max?.PbBar ?? 0.001

                if a.count > 0 {
                    //                   let b = a.filter({ (trm) -> Bool in
                    //                        return (Int(trm.oBJID!)! < 6)
                    //                    })
                    //                    print("B -----> ", b)
                    for i in a {
                        if Int(i.oBJID ?? "1000") ?? 1000 < 6 {
                            self.Section1.append(i)
                        } else if Int(i.oBJID ?? "1000") ?? 1000 > 6, Int(i.oBJID ?? "1000") ?? 1000 < 20 {
                            self.Section2.append(i)
                        } else if Int(i.oBJID ?? "1000") ?? 0 > 20 {
                            self.Section3.append(i)
                        }
                    }
                }

                // self.Section1 =
            }
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }) { err in
            commonClass.showCustomeAlert(self, messageA: err.localizedDescription, MessageColor: "red")
        }
    }

    func secondsToHoursMinutesSeconds(seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = (seconds % 3600) % 60
        return ("\(h.description) : \(m.description) : \(s.description)")
    }

    // MARK: - FUNCTION WILL PROVIDE PROGRESS BAR VALUE

    func ProgressBarValue(PVal: Float) -> Float {
        if maxVal == 0.001 {
            return 0.001
        } else {
            print("pb value >>>>>>>>>>> ", PVal / maxVal)
            return (PVal) / maxVal
        }
    }
}

extension StatisticVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        //  return 2
        return 4
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 9
        case 2:
            return 3
        case 3:
            return 1
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StatisticCell

        cell.selectionStyle = .none
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2") as! PieChartCell

        cell2.selectionStyle = .none
        if StatisticsData.count > 0 {
            switch indexPath.section {
            case 0:

                cell.lbl_Name.text = Section1[indexPath.row].name
                cell.progressBar.progressTintColor = #colorLiteral(red: 0.9725490196, green: 0.5882352941, blue: 0.2588235294, alpha: 1)
                cell.lbl_Count.text = Int(Section1[indexPath.row].PbBar).description
                cell.progressBar.progress = ProgressBarValue(PVal: Section1[indexPath.row].PbBar)
                //    print("1>>>>>0", Section1[indexPath.row].PbBar , ProgressBarValue(PVal: Section1[indexPath.row].PbBar) )
                // Section1[indexPath.row].PbBar
                return cell

            case 1:
                // return cell2
                cell.lbl_Name.text = Section2[indexPath.row].name
                cell.progressBar.progressTintColor = #colorLiteral(red: 0.2666666667, green: 0.9647058824, blue: 0.3098039216, alpha: 1)
                cell.lbl_Count.text = Int(Section2[indexPath.row].PbBar).description
                cell.progressBar.progress = ProgressBarValue(PVal: Section2[indexPath.row].PbBar)
                //   print("1>>>>>1", Section2[indexPath.row].PbBar , ProgressBarValue(PVal: Section2[indexPath.row].PbBar) )
                return cell
            case 2:
                cell.lbl_Name.text = Section3[indexPath.row].name
                cell.progressBar.progressTintColor = #colorLiteral(red: 0.2666666667, green: 0.9450980392, blue: 1, alpha: 1)
                cell.lbl_Count.text = Int(Section3[indexPath.row].PbBar).description
                cell.progressBar.progress = ProgressBarValue(PVal: Section3[indexPath.row].PbBar)
                return cell
            case 3:

                cell2.statisticsData = StatisticsData
                print(cell2.statisticsData)
                cell2.updateChartData()
                return cell2
            default:

                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
        // cell.lbl_Name.text  = "QWERTY"
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection _: Int) -> UIView? {
        // UIView with darkGray background for section-separators as Section Footer
        let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        v.backgroundColor = .darkGray
        return v
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        // Section Footer height
        return 1.0
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 20
        case 1:
            return 20
        case 2:
            return 20
        case 3:
            return 250
        default:
            return 80
        }
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}

class StatisticCell: UITableViewCell {
    @IBOutlet var lbl_Name: UILabel!
    @IBOutlet var lbl_Count: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    override func awakeFromNib() {
        progressBar.layer.sublayers![1].cornerRadius = 2.5
        progressBar.subviews[1].clipsToBounds = true
    }
}

class PieChartCell: UITableViewCell, ChartViewDelegate {
    @IBOutlet var chartView: PieChartView!
    var shouldHideData: Bool = false
    var statisticsData = [Statistics]()

    override func awakeFromNib() {
        chartView.drawHoleEnabled = !chartView.drawHoleEnabled
        chartView.setNeedsDisplay()
        chartView.delegate = self
        updateChartData()
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .center
        l.orientation = .vertical
        l.stackSpace = 8
        l.textColor = .white
        l.form = .circle
        l.xEntrySpace = 15
        l.yEntrySpace = 15
        l.yOffset = 0
        l.formSize = 16
        //        chartView.legend = l

        // entry label styling
        //     chartView.entryLabelColor = .white
        //      chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
    }

    func setup(pieChartView chartView: PieChartView) {
        chartView.usePercentValuesEnabled = false
        chartView.drawEntryLabelsEnabled = false
        chartView.drawSlicesUnderHoleEnabled = true

        //     chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: -35, top: 0, right: 35, bottom: 0)
        chartView.drawCenterTextEnabled = false
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        chartView.drawHoleEnabled = false
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
    }

    func updateChartData() {
        if shouldHideData {
            chartView.data = nil
            return
        }
        setDataCount(Int(3), range: UInt32(20))
    }

    func setDataCount(_: Int, range _: UInt32) {
        var entries: [PieChartDataEntry] = Array()
        if statisticsData.count > 0 {
            if (statisticsData[0].modes?.count)! > 0 {
                let m810 = Double(statisticsData[0].modes?[0].mode_810 ?? "0.0") ?? 0.0
                let m980 = Double(statisticsData[0].modes?[0].mode_980 ?? "0.0") ?? 0.0
                let mdual = Double(statisticsData[0].modes?[0].mode_Dual ?? "0.0") ?? 0.0
                let total = 100 / (m810 + m980 + mdual)
                entries.append(PieChartDataEntry(value: m810 * total, label: "810"))
                //     entries.append(PieChartDataEntry(value: Double(statisticsData[0].modes?[0].mode_810 ?? "0.0") ?? 0.0,  label: "810"))
                entries.append(PieChartDataEntry(value: m980 * total, label: "980"))
                entries.append(PieChartDataEntry(value: mdual * total, label: "Dual"))
            }
        }

        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = true
        set.sliceSpace = 2

        set.drawValuesEnabled = true
        set.colors = [#colorLiteral(red: 0.1176470588, green: 0.3843137255, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.2117647059, blue: 0.2117647059, alpha: 1), #colorLiteral(red: 0.9803921569, green: 0.4784313725, blue: 0.07450980392, alpha: 1)]
        // ChartColorTemplates.vordiplom()
        //            + ChartColorTemplates.joyful()
        //            + ChartColorTemplates.colorful()
        //            + ChartColorTemplates.liberty()
        //            + ChartColorTemplates.pastel()
        //            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]

        let data = PieChartData(dataSet: set)

        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.white)

        chartView.data = data
        chartView.highlightValues(nil)
        setup(pieChartView: chartView)
    }
}
