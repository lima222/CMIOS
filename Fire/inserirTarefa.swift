//
//  inserirTarefa.swift
//  Fire
//
//  Created by DocAdmin on 6/8/18.
//  Copyright © 2018 Lima. All rights reserved.
//

import UIKit
import Firebase


class inserirTarefa: UIViewController {
    
    var nomeCadeira: String = ""
    let user = Auth.auth().currentUser
    var db: Firestore!
    @IBOutlet weak var nameTask: UITextField!
    
    @IBOutlet weak var descTask: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        
        
        

        
        
    }
    
    @IBAction func addTask(_ sender: Any) {
        self.db.collection("tarefas").addDocument(data: [
            "uid": self.user?.uid,
            "cadeira": self.nomeCadeira,
            "desc": self.descTask.text!,
            "nome": self.nameTask.text!,
            "pontos": 0,
            "global": false,
            ])
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var addTarefa: UIButton!
    
    
}
