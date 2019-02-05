//
//  AboutAppViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 28/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import AVFoundation
import AVKit
import SVProgressHUD

class AboutAppViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoThumb: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var page: AboutApp!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.layer.cornerRadius = 10.0
        containerView.clipsToBounds = true
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.aboutApp)
            }.done {
                self.page = try! JSONDecoder().decode(AboutApp.self, from: $0)
                
                
                self.titleLabel.text = self.page.title
                self.contentTextView.attributedText = self.page.details.html2AttributedString
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func playVideo(_ gesture: UITapGestureRecognizer){
        guard let url = URL(string: page?.video ?? "") else {
            return
        }
        
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
        
        // Modally present the player and call the player's play() method when complete.
        self.present(controller, animated: true) {
            player.play()
        }
    }
}

extension Data {
    var html2AttributedString: NSMutableAttributedString? {
        do {
            return try NSMutableAttributedString(data: self, options: [.documentType: NSMutableAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSMutableAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
