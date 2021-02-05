//
//  VideosVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 22/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import SDWebImage
import UIKit
class VideosVC: baseVC {
    let VideoArr = [
        "https://youtu.be/E-ca0vGhiBE",
        "https://youtu.be/4ccQoegvU4M",
        "https://youtu.be/7E_3qNwo7VE",
        "https://youtu.be/TOCa1JV8LdE",
        "https://youtu.be/Q9cWptSd6qo",
        "https://youtu.be/CkeGpAepXn4",
        "https://youtu.be/4z3x-gbjrAQ",
        "https://youtu.be/Ug6-EYElN0M",
        "https://youtu.be/3SqlIvOTl1U",
        "https://youtu.be/eZHgi3A8M8I",
        "https://youtu.be/Wiq3WDs1LUA",
    ]
    let imgThumb = [
        "https://img.youtube.com/vi/E-ca0vGhiBE/default.jpg",
        "https://img.youtube.com/vi/4ccQoegvU4M/default.jpg",
        "https://img.youtube.com/vi/7E_3qNwo7VE/default.jpg",
        "https://img.youtube.com/vi/TOCa1JV8LdE/default.jpg",
        "https://img.youtube.com/vi/Q9cWptSd6qo/default.jpg",
        "https://img.youtube.com/vi/CkeGpAepXn4/default.jpg",
        "https://img.youtube.com/vi/4z3x-gbjrAQ/default.jpg",
        "https://img.youtube.com/vi/Ug6-EYElN0M/default.jpg",
        "https://img.youtube.com/vi/3SqlIvOTl1U/default.jpg",
        "https://img.youtube.com/vi/eZHgi3A8M8I/default.jpg",
        "https://img.youtube.com/vi/Wiq3WDs1LUA/default.jpg",
    ]

    let titleArr = [
        "Gemini 810 & 980 Soft Tissue diode laser",
        "kusek mucocele removal",
        "How To Use the Gemini Laser: Maxillary Frenectomy",
        "Correct diode laser technique",
        "How To Use the Gemini Laser: Class V Troughing",
        "How To Use the Gemini Laser: Posterior Ovate Pontic Preparation",
        "How To Use the Gemini Laser: Tissue Preparation for Bridge Pontics",
        "How To Use the Gemini Laser: Troughing Crown Prep",
        "How To Use the Gemini Laser: Tissue Preparation for Bridge Impression",
        "How To Use the Gemini Laser: Uncovering Implants",
        "How To Use the Gemini Laser: Hypertrophic Tissue Removal",
    ]
    @IBOutlet var tblView_Videos: UITableView!

    // MARK: - Viewcontroller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func clk_bac(_: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension VideosVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return VideoArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellVideos
        cell.lbl_VideoName.text = titleArr[indexPath.row]
        cell.imgVideoThumb.sd_setImage(with: URL(string: imgThumb[indexPath.row]), placeholderImage: UIImage(named: "ic_videos_thumb.png"))

        cell.selectionStyle = .none

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = VideoArr[indexPath.row]
        let youtubeId = "SxTYjptEzZs"
        var youtubeUrl = NSURL(string: url)
        // NSURL(string:"youtube://\(youtubeId)")!
        if UIApplication.shared.canOpenURL(youtubeUrl as! URL) {
            UIApplication.shared.openURL(youtubeUrl as! URL)
        } else {
            var youtubeUrl = NSURL(string: url)
            // youtubeUrl = NSURL(string:"https://www.youtube.com/watch?v=\(youtubeId)")!
            UIApplication.shared.openURL(youtubeUrl as! URL)
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 110
    }
}

class CellVideos: UITableViewCell {
    @IBOutlet var imgVideoThumb: UIImageView!
    @IBOutlet var lbl_VideoName: UILabel!
    override func awakeFromNib() {}
}
