//
//  RequestAppointmentViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 30/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import RZTransitions
import PromiseKit
import SVProgressHUD

class RequestAppointmentViewController: UIViewController {

    var info: ContactInfo!
    @IBOutlet weak var ContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ContainerView.layer.cornerRadius = 15.0
        ContainerView.clipsToBounds = true
        self.transitioningDelegate = RZTransitionsManager.shared()
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getInfo)
            }.done {
                self.info = try! JSONDecoder().decode(ContactInfo.self, from: $0)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    
    @IBAction func dismissView(_ gesture: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callNow(_ gesture : UITapGestureRecognizer){
        guard info != nil else {
            return
        }
        let cleanPhoneNumber = info.phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        let urlString:String = "tel://\(cleanPhoneNumber)"
        if let phoneCallURL = URL(string: urlString) {
            if (UIApplication.shared.canOpenURL(phoneCallURL)) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func requestAppoitment(_ gesture: UITapGestureRecognizer){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.requestAppointment)
            }.done { resp in
                self.showAlert(error: false, withMessage: "Request has been sent.", completion: {(UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    

}
