//
//  CalculateVC.swift
//  Swift_Image_Carousel
//
//  Created by apple on 14/12/24.
//

import UIKit

class CalculateVC: UIViewController {

    @IBOutlet weak var statisticsLabel: UILabel!

    var statisticsText: String = "" // Pass data here

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set statistics text
        statisticsLabel.text = statisticsText
    }

}
