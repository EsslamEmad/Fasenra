//
//  ChooseDoctorViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 28/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD
import RZTransitions

class ChooseDoctorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var users = [User]()
    var doctors = [User]()
    var searching  = false
    var matchingDoctors: [User]!
    var choosenIndex: Int!
    var patient: User!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    
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
        nextButton.layer.cornerRadius = 5.0
        nextButton.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor(red: 177/255, green: 15/255, blue: 90/255, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
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
        let cell = tableView.cellForRow(at: IndexPath(row: gesture.view!.tag, section: 0)) as! MyDoctorTableViewCell
        cell.radioButton.alpha = 1
        
        if choosenIndex != nil {
            if let previousCell = tableView.cellForRow(at: IndexPath(row: choosenIndex, section: 0)) as? MyDoctorTableViewCell{
                previousCell.radioButton.alpha = 0
                
            }
        }
        choosenIndex = gesture.view!.tag
        if searching{
            patient.doctorID = matchingDoctors[choosenIndex].id
        } else {
            patient.doctorID = doctors[choosenIndex].id
        }
    }
    
    @IBAction func didPressNext(_ sender: UIButton){
        guard patient.doctorID != nil else {
            return
        }
        performSegue(withIdentifier: "choose dose time", sender: patient)
    }
    
    //Mark: TableView Protocols
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return matchingDoctors.count
        }
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyDoctorTableViewCell
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showPatient(_:)))
        cell.containerView.tag = indexPath.row
        cell.containerView.addGestureRecognizer(gesture)
        if indexPath.row != choosenIndex{
            cell.radioButton.alpha = 0
        } else {
            cell.radioButton.alpha = 1
        }
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
        choosenIndex = nil
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "choose dose time"{
            let destination = segue.destination as! ChooseDoseOptionsViewController
            destination.patient = (sender as! User)
        }
    }
    
}
