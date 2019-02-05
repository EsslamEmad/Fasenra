//
//  LoginViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 23/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import RZTransitions
import SVProgressHUD

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        emailTextField.layer.borderColor = UIColor(red: 200/255, green: 0, blue: 123/255, alpha: 1).cgColor
        emailTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor(red: 200/255, green: 0, blue: 123/255, alpha: 1).cgColor
        passwordTextField.layer.borderWidth = 1
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 125/255, green: 0.5, blue: 0.5, alpha: 1)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 125/255, green: 0.5, blue: 0.5, alpha: 1)])
        emailTextField.layer.cornerRadius = 10.0
        emailTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 10.0
        passwordTextField.clipsToBounds = true
        loginButton.layer.cornerRadius = 10.0
        loginButton.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = loginButton.bounds
        gradientLayer.colors = [UIColor(red: 158/255, green: 3/255, blue: 91/255, alpha: 1).cgColor, UIColor(red: 247/255, green: 0, blue: 158/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        loginButton.layer.addSublayer(gradientLayer)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = loginButton.bounds
        gradientLayer.colors = [UIColor(red: 158/255, green: 3/255, blue: 91/255, alpha: 1).cgColor, UIColor(red: 247/255, green: 0, blue: 158/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        loginButton.layer.addSublayer(gradientLayer)
    }
    

    @IBAction func didPressLogin(_ sender: UIButton){
        guard let email = emailTextField.text, email != "", let password = passwordTextField.text, password != "" else {
            return
        }
        sender.isEnabled = false
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.login(email: email, password: password))
            }.done { resp in
                Default.def.user = try! JSONDecoder().decode(User.self, from: resp)
                self.performMainSegue()
            }.catch { error in
                self.showAlert(withMessage: error.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
                sender.isEnabled = true
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        get {
            return true
        }
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



