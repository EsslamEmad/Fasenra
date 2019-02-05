//
//  AddPatientViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 27/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import RZTransitions
import PromiseKit
import SVProgressHUD

class AddPatientViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var insuranceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = RZTransitionsManager.shared()
        submitButton.layer.cornerRadius = 5.0
        submitButton.clipsToBounds = true
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        insuranceTextField.delegate = self
        profilePicture.layer.cornerRadius = 64.0
        profilePicture.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func didPressSubmit(_ sender: UIButton){
        guard let email = emailTextField.text, email != "", let name = nameTextField.text, name != "", let phone = phoneTextField.text, phone != "", let insurance = insuranceTextField.text, insurance != ""  else {
            return
        }
        var user = User()
        user.name = name
        user.email = email
        user.phone = phone
        user.insurance = insurance
        user.nursingCompanyID = Default.def.user!.id
        user.type = 2
        user.addedType = 3
        
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.upload(image: profilePicture.image, file: nil))
            }.done {
                let resp = try! JSONDecoder().decode(Photo.self, from: $0)
                user.photo = resp.image
                self.performSegue(withIdentifier: "choose doctor", sender: user)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
        
    }
    @IBAction func PickImage(recognizer: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "", message: NSLocalizedString("Choose Photo Source", comment: ""), preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
            SVProgressHUD.show()
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: {() -> Void in SVProgressHUD.dismiss()})
            }
            else{
                SVProgressHUD.dismiss()
                self.showAlert(withMessage: NSLocalizedString("Application can not access your camera", comment: ""))
            }
        })
        let photoAction = UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
            SVProgressHUD.show()
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: {() -> Void in SVProgressHUD.dismiss()})
            }
            else{
                SVProgressHUD.dismiss()
                self.showAlert(withMessage: NSLocalizedString("Application can not access your photo library", comment: ""))
            }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    var ImagePicked = false
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = Dictionary(uniqueKeysWithValues: info.map {key, value in (key.rawValue, value)})
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage{
            profilePicture.image = selectedImage
            profilePicture.contentMode = .scaleAspectFill
            profilePicture.clipsToBounds = true
            ImagePicked = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "choose doctor"{
            let destination = segue.destination as! ChooseDoctorViewController
            destination.patient = (sender as! User)
        }
    }
    
}
