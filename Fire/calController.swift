//
//  calController.swift
//  Fire
//
//  Created by DocAdmin on 6/15/18.
//  Copyright © 2018 Lima. All rights reserved.
//

import UIKit
import Firebase


class calController: UIViewController {

  let user = Auth.auth().currentUser
    var db: Firestore!
 
    @IBOutlet weak var desc2: UITextField!
   
    
    @IBOutlet weak var date: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    
    
    
    @IBAction func addA(_ sender: Any) {
        self.db.collection("usertarefas").addDocument(data: [
            "uid": self.user?.uid,
            "desc": self.desc2.text,
            "date": date.date,
            
            ])
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
   
}
