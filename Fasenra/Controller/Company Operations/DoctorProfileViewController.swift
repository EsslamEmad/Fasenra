//
//  DoctorProfileViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 27/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import RZTransitions
import SVProgressHUD
import PromiseKit

class DoctorProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var doctor: User!
    var patients: [User]!
    var matchingPatients: [User]!
    var searching = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var patientsCountLabel: UILabel!
    @IBOutlet weak var doctorPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        patients = doctor.patients
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderWidth = 0
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        doctorNameLabel.text = doctor.name
        patientsCountLabel.text = String(patients.count) + " Patients"
        doctorPhoto.layer.cornerRadius = 50.0
        doctorPhoto.clipsToBounds = true
        if let img = doctor.photoURL{
            if let imgurl = URL(string: img){
                doctorPhoto.kf.setImage(with: imgurl)
                doctorPhoto.kf.indicatorType = .activity
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    @objc func showPatient(_ gesture: UITapGestureRecognizer){
        if searching{
            performSegue(withIdentifier: "show patient", sender: matchingPatients[gesture.view!.tag])
        }else {
            performSegue(withIdentifier: "show patient", sender: patients[gesture.view!.tag])
        }
    }
    
    @objc func didPressOnEdit(_ sender: UITapGestureRecognizer?) {
        let alert = UIAlertController(title: "Edit", message: NSLocalizedString("Edit Insurance:", comment: ""), preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.searching ? self.matchingPatients[sender!.view!.tag].insurance : self.patients[sender!.view!.tag].insurance
        }
        let editInsuranceAction = UIAlertAction(title: NSLocalizedString("Edit Insurance", comment: ""), style: .default, handler: { (UIAlertAction) in
            if let textField = alert.textFields?.first{
                guard let insurance = textField.text, insurance != "" else {
                    return
                }
                let user = self.searching ? self.matchingPatients[sender!.view!.tag] : self.patients[sender!.view!.tag]
                var patient = User()
                patient.insurance = insurance
                patient.idForEdit = user.id
                SVProgressHUD.show()
                firstly{
                    return API.CallApi(APIRequests.editUser(user: patient))
                    } .done{ resp in
                        let patient  = try! JSONDecoder().decode(User.self, from: resp)
                        if let foo = self.patients.index(where: { $0.id == patient.id}){
                            self.patients[foo] = patient
                        }
                        if let foo = self.matchingPatients.index(where: { $0.id == patient.id}){
                            self.matchingPatients[foo] = patient
                        }
                        alert.dismiss(animated: true, completion: nil)
                        self.showAlert(error: false, withMessage: "Insurance has been updated.", completion: nil)
                    }.catch {
                        self.showAlert(withMessage: $0.localizedDescription)
                    }.finally {
                        SVProgressHUD.dismiss()
                }
            }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(editInsuranceAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    //Mark: TableView Protocols
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return matchingPatients.count
        } else {
            return patients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PatientTableViewCell
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showPatient(_:)))
        cell.containerView.tag = indexPath.row
        cell.containerView.addGestureRecognizer(gesture)
        cell.editButton.tag = indexPath.row
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.didPressOnEdit(_:)))
        cell.editButton.addGestureRecognizer(gesture1)
        if searching{
            if let img = matchingPatients[indexPath.row].photoURL{
                if let imgurl = URL(string: img){
                    cell.patientPhoto.kf.setImage(with: imgurl)
                    cell.patientPhoto.kf.indicatorType = .activity
                }else {
                    cell.patientPhoto.image = UIImage(named: "avatar")
                }
            }else {
                cell.patientPhoto.image = UIImage(named: "avatar")
            }
            cell.patientNameLabel.text = matchingPatients[indexPath.row].name
            cell.actqLabel.text = "ACTQ score: "  + String(matchingPatients[indexPath.row].score ?? 0)
        }else {
            if let img = patients[indexPath.row].photoURL{
                if let imgurl = URL(string: img){
                    cell.patientPhoto.kf.setImage(with: imgurl)
                    cell.patientPhoto.kf.indicatorType = .activity
                }
                else {
                    cell.patientPhoto.image = UIImage(named: "avatar")
                }
            }else {
                cell.patientPhoto.image = UIImage(named: "avatar")
            }
            cell.patientNameLabel.text = patients[indexPath.row].name
            cell.actqLabel.text = "ACTQ score: "  + String(patients[indexPath.row].score ?? 0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
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
        matchingPatients = patients.filter { $0.name.contains(searchText) != false }
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
            let destination = segue.destination as! PatientStatusViewController
            destination.patient = (sender as! User)
        }
    }
}
