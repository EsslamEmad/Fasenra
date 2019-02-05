//
//  RequestUserViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 29/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import RZTransitions

class RequestUserViewController: UIViewController {
    
    var bool1 = false
    var bool2 = false
    var bool3 = false

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var check1: UIImageView!
    @IBOutlet weak var check2: UIImageView!
    @IBOutlet weak var check3: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.layer.cornerRadius = 10.0
        submitButton.clipsToBounds = true
        self.transitioningDelegate = RZTransitionsManager.shared()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func didPressSubmit(_ sender: UIButton){
        guard let name = nameTextField.text, name != "", let phone = phoneTextField.text, phone != "" else {
            return
        }
        var user = User()
        user.name = name
        user.phone = phone
        user.addedType = 1
        user.doctorID = Default.def.user!.id
        user.nursingCompanyID = Default.def.user!.nursingCompanyID
        user.type = 2
        var comments = ""
        if bool1 {
            comments += "Information Briefing\n"
        }
        if bool2{
            comments += "Insurance Navigation\n"
        }
        if bool3{
            comments += "Affordability"
        }
        user.additionalComments = comments
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.register(user: user))
            }.done { resp in
                self.showAlert(error: false, withMessage: "Patient has been requested to the nursing company", completion: {(UIAlertAction) in
                    self.performMainSegue()
                })
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func Check1(_ gesture: UITapGestureRecognizer){
        bool1 = !bool1
        check1.alpha = bool1 ? 1 : 0
    }
    @IBAction func Check2(_ gesture: UITapGestureRecognizer){
        bool2 = !bool2
        check2.alpha = bool2 ? 1 : 0
    }
    @IBAction func Check3(_ gesture: UITapGestureRecognizer){
        bool3 = !bool3
        check3.alpha = bool3 ? 1 : 0
    }

    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }

}
