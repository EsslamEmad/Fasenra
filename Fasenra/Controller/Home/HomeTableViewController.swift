//
//  HomeTableViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 24/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import RZTransitions
import PromiseKit
import SVProgressHUD

class HomeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor(red: 177/255, green: 15/255, blue: 90/255, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.isHidden = false
    }

    
    
   
    
    @objc func didPressOnItem(_ sender: UITapGestureRecognizer?) {
        let tag = sender?.view?.tag
        switch Default.def.user!.type {
        case 1:
            switch tag {
            case 0:
                performSegue(withIdentifier: "my patients", sender: nil)
            case 1:
                performSegue(withIdentifier: "request patient", sender: nil)
            case 2:
                performSegue(withIdentifier: "appointments", sender: false)
            case 3:
                performSegue(withIdentifier: "call now doctor", sender: nil)
            default: return
            }
        case 2:
            switch tag {
            case 0:
                performSegue(withIdentifier: "current status", sender: nil)
            case 1:
                SVProgressHUD.show()
                var user = User()
                user.patientStatus = 1
                user.idForEdit = Default.def.user!.id
                firstly{
                    return API.CallApi(APIRequests.editUser(user: user))
                    }.done {resp in
                        self.performSegue(withIdentifier: "feeling better", sender: nil)
                    }.catch {
                        self.showAlert(withMessage: $0.localizedDescription)
                    }.finally{
                        SVProgressHUD.dismiss()
                }
           /* case 2:
                performSegue(withIdentifier: "actq", sender: nil)*/
            case 2:
                performSegue(withIdentifier: "appointments", sender: true)
            case 3:
                performSegue(withIdentifier: "call now doctor", sender: nil)
            case 4:
                UIApplication.shared.open(URL(string: "https://www.easthma.com")!, options: [:], completionHandler: nil)
            default: return
            }
        case 3:
            switch tag {
            case 0:
                performSegue(withIdentifier: "my doctors", sender: false)
            case 1:
                performSegue(withIdentifier: "my patients", sender: nil)
            case 2:
                performSegue(withIdentifier: "my doctors", sender: true)
            case 3:
                performSegue(withIdentifier: "add patient", sender: nil)
            case 4:
                performSegue(withIdentifier: "add doctor", sender: nil)
            default: return
            }
        default:
            return
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Default.def.user!.type{
        case 1:
            return 4
        case 2:
            return 5
        case 3:
            return 5
        default:
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        var imageName: String!
        var cellTitle: String!
        switch Default.def.user!.type {
        case 1:
            switch indexPath.row{
            case 0:
                imageName = "checklist file"
                cellTitle = "Patient list"
            case 1:
                imageName = "heart file"
                cellTitle = "Add new patient"
            case 2:
                imageName = "calendar symbol"
                cellTitle = "Appointment"
            case 3:
                imageName = "24hours"
                cellTitle = "Contact Us"
            default:
                return cell
            }
        case 2:
            switch indexPath.row {
            case 0:
                imageName = "doctor symbol"
                cellTitle = "Current Status"
            case 1:
                imageName = "smiley face"
                cellTitle = "Feeling better? Tap here"
            /*case 2:
                imageName = "heart file"
                cellTitle = "ACTQ"*/
            case 2:
                imageName = "calendar symbol"
                cellTitle = "Appointment"
            case 3:
                imageName = "24hours"
                cellTitle = "Help / Contact Us"
            case 4:
                imageName =  "world symbol"
                cellTitle = "easthma.com"
            default:
                return cell
            }
        case 3:
            switch indexPath.row {
            case 0:
                imageName = "doctor symbol"
                cellTitle = "My doctors"
            case 1:
                imageName = "checklist file"
                cellTitle = "My patients"
            case 2:
                imageName = "calendar symbol"
                cellTitle = "Appointment"
            case 3:
                imageName = "heart file"
                cellTitle = "Add new patient"
            case 4:
                imageName = "aid file"
                cellTitle = "Add new doctor"
            default:
                return cell
            }
        default:
            return cell
        }
        cell.backgroundImage.tag = indexPath.row
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.didPressOnItem(_:)))
        cell.backgroundImage.addGestureRecognizer(gesture)
        cell.backgroundImage.image = UIImage(named: imageName)
        cell.titleLabel.text = cellTitle
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "my doctors"{
            let destination = segue.destination as! MyDoctorsViewController
            destination.appointment = (sender as! Bool)
        } else if segue.identifier == "appointments" {
            let destination = segue.destination as! AppointmentsViewController
            if (sender as! Bool){
                destination.patient = Default.def.user
            }else {
                destination.doctor = Default.def.user
            }
        }else if segue.identifier == "current status"{
            let destination = segue.destination as! PatientStatusViewController
            destination.patient = Default.def.user
        }
    }
    

}
