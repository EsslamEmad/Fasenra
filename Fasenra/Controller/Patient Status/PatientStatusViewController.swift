//
//  PatientStatusViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 27/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import RZTransitions
import SVProgressHUD
import Kingfisher

class PatientStatusViewController: UIViewController {

    var patient: User!
   
    @IBOutlet weak var patientPhoto: UIImageView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientInsuranceLabel: UILabel!
    @IBOutlet weak var ACTQButton: UIButton!
    @IBOutlet weak var dosesView: UIView!
    @IBOutlet weak var doseDate: UILabel!
    @IBOutlet weak var doseTime: UILabel!
    @IBOutlet weak var showDosesButton: UIButton!
    @IBOutlet weak var comanyNotesView: UIView!
    @IBOutlet weak var companyPhoto: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyNoteDateLabel: UILabel!
    @IBOutlet weak var companyNoteContentLabel: UILabel!
    @IBOutlet weak var showCompanyNotes: UIButton!
    @IBOutlet weak var doctorNotesView: UIView!
    @IBOutlet weak var doctorPhoto: UIImageView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorNoteDateLabel: UILabel!
    @IBOutlet weak var doctorNoteContentLabel: UILabel!
    @IBOutlet weak var showDoctorNotesButton: UIButton!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nursingNotesIcon: UIImageView!
    @IBOutlet weak var nursingNotesLabel: UILabel!
    @IBOutlet weak var doctorNotesIcon: UIImageView!
    @IBOutlet weak var doctorNotesLabel: UILabel!
    @IBOutlet weak var nursingShowAllLabel: UILabel!
    @IBOutlet weak var doctorShowAllLabell: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.transitioningDelegate = RZTransitionsManager.shared()
        patientPhoto.layer.cornerRadius = 40
        patientPhoto.clipsToBounds = true
        ACTQButton.layer.cornerRadius = 15.0
        ACTQButton.clipsToBounds = true
        dosesView.layer.cornerRadius = 10.0
        dosesView.clipsToBounds = true
        showDosesButton.layer.cornerRadius = 15.0
        showDosesButton.clipsToBounds = true
        comanyNotesView.layer.cornerRadius = 10.0
        comanyNotesView.clipsToBounds = true
        companyPhoto.layer.cornerRadius = 16.0
        companyPhoto.clipsToBounds = true
        showCompanyNotes.layer.cornerRadius = 15.0
        showCompanyNotes.clipsToBounds = true
        doctorNotesView.layer.cornerRadius = 10.0
        doctorNotesView.clipsToBounds = true
        doctorPhoto.layer.cornerRadius = 16.0
        doctorPhoto.clipsToBounds = true
        showDoctorNotesButton.layer.cornerRadius = 15.0
        showDoctorNotesButton.clipsToBounds = true
        addNoteButton.layer.cornerRadius = 24.0
        addNoteButton.clipsToBounds = true
        firstly{
            return API.CallApi(APIRequests.getUser(id: patient.id))
            }.done {
                self.patient = try! JSONDecoder().decode(User.self, from: $0)
                self.fillPage()
            }.catch {error in
                
            }.finally{
                
        }
        fillPage()
        if Default.def.user!.type == 2 {
            ACTQButton.alpha = 0
            addNoteButton.alpha = 0
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.tabBarController?.tabBar.isHidden = true
        firstly{
            return API.CallApi(APIRequests.getUser(id: patient.id))
            }.done {
                self.patient = try! JSONDecoder().decode(User.self, from: $0)
                self.fillPage()
            }.catch {error in
                
            }.finally{
                
        }
    
    }
    
