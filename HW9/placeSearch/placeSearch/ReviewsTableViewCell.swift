//
//  ReviewsTableViewCell.swift
//  placeSearch
//
//  Created by ticky on 4/16/18.
//  Copyright © 2018 tianqi. All rights reserved.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var userName: UILabel!
    var urlToBeOpened:String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
