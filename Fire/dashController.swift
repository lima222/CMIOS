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
    
    @IBOutlet weak var pontos: UILabel!
    @IBOutlet weak var name: UILabel!
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
        self.name.text = user?.displayName as! String
        
        
        
        
        // [START setup]
        var db: Firestore!
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        print(user?.uid)
        db.collection("utilizador").whereField("uid", isEqualTo: user?.uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var valor = document.data()["pontos"] as! Int
                    self.pontos.text = String(valor)
                    
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser
        
        var db: Firestore!
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        db.collection("utilizador").whereField("uid", isEqualTo: user?.uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var valor = document.data()["pontos"] as! Int
                    self.pontos.text = String(valor)
                    
                }
            }
        }
    }
    
   
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            exit(0)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    @IBAction func sauHello(_ sender: Any) {
        
    }
}
