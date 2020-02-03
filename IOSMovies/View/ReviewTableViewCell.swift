//
//  ReviewTableViewCell.swift
//  IOSMovies
//
//  Created by MacBookPro on 4/9/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var personName: UILabel!
    
    @IBOutlet weak var reviewContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
