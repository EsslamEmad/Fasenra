//
//  NotesViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 28/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD
import RZTransitions

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var notes = [Note]()
    var patientID: Int!
    var filterID: Int!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        self.transitioningDelegate = RZTransitionsManager.shared()
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getNotes(userID: patientID))
            }.done {
                let allNotes = try! JSONDecoder().decode([Note].self, from: $0)
                self.filterNotes(all: allNotes)
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
    
    func filterNotes(all: [Note]!){
        for note in all{
            if note.user.id == filterID{
                self.title = note.user.type == 1 ? "Doctor Notes" : "Nursing Company Notes"
                notes.append(note)
            }
        }
        
        tableView.reloadData()
    }

    //Mark: TableView Protocols
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notes.count == 0 {
            return 1
        }
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if notes.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "empty")!
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NoteTableViewCell
        cell.nameLabel.text = notes[indexPath.row].user.name
        cell.dateLabel.text = notes[indexPath.row].date
        cell.noteLabel.text = notes[indexPath.row].note
        if let img = notes[indexPath.row].user.photoURL{
            if let imgurl = URL(string: img){
                cell.profilePicture.kf.setImage(with: imgurl)
                cell.profilePicture.kf.indicatorType = .activity
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard notes.count != 0 else {
            return 40
        }
        let label = UILabel()
        label.numberOfLines = 0
        label.text = notes[indexPath.row].note
        let neededSize = label.sizeThatFits(CGSize(width: 280, height: CGFloat.greatestFiniteMagnitude))
        return neededSize.height > 86 ? neededSize.height + 90 : 152
    }

}
