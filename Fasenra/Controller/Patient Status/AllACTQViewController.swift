//
//  AllACTQViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 30/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD
import RZTransitions


class AllACTQViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var ACTQs = [ACTQ]()
    var patient: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        self.transitioningDelegate = RZTransitionsManager.shared()
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getAnswers(patientID: patient.id))
            }.done {
                self.ACTQs = try! JSONDecoder().decode([ACTQ].self, from: $0)
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
    }
    
    @IBAction func showACTQ(_ gesture: UITapGestureRecognizer){
        performSegue(withIdentifier: "show actq", sender: ACTQs[gesture.view!.tag])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ACTQs.count == 0 {
            return 1
        }
        return ACTQs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ACTQs.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "empty")!
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ScoreTableViewCell
        
        cell.containerView.tag = indexPath.row
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showACTQ(_:)))
        cell.containerView.addGestureRecognizer(gesture)
        cell.nameLabel.text = patient.name
        cell.dateLabel.text = ACTQs[indexPath.row].date
        cell.scoreLabel.text = "Total Score: " + String(ACTQs[indexPath.row].score)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show actq"{
            let destination = segue.destination as! ACTQAnswersViewController
            destination.actq = (sender as! ACTQ)
        }
    }
    
}
