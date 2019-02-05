//
//  AppointmentsViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 29/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import RZTransitions
import SVProgressHUD

class AppointmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var appointments = [Appointment]()
    var doctor: User!
    var patient: User!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        self.transitioningDelegate = RZTransitionsManager.shared()
        if Default.def.user!.type == 1{
            addButton.alpha = 0
        }
        
        SVProgressHUD.show()
        firstly{
            return API.CallApi(doctor != nil ? APIRequests.getAppoinments(doctorID: doctor.id) : APIRequests.getAppointments(patientID: patient.id))
            }.done {
                self.appointments = try! JSONDecoder().decode([Appointment].self, from: $0)
                self.tableView.reloadData()
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
    
    @objc func didPressOnEdit(_ sender: UITapGestureRecognizer?) {
        performSegue(withIdentifier: "appointment status", sender: appointments[sender!.view!.tag].id)
    }
    
    @IBAction func didPressAdd(_ sender: UIButton){
        if Default.def.user!.type == 3{
            performSegue(withIdentifier: "add appointment", sender: nil)
        }else {
            performSegue(withIdentifier: "call now", sender: nil)
        }
    }
    
    //Mar: TableView Protocols
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appointments.count == 0{
            return 1
        }
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if appointments.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "empty")!
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AppointmentTableViewCell
        switch appointments[indexPath.row].status{
        case 1:
            cell.coloredView.backgroundColor = UIColor(red: 1, green: 160/255, blue: 0, alpha: 1)
            cell.statusLabel.text = "Pending"
            cell.statusLabel.textColor = UIColor(red: 1, green: 160/255, blue: 0, alpha: 1)
        case 2:
            cell.coloredView.backgroundColor = UIColor(red: 0, green: 171/255, blue: 80/255, alpha: 1)
            cell.statusLabel.text = "Completed"
            cell.statusLabel.textColor = UIColor(red: 0, green: 171/255, blue: 80/255, alpha: 1)
        case 3:
            cell.coloredView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
            cell.statusLabel.text = "Missed"
            cell.statusLabel.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        default: break
        }
        if Default.def.user!.type == 1{
            cell.firstNameLabel.text = appointments[indexPath.row].patient.name
        }else {
            cell.firstNameLabel.text = appointments[indexPath.row].doctor.name
        }
        if Default.def.user!.type == 3 {
            cell.secondNameLabel.text = appointments[indexPath.row].patient.name
        } else {
            cell.editButton.alpha = 0
        }
        cell.dateLabel.text = appointments[indexPath.row].date + " " + appointments[indexPath.row].time
        cell.addressLabel.text = appointments[indexPath.row].doctor.address != nil ? appointments[indexPath.row].doctor.address : "Address"
        cell.editButton.tag = indexPath.row
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.didPressOnEdit(_:)))
        cell.editButton.addGestureRecognizer(gesture)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    @IBAction func unwindToAppointments(_ unwindSegue: UIStoryboardSegue) {
        viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add appointment"{
            let destination = segue.destination as! AddAppointmentViewController
            destination.doctor = doctor
        } else if segue.identifier == "appointment status"{
            let destination = segue.destination as! ChangeAppointmentStatusViewController
            destination.appointmentID = (sender as! Int)
        }
    }
}
