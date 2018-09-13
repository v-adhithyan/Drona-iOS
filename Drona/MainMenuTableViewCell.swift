//
//  MainMenuTableViewCell.swift
//  Drona
//
//  Created by Adhithyan Vijayakumar on 13/09/18.
//  Copyright © 2018 Adhithyan Vijayakumar. All rights reserved.
//

import UIKit

class MainMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var bView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
