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
    var opponent: String = "null"
    
    @IBOutlet weak var winner: UILabel!
    @IBOutlet weak var finalI: UILabel!
    @IBOutlet weak var finalu: UILabel!
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
            
            
            self.db.collection("embateReal").document(self.docID!).getDocument { (document, error) in
                if let document = document, document.exists {
                    let doc = document.data()?["uid1"] as! String
                    print(doc)
                    
                    self.db.collection("utilizador").whereField("uid", isEqualTo: doc).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            self.opponent = (querySnapshot!.documents[0].data()["nome"] as! String)
                            self.pontos.text = self.opponent + ": 0"
                            self.startGame()
                        }
                    }
                } else{
                    print("hi")
                }
                
            }
            
           
            
           
            
            
            
        } else {
            
            self.pergunta.text = "Aguardando user"
            
            db.collection("embateReal").document(self.docID!).addSnapshotListener {
                documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("error")
                    return
                }
                
                if(document.data()?["started"] as! Bool) {
                    self.db.collection("embateReal").document(self.docID!).getDocument { (document, error) in
                        if let document = document, document.exists {
                            let doc = document.data()?["uid2"] as! String
                            print(doc)
                            
                            self.db.collection("utilizador").whereField("uid", isEqualTo: doc).getDocuments() { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else {
                                    self.opponent = (querySnapshot!.documents[0].data()["nome"] as! String)
                                    self.pontos.text = self.opponent + ": 0"
                                    self.startGame()
                                    
                                }
                            }
                        } else{
                            print("hi")
                        }
                        
                    }
                    
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
                
                
                self.db.collection("embateReal").document(self.docID!).addSnapshotListener {
                    documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("error")
                        return
                    }
                    
                    var pontosI = 0
                    var vencedor = ""
                    self.finalu.text = "Tu: " + String(self.mypontos)
                    if(self.player == 1 ){
                        self.finalI.text =  self.opponent + ": " + String(document.data()!["p2"] as! Int)
                        
                        pontosI = (document.data()!["p2"] as! Int)
                        
                        if(pontosI > self.mypontos) {
                            vencedor = "You lose for: " + self.opponent
                            
                            self.db.collection("utilizador").whereField("uid", isEqualTo: self.user?.uid).getDocuments() { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else {
                                    if(querySnapshot!.documents.count > 0) {
                                        let fpontos = querySnapshot!.documents[0].data()["pontos"] as! Int
                                        self.db.collection("utilizador").document(querySnapshot!.documents[0].documentID).updateData([
                                            "pontos": fpontos - 5
                                            ])
                                    }
                                }
                                
                            }
                        }else {
                            vencedor = "You win"
                            
                            
                            
                            
                            self.db.collection("utilizador").whereField("uid", isEqualTo: self.user?.uid).getDocuments() { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else {
                                    if(querySnapshot!.documents.count > 0) {
                                        let fpontos = querySnapshot!.documents[0].data()["pontos"] as! Int
                                        self.db.collection("utilizador").document(querySnapshot!.documents[0].documentID).updateData([
                                            "pontos": fpontos + 5
                                            ])
                                    }
                                }
                                
                            }

                        }
                        
                        
                        
                    } else {
                        self.finalI.text =  self.opponent + ": " + String(document.data()!["p1"] as! Int)
                        pontosI = (document.data()!["p1"] as! Int)
                        
                        if(pontosI < self.mypontos) {
                            vencedor = "You win"
                            
                            self.db.collection("utilizador").whereField("uid", isEqualTo: self.user?.uid).getDocuments() { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else {
                                    if(querySnapshot!.documents.count > 0) {
                                        let fpontos = querySnapshot!.documents[0].data()["pontos"] as! Int
                                        self.db.collection("utilizador").document(querySnapshot!.documents[0].documentID).updateData([
                                            "pontos": fpontos + 5
                                            ])
                                    }
                                }
                                
                            }
                        }else {
                            
                            vencedor = "You lose for: " + self.opponent
                            
                            self.db.collection("utilizador").whereField("uid", isEqualTo: self.user?.uid).getDocuments() { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else {
                                    if(querySnapshot!.documents.count > 0) {
                                        let fpontos = querySnapshot!.documents[0].data()["pontos"] as! Int
                                        self.db.collection("utilizador").document(querySnapshot!.documents[0].documentID).updateData([
                                            "pontos": fpontos - 5
                                            ])
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    
                    
                    
                    self.winner.text = vencedor
                    self.r1.isHidden = true;
                    self.r2.isHidden = true;
                    self.r3.isHidden = true;
                    self.r4.isHidden = true;
                    self.winner.isHidden = false
                    

                    self.pergunta.text = "Results: "
                    self.finalI.isHidden = false
                    self.finalu.isHidden = false
                    
                    
                }
                
                
                
                
                
                
                
            }
        }
        
        db.collection("embateReal").document(self.docID!).addSnapshotListener {
            documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("error")
                return
            }
            
            if(self.player == 1 ){
                self.pontos.text =  self.opponent + ": " + String(document.data()!["p2"] as! Int)
            } else {
                self.pontos.text =  self.opponent + ": " + String(document.data()!["p1"] as! Int)
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
        
        self.r1.setTitleColor(UIColor.black, for: .normal)
        self.r2.setTitleColor(UIColor.black, for: .normal)
        self.r3.setTitleColor(UIColor.black, for: .normal)
        self.r4.setTitleColor(UIColor.black, for: .normal)
        
        self.r1.isEnabled = false;
        self.r2.isEnabled = false;
        self.r3.isEnabled = false;
        self.r4.isEnabled = false;
    }
    
    func updatePontos() {
        
        self.teuspontos.text = "Tu: " + String(self.mypontos);
        
        if(player == 1){
            self.db.collection("embateReal").document(self.docID!).updateData([
                "p1": self.mypontos
                ])
        } else {
            self.db.collection("embateReal").document(self.docID!).updateData([
                "p2": self.mypontos
                ])
        }
        
        
    }
    
    @IBAction func r1(_ sender: Any) {
        blockBTNS()
        
        if(self.opcao == 1) {
            self.r1.backgroundColor = UIColor.green
            mypontos = mypontos + 5
            updatePontos()
            
        } else {
            self.r1.backgroundColor = UIColor.red
        }
        
       
    }
    
    @IBAction func r2(_ sender: Any) {
        
        
        blockBTNS()
        
        if(self.opcao == 2) {
            self.r2.backgroundColor = UIColor.green
            mypontos = mypontos + 5
            updatePontos()
        } else {
            self.r2.backgroundColor = UIColor.red
        }
        updatePontos()
    }
    
    @IBAction func r3(_ sender: Any) {
        
        blockBTNS()
        
        if(self.opcao == 3) {
            self.r3.backgroundColor = UIColor.green
            mypontos = mypontos + 5
            updatePontos()
        } else {
            self.r3.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func r4(_ sender: Any) {
        
        
        blockBTNS()
        
        if(self.opcao == 4) {
            self.r4.backgroundColor = UIColor.green
            mypontos = mypontos + 5
            updatePontos()
        } else {
            self.r4.backgroundColor = UIColor.red
        }
        
        
    }
}

    
