//
//  MyDoctorTableViewCell.swift
//  Fasenra
//
//  Created by Esslam Emad on 25/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class MyDoctorTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var patientsCountLabel: UILabel!
    @IBOutlet weak var doctorPhoto: UIImageView!
    @IBOutlet weak var radioButton: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 10.0
        containerView.clipsToBounds = true
        doctorPhoto.image = UIImage(named: "avatar")
        doctorPhoto.layer.cornerRadius = 32.0
        doctorPhoto.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
