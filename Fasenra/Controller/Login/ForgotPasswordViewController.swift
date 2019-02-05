//
//  ForgotPasswordViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 23/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import RZTransitions
import SVProgressHUD

class ForgotPasswordViewController: UIViewController {

    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        emailTextField.layer.borderColor = UIColor(red: 200/255, green: 0, blue: 123/255, alpha: 1).cgColor
        emailTextField.layer.borderWidth = 1
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 125/255, green: 0.5, blue: 0.5, alpha: 1)])
        emailTextField.layer.cornerRadius = 10.0
        emailTextField.clipsToBounds = true
        sendButton.layer.cornerRadius = 10.0
        sendButton.clipsToBounds = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = sendButton.bounds
        gradientLayer.colors = [UIColor(red: 158/255, green: 3/255, blue: 91/255, alpha: 1).cgColor, UIColor(red: 247/255, green: 0, blue: 158/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        sendButton.layer.addSublayer(gradientLayer)
    }

    @IBAction func didPressBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didPressSend(_ sender: UIButton){
        guard let email = emailTextField.text, email != "" else {
            return
        }
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.forgotPassword(email: email))
            }.done { resp in
                self.showAlert(error: false, withMessage: "DONE", completion: {(UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        get {
            return true
        }
    }
}