    func fillPage(){
        scrollView.isScrollEnabled = true
        if let img = patient.photoURL{
            if let imgurl = URL(string: img){
                patientPhoto.kf.setImage(with: imgurl)
                patientPhoto.kf.indicatorType = .activity
            }
        }
        patientNameLabel.text = patient.name
        if let insurance = patient.insurance {
            patientInsuranceLabel.text = insurance
        }
        if let dose = patient.currentDose{
            // let dateFormatter = DateFormatter()
            //doseDate.text = "Date: \(dateFormatter.string(from: dose.date))"
            doseDate.text = "Date: \(dose.date!)"
            doseTime.text = "Time: \(dose.time ?? "0:00")"
        }
        if let companyNote = patient.companyNote{
            if let img = companyNote.user.photoURL{
                if let imgurl = URL(string: img){
                    companyPhoto.kf.setImage(with: imgurl)
                    companyPhoto.kf.indicatorType = .activity
                }
            }
            companyNameLabel.text = companyNote.user.name
            companyNoteDateLabel.text = companyNote.date
            companyNoteContentLabel.text = companyNote.note
            if comanyNotesView.alpha == 0 {
                nursingNotesIcon.alpha = 1
                nursingNotesLabel.alpha = 1
                comanyNotesView.alpha = 1
                showCompanyNotes.alpha = 1
                nursingShowAllLabel.alpha = 1
                scrollView.isScrollEnabled = true
                let constraint = NSLayoutConstraint(item: doctorNotesIcon, attribute: .top, relatedBy: .equal, toItem: dosesView, attribute: .bottom, multiplier: 1, constant: 30)
                let constraint2 = NSLayoutConstraint(item: doctorNotesIcon, attribute: .top, relatedBy: .equal, toItem: comanyNotesView, attribute: .bottom, multiplier: 1, constant: 30)
                scrollView.removeConstraint(constraint)
                scrollView.addConstraint(constraint2)
            }
        } else if comanyNotesView.alpha == 1{
            nursingNotesIcon.alpha = 0
            nursingNotesLabel.alpha = 0
            comanyNotesView.alpha = 0
            showCompanyNotes.alpha = 0
            nursingShowAllLabel.alpha = 0
            scrollView.isScrollEnabled = false
            let constraint = NSLayoutConstraint(item: doctorNotesIcon, attribute: .top, relatedBy: .equal, toItem: dosesView, attribute: .bottom, multiplier: 1, constant: 30)
            scrollView.addConstraint(constraint)
            
        }
        if let doctorNote = patient.doctorNote{
            if let img = doctorNote.user.photoURL{
                if let imgurl = URL(string: img){
                    doctorPhoto.kf.setImage(with: imgurl)
                    doctorPhoto.kf.indicatorType = .activity
                }
            }
            doctorNameLabel.text = doctorNote.user.name
            doctorNoteDateLabel.text = doctorNote.date
            doctorNoteContentLabel.text = doctorNote.note
            if doctorNotesView.alpha == 0 {
                doctorNotesIcon.alpha = 1
                doctorNotesLabel.alpha = 1
                doctorNotesView.alpha = 1
                showDoctorNotesButton.alpha = 1
                doctorShowAllLabell.alpha = 1
                scrollView.isScrollEnabled = true
            }
        } else {
            doctorNotesIcon.alpha = 0
            doctorNotesLabel.alpha = 0
            doctorNotesView.alpha = 0
            showDoctorNotesButton.alpha = 0
            doctorShowAllLabell.alpha = 0
            scrollView.isScrollEnabled = false
        }
        makeGradientLayer(button: showDosesButton)
        makeGradientLayer(button: showDoctorNotesButton)
        makeGradientLayer(button: showCompanyNotes)
    }
    
    func makeGradientLayer(button: UIButton){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [UIColor(red: 158/255, green: 3/255, blue: 91/255, alpha: 1).cgColor, UIColor(red: 247/255, green: 0, blue: 158/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        button.layer.addSublayer(gradientLayer)
    }
    
    @IBAction func didPressShowDoses(_ sender: Any) {
         performSegue(withIdentifier: "show doses", sender: nil)
    }
    
    @IBAction func didPressShowNotes(_ sender: UIButton) {
        performSegue(withIdentifier: "show notes", sender: sender.tag == 0 ? patient.nursingCompanyID : patient.doctorID)
    }
    
    @IBAction func didPressAddNote(_ sender: Any) {
        performSegue(withIdentifier: "add note", sender: patient.id)
    }
    
    @IBAction func didPressACTQ(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add note"{
            let destination = segue.destination as! AddNoteViewController
            destination.patientID = (sender as! Int)
        }else if segue.identifier == "show notes" {
            let destination = segue.destination as! NotesViewController
            destination.patientID = patient.id
            destination.filterID = (sender as! Int)
        } else if segue.identifier == "show doses" {
            let destination = segue.destination as! DosesViewController
            destination.patient = patient
        }else if segue.identifier == "show actq"{
            let destination = segue.destination as! AllACTQViewController
            destination.patient = patient
        }
    }
    
    @IBAction func unwindToPatientStatus(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "unwind from add note"{
            
            firstly{
                return API.CallApi(APIRequests.getUser(id: patient.id))
                }.done {
                    self.patient = try! JSONDecoder().decode(User.self, from: $0)
                    self.viewDidLoad()
                }.catch {error in
                    
                }.finally{
                  
            }
        }
    }
}
