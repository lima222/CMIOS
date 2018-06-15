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
    let user = Auth.auth().currentUser
    var meuspontos: Int = 10000
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var opponent: UILabel!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var insertRoom: UITextField!
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
        insertRoom.isHidden = true
        roomName.isHidden = true
        
        
        db.collection("embateReal").whereField("started", isEqualTo: false).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if(querySnapshot!.documents.count > 0) {
                        self.docID = querySnapshot!.documents[0].documentID
                        
                        if(self.meuspontos != 10000 && self.meuspontos > 5) {
                            self.jogarBTN.isHidden = false
                        }
                        
                        self.roomName.text = "Room: " + (querySnapshot!.documents[0].data()["name"] as! String)
                        self.roomName.isHidden = false
                        var uid = (querySnapshot!.documents[0].data()["uid1"] as! String)
                        print(uid)
                        
                        self.db.collection("utilizador").whereField("uid", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                self.opponent.text = querySnapshot!.documents[0].data()["nome"] as! String
                            }
                        }
                                
                    } else {
                        self.criarBTN.isHidden = false
                        self.insertRoom.isHidden = false
                    }
                    
                }
        }
        
        
        
        
        self.db.collection("utilizador").whereField("uid", isEqualTo: self.user?.uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot!.documents.count > 0) {
                    self.meuspontos = querySnapshot!.documents[0].data()["pontos"] as! Int
                    if(self.meuspontos < 5) {
                        self.points.isHidden = false
                        self.jogarBTN.isHidden = true
                    }else {
                        self.jogarBTN.isHidden = false
                    }
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
            "uid1": user?.uid,
            "name": self.insertRoom.text!,
            "uid2": "",
            "started": false,
            ]) { err in
                if let err = err {
                    print("error")
                } else {
                    self.docID = ref!.documentID
                    self.criou = true
                    self.criarBTN.isHidden = true
                    self.jogarBTN.isHidden = false
                    self.insertRoom.isHidden = true
                    self.roomName.text = "Room: " + self.insertRoom.text!
                    self.roomName.isHidden = false
                    
                }
        
        
         }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueJogar") {
            let game = (segue.destination as! realGame)
            game.docID = self.docID
            
            if(criou) {
                game.player = 1
            } else {
                game.player = 2
            }
            
        }
        
        
        
        if(segue.identifier == "segueJogarCriar") {
    
            let game = (segue.destination as! realGame)
            game.docID = self.docID
            game.player = 1
        }
    }
    
    
    
    
    
}
