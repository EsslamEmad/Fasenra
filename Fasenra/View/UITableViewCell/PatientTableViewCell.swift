//
//  PatientTableViewCell.swift
//  Fasenra
//
//  Created by Esslam Emad on 27/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class PatientTableViewCell: UITableViewCell {

    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var patientPhoto: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var actqLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 10.0
        containerView.clipsToBounds = true
        patientPhoto.image = UIImage(named: "avatar")
        patientPhoto.layer.cornerRadius = 32.0
        patientPhoto.clipsToBounds = true
        actqLabel.alpha = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
