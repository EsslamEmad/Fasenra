//
//  AddAppointmentViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 29/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import RZTransitions
import PromiseKit
import SVProgressHUD

class AddAppointmentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var doctor: User!
    var appointment = Appointment()
    var patients = [User]()
    var patient: User!
    var requested = false
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var doctorTextField: UITextField!
    @IBOutlet weak var patientTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = RZTransitionsManager.shared()
        initializeToolbar()
        submitButton.layer.cornerRadius = 10.0
        submitButton.clipsToBounds = true
        doctorTextField.text = doctor.name
        doctorTextField.isEnabled = false
        appointment.doctor = doctor
        guard !requested else {
            patientTextField.text = patient.name
            appointment.patient = patient
            patientTextField.isEnabled = false
            return
        }
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getUsersOf(nursingCompanyID: nil, doctorID: doctor.id))
            }.done {
                self.patients = try! JSONDecoder().decode([User].self, from: $0)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor(red: 177/255, green: 15/255, blue: 90/255, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func didPressSubmit(_ sender: UIButton) {
        guard appointment.patient != nil, appointment.date != nil, appointment.time != nil else {
            return
        }
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.addAppointment(appointment: appointment))
            }.done {resp in
                self.showAlert(error: false, withMessage: "Appointment has been added", completion: {(UIAlertAction) in
                    self.performSegue(withIdentifier: "unwind from add appointment", sender: nil)
                })
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    
    
    @IBAction func didPressDate(_ gesture: UITapGestureRecognizer){
        performSegue(withIdentifier: "appointment date", sender: nil)
    }
    
    @IBAction func didPressTime(_ gesture: UITapGestureRecognizer){
        performSegue(withIdentifier: "appointment time", sender: nil)
    }
    
    
    
    @IBAction func unwindToAddAppointment(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "unwind from appointment date"{
            let sourceViewController = unwindSegue.source as! DoseDateViewController
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateTextField.text = dateFormatter.string(from: sourceViewController.datePicker.date)
            appointment.date = dateTextField.text
        } else {
            let sourceViewController = unwindSegue.source as! DoseTimeViewController
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            timeTextField.text = dateFormatter.string(from: sourceViewController.datePicker.date)
            appointment.time = timeTextField.text
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "appointment date"{
            let destination = segue.destination as! DoseDateViewController
            destination.appointment = true
        }else if segue.identifier == "appointment time"{
            let destination = segue.destination as! DoseTimeViewController
            destination.appointment = true
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
    
    //Mark: PickerView
    
    private let patientPicker = UIPickerView()
    private var inputAccessoryBar: UIToolbar!
    
    private func initializePickers() {
        patientPicker.delegate = self
        patientPicker.dataSource = self
        patientTextField.inputView = patientPicker
        patientTextField.inputAccessoryView = inputAccessoryBar
    }
    private func initializeToolbar() {
        inputAccessoryBar = UIToolbar(frame: CGRect(x: 0, y:0, width: view.frame.width, height: 44))
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(dismissPicker))
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.blue], for: .normal)
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.blue], for: .highlighted)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        inputAccessoryBar.items = [flexibleSpace, doneButton]
        initializePickers()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return patients.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row != 0 else {
            return ""
        }
        return patients[row - 1].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard patients.count > 0 else {
            return
        }
        guard row != 0 else {
            patientTextField.text = nil
            appointment.patient = nil
            return
        }
        patientTextField.text = patients[row - 1].name
        appointment.patient = patients[row - 1]
    }
    
    
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
}

