//
//  FavoriteTableViewCell.swift
//  placeSearch
//
//  Created by ticky on 4/17/18.
//  Copyright © 2018 tianqi. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    //@IBOutlet weak var placeIdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
