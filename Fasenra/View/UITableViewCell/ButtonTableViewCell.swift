//
//  ButtonTableViewCell.swift
//  Fasenra
//
//  Created by Esslam Emad on 30/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet  weak var submitButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        submitButton.layer.cornerRadius = 15.0
        submitButton.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
