//
//  ViewController.swift
//  Fire
//
//  Created by DocAdmin on 5/19/18.
//  Copyright © 2018 Lima. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var labelEmail: UITextField!
    @IBOutlet weak var labelPassword: UITextField!
    @IBOutlet weak var labelError: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        isAuth2()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    @IBAction func isAuth(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "dashboard", sender: nil)
        } else {
            print("nao temosuser")
        }
    }
    
    fileprivate func isAuth2() {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "dashboard", sender: nil)
        } else {
            print("nao temosuser")
        }
    }
    
    
    
    

    @IBAction func registarUtilizador(_ sender: Any) {
        Auth.auth().signIn(withEmail: labelEmail.text!, password: labelPassword.text!) { (authResult, error) in
                guard let email = authResult?.user.email, error == nil else {
                 self.labelError.text = error!.localizedDescription
                    return
                }
            print("\(email) created")
            
        }
    }
}

