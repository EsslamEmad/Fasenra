//
//  AddDoctorViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 24/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import RZTransitions
import SVProgressHUD

class AddDoctorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = RZTransitionsManager.shared()
        submitButton.layer.cornerRadius = 5.0
        submitButton.clipsToBounds = true
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        addressTextField.delegate = self
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
        guard let email = emailTextField.text, email != "", let name = nameTextField.text, name != "", let phone = phoneTextField.text, phone != "", let address = addressTextField.text, address != "" else {
            return
        }
        var user = User()
        user.name = name
        user.email = email
        user.phone = phone
        user.nursingCompanyID = Default.def.user!.id
        user.type = 1
        user.address = address
        
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.upload(image: profilePicture.image, file: nil))
            }.done {
                let resp = try! JSONDecoder().decode(Photo.self, from: $0)
                user.photo = resp.image
                firstly{
                    return API.CallApi(APIRequests.register(user: user))
                    }.done { resp in
                        self.showAlert(error: false, withMessage: "New doctor has been added succefully.", completion: {(UIAlertAction) in
                            self.dismiss(animated: true, completion: nil)
                        })
                    }.catch {
                        self.showAlert(withMessage: $0.localizedDescription)
                    }
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
    
    
    
}


