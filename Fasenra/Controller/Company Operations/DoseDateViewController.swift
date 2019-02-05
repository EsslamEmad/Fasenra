//
//  DoseDateViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 28/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class DoseDateViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var appointment = false
    
    override func viewDidLoad() {
        super.viewDidLoad()


        containerView.layer.cornerRadius = 15.0
        containerView.clipsToBounds = true
    }
    

    @IBAction func didPressOK(_ sender: UIButton) {
        if appointment{
            performSegue(withIdentifier: "unwind from appointment date", sender: nil)
        }else {
            performSegue(withIdentifier: "unwind from date", sender: nil)
        }
    }
    
    @IBAction func didPressCancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
   

}
