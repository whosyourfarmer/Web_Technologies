//
//  InfoTableViewCell.swift
//  placeSearch
//
//  Created by ticky on 4/13/18.
//  Copyright © 2018 tianqi. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var header: UITextView!
    @IBOutlet weak var cosmosView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
