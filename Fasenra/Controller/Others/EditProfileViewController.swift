//
//  EditProfileViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 31/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD
import RZTransitions

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editButton.layer.cornerRadius = 10.0
        editButton.clipsToBounds = true
        nameLabel.text = Default.def.user?.name
        emailLabel.text = Default.def.user?.email
        phoneLabel.text = Default.def.user?.phone
        if let img = Default.def.user?.photoURL{
            if let imgurl = URL(string: img){
                profilePicture.kf.setImage(with: imgurl)
                profilePicture.kf.indicatorType = .activity
            }
        }
        self.transitioningDelegate = RZTransitionsManager.shared()
    }
    
   

    @IBAction func didPressEdit(_ sender: UIButton){
        guard let email = emailLabel.text, email != "", let phone = phoneLabel.text, phone != "" else {
            return
        }
        
        var user = User()
        user.idForEdit = Default.def.user!.id
        if email != Default.def.user!.email {
            user.email = email
        }
        if phone != Default.def.user!.phone{
            user.phone = phone
        }
        
        if let password = passwordLabel.text, password != ""{
            user.password = password
        }
        
        if ImagePicked{
            SVProgressHUD.show()
            firstly{
                return API.CallApi(APIRequests.upload(image: profilePicture.image, file: nil))
                }.done {
                    let resp = try! JSONDecoder().decode(Photo.self, from: $0)
                    user.photo = resp.image
                    self.editRequest(user: user)
                }.catch {
                    self.showAlert(withMessage: $0.localizedDescription)
                    SVProgressHUD.dismiss()
            }
        }else {
            SVProgressHUD.show()
            editRequest(user: user)
        }
        
    }
    
    func editRequest(user: User){
        firstly{
            return API.CallApi(APIRequests.editUser(user: user))
            }.done{
                Default.def.user = try! JSONDecoder().decode(User.self, from: $0)
                self.showAlert(error: false, withMessage: "Your profile has been updated succefully.", completion: nil)
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
