//
//  CustomTableViewCell.swift
//  placeSearch
//
//  Created by ticky on 4/12/18.
//  Copyright © 2018 tianqi. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var addressView: UILabel!
    @IBOutlet weak var favorView: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
