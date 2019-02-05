//
//  AddNoteViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 28/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD


class AddNoteViewController: UIViewController {

    var patientID: Int!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addNoteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.layer.cornerRadius = 10.0
        containerView.clipsToBounds = true
        backButton.layer.cornerRadius = 24.0
        backButton.clipsToBounds = true
        addNoteButton.layer.cornerRadius = 15.0
        addNoteButton.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = addNoteButton.bounds
        gradientLayer.colors = [UIColor(red: 158/255, green: 3/255, blue: 91/255, alpha: 1).cgColor, UIColor(red: 247/255, green: 0, blue: 158/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        addNoteButton.layer.addSublayer(gradientLayer)
    }
    

    @IBAction func didPressBack(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressBack1(_ gesture: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressAddNote(_ sender: UIButton){
        SVProgressHUD.show()
        let note = Note()
        note.note = textView.text
        note.patientID = patientID
        note.user.id = Default.def.user!.id
        firstly{
            return API.CallApi(APIRequests.addNote(note: note))
            }.done { resp in
                self.showAlert(error: false, withMessage: "Note has been added", completion: {(UIAlertAction) in
                    self.performSegue(withIdentifier: "unwind from add note", sender: nil)
                })
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }

}
