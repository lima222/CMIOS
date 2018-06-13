//
//  gameController.swift
//  Fire
//
//  Created by DocAdmin on 6/13/18.
//  Copyright © 2018 Lima. All rights reserved.
//

import UIKit
import Firebase


class gameController: UIViewController {
    
    var db: Firestore!
    var docID: String!
    var criou: Bool!

    @IBOutlet weak var criarBTN: UIButton!
    @IBOutlet weak var jogarBTN: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        criou = false
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        jogarBTN.isHidden = true
        criarBTN.isHidden = true
        
        
        db.collection("embateReal").whereField("started", isEqualTo: false).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if(querySnapshot!.documents.count > 0) {
                        self.docID = querySnapshot!.documents[0].documentID
                        self.jogarBTN.isHidden = false
                    } else {
                        self.criarBTN.isHidden = false
  
                    }
                    
                }
        }
    }
    
    @IBAction func criarMesa(_ sender: Any) {
        
        var ref: DocumentReference? = nil
        ref = self.db.collection("embateReal").addDocument(data: [
            "etapa": 0,
            "p1": 0,
            "p2": 0,
            "uid1": "",
            "uid2": "",
            "started": false,
            ]) { err in
                if let err = err {
                    print("error")
                } else {
                    print(ref!.documentID)
                }
        
        
         }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueJogar") {
            let game = (segue.destination as! realGame)
            game.docID = self.docID
            game.player = 2
        }
        
        
        
        if(segue.identifier == "segueJogarCriar") {
            print("idiasd")
            let game = (segue.destination as! realGame)
            game.docID = self.docID
            game.player = 1
        }
    }
    
    
    
    
    
}
