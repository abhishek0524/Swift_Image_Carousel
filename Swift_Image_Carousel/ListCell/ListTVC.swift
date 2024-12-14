//
//  ListTVC.swift
//  Swift_Image_Carousel
//
//  Created by apple on 13/12/24.
//

import UIKit

class ListTVC: UITableViewCell {
    
    @IBOutlet weak var lbltitle:UILabel!
    @IBOutlet weak var lbldesc:UILabel!
    @IBOutlet weak var imgVW:UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
