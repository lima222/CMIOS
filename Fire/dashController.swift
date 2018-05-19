//
//  dashController.swift
//  Fire
//
//  Created by DocAdmin on 5/19/18.
//  Copyright © 2018 Lima. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Kingfisher

class dashController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let user = Auth.auth().currentUser
        imageView.kf.setImage(with: user?.photoURL?.absoluteURL)
        imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3.0
        let red = UIColor(red: 100.0/255.0, green: 130.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        imageView.layer.borderColor = red.cgColor
    }
    
    
    
    @IBAction func sauHello(_ sender: Any) {
        
    }
}
