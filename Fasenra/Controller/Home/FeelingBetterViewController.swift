//
//  FeelingBetterViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 24/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import RZTransitions

class FeelingBetterViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        container.layer.cornerRadius = 15.0
        container.clipsToBounds = true
    }
    

    @IBAction func doDismiss(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }

}
