//
//  NotificationsTableViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 31/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import RZTransitions
import PromiseKit

class NotificationsTableViewController: UITableViewController {

    var notifications = [UserNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        self.tableView.addSubview(self.RefreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getNotifications)
            }.done {
                self.notifications = try! JSONDecoder().decode([UserNotification].self, from: $0)
                self.tableView.reloadData()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
                self.RefreshControl.endRefreshing()
        }
        self.tabBarController?.tabBar.isHidden = false
    }

    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationTableViewCell

        cell.titleLabel.text = notifications[indexPath.row].message
        switch notifications[indexPath.row].type{
        case 1:
            cell.icon.image = UIImage(named: "smile-1")
        case 2:
            cell.icon.image = UIImage(named: "help")
        case 3:
            cell.icon.image = UIImage(named: "chat-1")
        case 4:
            cell.icon.image = UIImage(named: "shield")
        case 5:
            cell.icon.image = UIImage(named: "group_492")
        case 6:
            cell.icon.image = UIImage(named: "calendar")
        case 7:
            cell.icon.image = UIImage(named: "group_494")
        case 8:
            cell.icon.image = UIImage(named: "calendar")
        case 9:
            cell.icon.image = UIImage(named: "group_492")
        default: break
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch notifications[indexPath.row].type {
        case 1:
            getPatient(patientID: notifications[indexPath.row].patient)
        case 2:
            getPatient(patientID: notifications[indexPath.row].patient)
        case 3:
            performSegue(withIdentifier: "notes", sender: notifications[indexPath.row])
        case 4:
            if Default.def.user!.type == 2 {
                performSegue(withIdentifier: "patient status", sender: Default.def.user)}
            else {
                getPatient(patientID: notifications[indexPath.row].patient)
            }
        case 5:
            getDoses(patientID: notifications[indexPath.row].patient)
        case 6:
            performSegue(withIdentifier: "appointments", sender: notifications[indexPath.row])
        case 7:
            if Default.def.user!.type == 3{
                performSegue(withIdentifier: "add patient", sender: notifications[indexPath.row])
            }else {
                getPatient(patientID: notifications[indexPath.row].patient)
            }
        case 8:
            addAppointment(patientID: notifications[indexPath.row].patient, doctorID: notifications[indexPath.row].doctor)
        case 9:
            getPatient(patientID: notifications[indexPath.row].patient)
        default: break
        }
    }
    
    lazy var RefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.viewWillAppear(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.white
        
        return refreshControl
    }()
    
    func getPatient(patientID: Int){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getUser(id: patientID))
            }.done {
                let user = try! JSONDecoder().decode(User.self, from: $0)
                self.performSegue(withIdentifier: "patient status", sender: user)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    
    func getACTQ(patientID: Int, ACTQID: Int){
        SVProgressHUD.show()
        firstly {
            return API.CallApi(APIRequests.getACTQAnswers(patientID: patientID, actqID: ACTQID))
            }.done {
                let actq = try! JSONDecoder().decode(ACTQ.self, from: $0)
                self.performSegue(withIdentifier: "actq", sender: actq)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
   
    func getDoses(patientID: Int){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getUser(id: patientID))
            }.done {
                let user = try! JSONDecoder().decode(User.self, from: $0)
                self.performSegue(withIdentifier: "doses", sender: user)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    func addAppointment(patientID: Int, doctorID: Int){
        var appointment = Appointment()
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getUser(id: doctorID))
            }.done {
                appointment.doctor = try! JSONDecoder().decode(User.self, from: $0)
                firstly{
                    return API.CallApi(APIRequests.getUser(id: patientID))
                    }.done {
                        appointment.patient = try! JSONDecoder().decode(User.self, from: $0)
                        self.performSegue(withIdentifier: "add appointment", sender: appointment)
                    }.catch{
                        self.showAlert(withMessage: $0.localizedDescription)
                    }.finally {
                        SVProgressHUD.dismiss()
                }
            }.catch{
                self.showAlert(withMessage: $0.localizedDescription)
                SVProgressHUD.dismiss()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "patient status"{
            let destination = segue.destination as! PatientStatusViewController
            destination.patient = (sender as! User)
        }else if segue.identifier == "actq"{
            let destination = segue.destination as! ACTQAnswersViewController
            destination.actq = (sender as! ACTQ)
        }else if segue.identifier == "notes"{
            let destination = segue.destination as! NotesViewController
            let notification = (sender as! UserNotification)
            destination.patientID = notification.patient
            destination.filterID = notification.company != 0 ? notification.company : notification.doctor
        }else if segue.identifier == "doses"{
            let destination = segue.destination as! DosesViewController
            destination.patient = (sender as! User)
        }else if segue.identifier == "appointments"{
            let destination = segue.destination as! AppointmentsViewController
            if Default.def.user!.type == 2 {
                destination.patient = Default.def.user!
            }else {
                destination.doctor = Default.def.user!
            }
        } else if segue.identifier == "add patient"{
            let destination = segue.destination as! AddRequestedPatientViewController
            let notification = (sender as! UserNotification)
            destination.doctorID = notification.doctor
            destination.patientID = notification.patient
        } else if segue.identifier == "add appointment"{
            let destination = segue.destination as! AddAppointmentViewController
            let appointment = (sender as! Appointment)
            destination.doctor = appointment.doctor
            destination.patient = appointment.patient
            destination.requested = true
        }
        
        
    }

}
