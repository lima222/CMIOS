//
//  realGame.swift
//  Fire
//
//  Created by DocAdmin on 6/13/18.
//  Copyright © 2018 Lima. All rights reserved.
//

import UIKit
import Firebase


class realGame: UIViewController {
    
    var db: Firestore!
    var docID: String!
    var player: Int!
    var etapa: Int!
    var opcao: Int!
    let user = Auth.auth().currentUser
    var mypontos: Int = 0
    
    @IBOutlet weak var teuspontos: UILabel!
    @IBOutlet weak var pontos: UILabel!
    @IBOutlet weak var pergunta: UILabel!
    @IBOutlet weak var r1: UIButton!
    @IBOutlet weak var r2: UIButton!
    @IBOutlet weak var r3: UIButton!
    @IBOutlet weak var r4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()

        print(docID)
        print(player)
        
        
        
        if(player == 2 ) {
            self.db.collection("embateReal").document(self.docID!).updateData([
                "started": true,
                "etapa": 1,
                "uid2": user?.uid
                ])
            
            startGame()
            
        } else {
            
            self.pergunta.text = "Aguardando user"
            
            db.collection("embateReal").document(self.docID!).addSnapshotListener {
                documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("error")
                    return
                }
                
                if(document.data()?["started"] as! Bool) {
                    self.startGame()
                }
                
            }
        }
    }

    func startGame() {
        self.etapa = 1
        
        showQuestion()
        let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) {
            (timer) in
            self.etapa = self.etapa + 1
            self.showQuestion()
            if(self.etapa > 2) {
                timer.invalidate()
            }
        }
        
        db.collection("embateReal").document(self.docID!).addSnapshotListener {
            documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("error")
                return
            }
            
            if(self.player == 1 ){
                self.pontos.text = "Inimigo: " + String(document.data()!["p2"] as! Int)
            } else {
                self.pontos.text = "Inimigo: " + String(document.data()!["p1"] as! Int)
            }
            
        }
    }
    
    
    func showQuestion() {
        self.db.collection("listaPerguntas").whereField("etapa", isEqualTo: self.etapa).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot!.documents.count > 0) {
                    
                    
                    let perg = querySnapshot!.documents[0].data()
                    
                    self.pergunta.text = perg["pergunta"] as? String
                    self.r1.setTitle(perg["R1"] as? String, for: .normal)
                    self.r2.setTitle(perg["R2"] as? String, for: .normal)
                    self.r3.setTitle(perg["R3"] as? String, for: .normal)
                    self.r4.setTitle(perg["R4"] as? String, for: .normal)
                    
                    self.opcao = perg["opcao"] as? Int
                    
                    self.allowBTNS()
                    
                }
            }

        }
    }
    
    func allowBTNS() {
        self.r1.backgroundColor = UIColor.lightGray
        self.r2.backgroundColor = UIColor.lightGray
        self.r3.backgroundColor = UIColor.lightGray
        self.r4.backgroundColor = UIColor.lightGray
        self.r1.isEnabled = true;
        self.r2.isEnabled = true;
        self.r3.isEnabled = true;
        self.r4.isEnabled = true;
    }
    
    func blockBTNS() {
        self.teuspontos.text = "Tu: " + String(self.mypontos);
        self.r1.setTitleColor(UIColor.black, for: .normal)
        self.r2.setTitleColor(UIColor.black, for: .normal)
        self.r3.setTitleColor(UIColor.black, for: .normal)
        self.r4.setTitleColor(UIColor.black, for: .normal)
        
        self.r1.isEnabled = false;
        self.r2.isEnabled = false;
        self.r3.isEnabled = false;
        self.r4.isEnabled = false;
    }
    
    @IBAction func r1(_ sender: Any) {
        blockBTNS()
        
        if(self.opcao == 1) {
            self.r1.backgroundColor = UIColor.green
            mypontos = mypontos + 5
            
        } else {
            self.r1.backgroundColor = UIColor.red
        }
        
        
        
       
    }
    
    @IBAction func r2(_ sender: Any) {
        
        
        blockBTNS()
        
        if(self.opcao == 2) {
            self.r2.backgroundColor = UIColor.green
            mypontos = mypontos + 5
        } else {
            self.r2.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func r3(_ sender: Any) {
        
        blockBTNS()
        
        if(self.opcao == 3) {
            self.r3.backgroundColor = UIColor.green
            mypontos = mypontos + 5
        } else {
            self.r3.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func r4(_ sender: Any) {
        
        
        blockBTNS()
        
        if(self.opcao == 4) {
            self.r4.backgroundColor = UIColor.green
            mypontos = mypontos + 5
        } else {
            self.r4.backgroundColor = UIColor.red
        }
        
    }
}

    
