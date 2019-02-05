//
//  ChangeAppointmentStatusViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 29/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD
import RZTransitions

class ChangeAppointmentStatusViewController: UIViewController {

    var appointmentID: Int!
    
    @IBOutlet weak var pendingButton: UIButton!
    @IBOutlet weak var confirmedButton: UIButton!
    @IBOutlet weak var missedButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.layer.cornerRadius = 15.0
        confirmedButton.layer.cornerRadius = 15.0
        pendingButton.layer.cornerRadius = 15.0
        missedButton.layer.cornerRadius = 15.0
        containerView.clipsToBounds = true
        confirmedButton.clipsToBounds = true
        pendingButton.clipsToBounds = true
        missedButton.clipsToBounds = true
        self.transitioningDelegate = RZTransitionsManager.shared()
    }
    
    @IBAction func didPressConfirmed(_ sender: UIButton){
        editAppointment(status: 2)
    }
    
    @IBAction func didPressPending(_ sender: UIButton){
        editAppointment(status: 1)
    }
    
    @IBAction func didPressMissed(_ sender: UIButton){
        editAppointment(status: 3)
    }

    func editAppointment(status: Int){
        SVProgressHUD.show()
        firstly {
            return API.CallApi(APIRequests.editAppointment(id: appointmentID, status: status))
            }.done {resp in
                self.showAlert(error: false, withMessage: "Appointment status has been updated", completion: {(UIAlertAction) in
                    self.performSegue(withIdentifier: "unwind from change appointment status", sender: nil)
                })
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func dismissView(_ gesture: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    

}
