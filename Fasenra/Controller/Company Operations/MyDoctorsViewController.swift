//
//  MyDoctorsViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 25/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import RZTransitions
import SVProgressHUD


class MyDoctorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var users = [User]()
    var doctors = [User]()
    var searching  = false
    var matchingDoctors: [User]!
    var appointment = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.transitioningDelegate = RZTransitionsManager.shared()
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderWidth = 0
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getUsersOf(nursingCompanyID: Default.def.user!.id, doctorID: nil))
            }.done {
                self.users = try! JSONDecoder().decode([User].self, from: $0)
                self.filterDoctors()
            }.catch{
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
        //searchBar.layer.borderColor = UIColor(red: 177/255, green: 15/255, blue: 90/255, alpha: 1).cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor(red: 177/255, green: 15/255, blue: 90/255, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func filterDoctors(){
        for user in users {
            if user.type == 1 {
                doctors.append(user)
            }
        }
        for user in users{
            if user.type == 2 {
                if let docIndex = doctors.index(where: {$0.id == user.doctorID}) {
                    doctors[docIndex].patients.append(user)
                }
            }
        }
        tableView.reloadData()
    }
    
    @objc func showPatient(_ gesture: UITapGestureRecognizer){
        if searching{
            performSegue(withIdentifier: "show patient", sender: matchingDoctors[gesture.view!.tag])
        }else {
            performSegue(withIdentifier: "show patient", sender: doctors[gesture.view!.tag])
        }
    }
    
    @objc func showAppointments(_ gesture: UITapGestureRecognizer){
        if searching{
            performSegue(withIdentifier: "show appointments", sender: matchingDoctors[gesture.view!.tag])
        }else {
            performSegue(withIdentifier: "show appointments", sender: doctors[gesture.view!.tag])
        }
    }

    //Mark: TableView Protocols
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    var empty: Bool!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            if matchingDoctors.count == 0 {
                empty  = true
                return 1
            }
            empty = false
            return matchingDoctors.count
        }
        if doctors.count == 0 {
            empty = true
            return 1
        }
        empty = false
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if empty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "empty")!
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyDoctorTableViewCell
        let gesture = UITapGestureRecognizer(target: self, action: appointment ? #selector(showAppointments(_:)) : #selector(showPatient(_:)))
        cell.containerView.tag = indexPath.row
        cell.containerView.addGestureRecognizer(gesture)
        if searching{
            if let img = matchingDoctors[indexPath.row].photoURL{
                if let imgurl = URL(string: img){
                    cell.doctorPhoto.kf.setImage(with: imgurl)
                    cell.doctorPhoto.kf.indicatorType = .activity
                }else {
                    cell.doctorPhoto.image = UIImage(named: "avatar")
                }
            }else {
                cell.doctorPhoto.image = UIImage(named: "avatar")
            }
            cell.doctorNameLabel.text = matchingDoctors[indexPath.row].name
            cell.patientsCountLabel.text = String(matchingDoctors[indexPath.row].patients.count) + " Patients"
            cell.addressLabel.text = matchingDoctors[indexPath.row].address
        } else {
            if let img = doctors[indexPath.row].photoURL{
                if let imgurl = URL(string: img){
                    cell.doctorPhoto.kf.setImage(with: imgurl)
                    cell.doctorPhoto.kf.indicatorType = .activity
                }else {
                    cell.doctorPhoto.image = UIImage(named: "avatar")
                }
            }else {
                cell.doctorPhoto.image = UIImage(named: "avatar")
            }
            cell.doctorNameLabel.text = doctors[indexPath.row].name
            cell.patientsCountLabel.text = String(doctors[indexPath.row].patients.count) + " Patients"
            cell.addressLabel.text = doctors[indexPath.row].address
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    
    //Mark: SearchBar Protocols
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count != 0 else {
            searching = false
            tableView.reloadData()
            return
        }
        matchingDoctors = doctors.filter { $0.name.contains(searchText) != false }
        searching = true
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show patient"{
            let destination = segue.destination as! DoctorProfileViewController
            destination.doctor = (sender as! User)
        }
        else if segue.identifier == "show appointments" {
            let destination = segue.destination as! AppointmentsViewController
            destination.doctor = (sender as! User)
        }
    }

}
