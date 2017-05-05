//
//  RepositoriesTableViewCell.swift
//  Example2
//
//  Created by Nacho Martinez on 4/5/17.
//  Copyright © 2017 Nacho Martinez. All rights reserved.
//

import UIKit

class RepositoriesTableViewCell: UITableViewCell {
    @IBOutlet var nameRepo: UILabel!
    @IBOutlet var nameAuthor: UILabel!
    @IBOutlet var updateDate: UILabel!
    @IBOutlet var imgStars: UIImageView!
    @IBOutlet var numStars: UILabel!

    override func awakeFromNib() {
                super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
