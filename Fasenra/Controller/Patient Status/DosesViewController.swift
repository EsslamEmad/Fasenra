//
//  DosesViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 28/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import RZTransitions
import SVProgressHUD

class DosesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var patient: User!
    var doses = [Does]()
    var doctorName: String!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getDoes(userID: patient.id))
            }.done {
                self.doses = try! JSONDecoder().decode([Does].self, from: $0)
                firstly {
                    return API.CallApi(APIRequests.getUser(id: self.patient.doctorID!))
                    }.done {
                        let resp = try! JSONDecoder().decode(User.self, from: $0)
                        self.doctorName = resp.name
                        self.tableView.reloadData()
                    }.catch{
                        self.showAlert(withMessage: $0.localizedDescription)
                }
            }.catch{
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
        performSegue(withIdentifier: "edit dose", sender: doses[sender!.view!.tag])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if doses.count == 0{
            return 1
        }
        return doses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if doses.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "empty")!
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DoseTableViewCell
        /*if Default.def.user!.type == 1 {
            cell.nameLabel.text = patient.name
        }else {
            cell.nameLabel.text = doctorName}*/
        cell.nameLabel.text = "Dose \(indexPath.row + 1)"
        cell.dateLabel.text = doses[indexPath.row].date
        cell.editButton.tag = indexPath.row
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.didPressOnEdit(_:)))
        cell.editButton.addGestureRecognizer(gesture)
        if Default.def.user!.type != 3{
            cell.editButton.alpha = 0
        }
        switch doses[indexPath.row].status{
        case 1:
            cell.coloredView.backgroundColor = UIColor(red: 1, green: 160/255, blue: 0, alpha: 1)
            cell.statusLabel.text = "Pending"
            cell.statusLabel.textColor = UIColor(red: 1, green: 160/255, blue: 0, alpha: 1)
        case 2:
            cell.coloredView.backgroundColor = UIColor(red: 0, green: 171/255, blue: 80/255, alpha: 1)
            cell.statusLabel.text = "Confirmed"
            cell.statusLabel.textColor = UIColor(red: 0, green: 171/255, blue: 80/255, alpha: 1)
        case 3:
            cell.coloredView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
            cell.statusLabel.text = "Missed"
            cell.statusLabel.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit dose"{
            let destination = segue.destination as! ChooseDoseOptionsViewController
            destination.patient = patient
            destination.dose = (sender as! Does)
            destination.edit = true
        }
    }
    
    @IBAction func unwindToDoses(_ unwindSegue: UIStoryboardSegue) {
        viewDidLoad()
    }

}
