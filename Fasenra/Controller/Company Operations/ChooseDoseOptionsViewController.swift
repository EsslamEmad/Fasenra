//
//  ChooseDoseOptionsViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 28/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import RZTransitions

class ChooseDoseOptionsViewController: UIViewController {

    var patient: User!
    var edit = false
    var dose = Does()
    var requested = false
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var pendingView: UIView!
    @IBOutlet weak var confirmedView: UIView!
    @IBOutlet weak var missedView: UIView!
    @IBOutlet weak var pendingCircle: UIImageView!
    @IBOutlet weak var confirmedCircle: UIImageView!
    @IBOutlet weak var missedCircle: UIImageView!
   // @IBOutlet weak var periodTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        if edit {
            self.title = "Edit Dose"
            submitButton.setTitle("Edit", for: .normal)
            pendingCircle.alpha = 0
            confirmedCircle.alpha = 0
            missedCircle.alpha = 0
            dateTextField.text = dose.date
            timeTextField.text = dose.time
            switch dose.status{
            case 1:
                pendingCircle.alpha = 1
            case 2:
                confirmedCircle.alpha = 1
            case 3:
                missedCircle.alpha = 1
            default: break
            }
        } else {
            self.title = "Add Dose"
            pendingView.alpha = 0
            confirmedView.alpha = 0
            missedView.alpha = 0
        }
        submitButton.layer.cornerRadius = 10.0
        submitButton.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor(red: 177/255, green: 15/255, blue: 90/255, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func didPressSubmit(_ sender: UIButton) {
        if edit {
            editDose()
            return
        }
        guard patient.doesBeganDay != nil, patient.doesbegantime != nil else {
            return
        }
        if requested{
            requestedUser()
            return
        }
       // patient.doesDays = period
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.register(user: patient))
            }.done { resp in
                self.showAlert(error: false, withMessage: "Patient has been added succefully", completion: {(UIAlertAction) in
                    self.performMainSegue()
                })
            }.catch{
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    func requestedUser(){
        var user = User()
        user.idForEdit = patient.id
        user.name = patient.name
        user.photo = patient.photo
        user.email = patient.email
        user.phone = patient.phone
        user.insurance = patient.insurance
        user.doesBeganDay = patient.doesBeganDay
        user.doesbegantime = patient.doesbegantime
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.editUser(user: user))
            }.done { resp in
                self.showAlert(error: false, withMessage: "Patient has been added succefully", completion: {(UIAlertAction) in
                    self.performMainSegue()
                })
            }.catch{
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    func editDose(){
        guard dose.date != nil || dose.time != nil || dose.status != nil else {
            return
        }
        
        
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.editDoes(does: dose))
            }.done { resp in
                self.showAlert(error: false, withMessage: "Dose has been updated", completion: {(UIAlertAction) in
                    self.performSegue(withIdentifier: "unwind from edit dose", sender: nil)
                })
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func didPressDate(_ gesture: UITapGestureRecognizer){
        performSegue(withIdentifier: "dose date", sender: nil)
    }
    
    @IBAction func didPressTime(_ gesture: UITapGestureRecognizer){
        performSegue(withIdentifier: "dose time", sender: nil)
    }
    
    @IBAction func didPressPending(_ gesture: UITapGestureRecognizer){
        pendingCircle.alpha = 1
        confirmedCircle.alpha = 0
        missedCircle.alpha = 0
        dose.status = 1
    }
    @IBAction func didPressConfirmed(_ gesture: UITapGestureRecognizer){
        pendingCircle.alpha = 0
        confirmedCircle.alpha = 1
        missedCircle.alpha = 0
        dose.status = 2
    }
    @IBAction func didPressMissed(_ gesture: UITapGestureRecognizer){
        pendingCircle.alpha = 0
        confirmedCircle.alpha = 0
        missedCircle.alpha = 1
        dose.status = 3
    }
    
    @IBAction func unwindToAddPatientFinalView(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "unwind from date"{
            let sourceViewController = unwindSegue.source as! DoseDateViewController
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateTextField.text = dateFormatter.string(from: sourceViewController.datePicker.date)
            if edit {
                dose.date = dateTextField.text
            }else {
                patient.doesBeganDay = dateTextField.text}
        } else {
            let sourceViewController = unwindSegue.source as! DoseTimeViewController
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            timeTextField.text = dateFormatter.string(from: sourceViewController.datePicker.date)
            if edit{
                dose.time = timeTextField.text
            }else {
                patient.doesbegantime = timeTextField.text}
        }
    }

    
    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }
    

}
