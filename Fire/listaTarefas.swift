//
//  listaTarefas.swift
//  Fire
//
//  Created by DocAdmin on 6/1/18.
//  Copyright © 2018 Lima. All rights reserved.
//

import UIKit
import Firebase


class listaTarefas: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var db: Firestore!
    var array = [String]()
    var arrayB = [Bool]()
    var l_tarefas = [CTarefas]()
    let user = Auth.auth().currentUser
    var docId: String?
    var pontos: Int?
    @IBOutlet weak var listaCadeiras: UITableView!
    var nomeCadeira: String = ""	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("nomr " + nomeCadeira)
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alert = UIAlertController(title: "Informaçao", message: l_tarefas[indexPath.row].desc, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.default, handler: nil))
        
        if(self.l_tarefas[indexPath.row].show)! {
            alert.addAction(UIAlertAction(title: "Concluir", style: UIAlertActionStyle.default, handler: { action in
                
                self.db.collection("UtilizadorTarefa").addDocument(data: [
                    "uid": self.user?.uid,
                    "idT": self.l_tarefas[indexPath.row].idT,
                    "estado": true
                    ])
                self.l_tarefas[indexPath.row].show = false
                
                self.db.collection("utilizador").document(self.docId!).updateData([
                    "pontos": self.pontos! + self.l_tarefas[indexPath.row].pontos!
                    ])
                
                
                self.listaCadeiras.reloadData()
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print( l_tarefas.count)
        return l_tarefas.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.l_tarefas[indexPath.row].show = true
        self.db.collection("UtilizadorTarefa")
            .whereField("uid", isEqualTo: self.user?.uid)
            .whereField("idT", isEqualTo: l_tarefas[indexPath.row].idT).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        if(document.data()["estado"] as! Bool) {
                            cell.backgroundColor = UIColor.yellow
                            self.l_tarefas[indexPath.row].show = false
                        }
                    }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "zz")
        cell.textLabel?.text = l_tarefas[indexPath.row].nome
        cell.accessoryType = UITableViewCellAccessoryType.detailButton
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueAddTarefa") {
            let ltarefas = (segue.destination as! inserirTarefa)
            ltarefas.nomeCadeira = self.nomeCadeira
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.l_tarefas = [CTarefas]()
        self.listaCadeiras.reloadData()
        db.collection("tarefas").whereField("cadeira", isEqualTo: nomeCadeira)
            .whereField("global", isEqualTo: true).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        var tarefa = CTarefas()
                        tarefa.idT = document.documentID
                        
                        if let name = document.data()["nome"] as? String {
                            self.arrayB.append(false)
                            tarefa.nome = name
                        }
                        if let desc = document.data()["desc"] as? String {
                            tarefa.desc = desc
                        }
                        
                        if let pontos = document.data()["pontos"] as? Int {
                            tarefa.pontos = pontos
                        }
                        self.l_tarefas.append(tarefa)
                    }
                    self.listaCadeiras.reloadData()
                }
        }
        
        
        db.collection("tarefas").whereField("cadeira", isEqualTo: nomeCadeira)
            .whereField("global", isEqualTo: false)
            .whereField("uid", isEqualTo: user?.uid).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        var tarefa = CTarefas()
                        tarefa.idT = document.documentID
                        
                        if let name = document.data()["nome"] as? String {
                            self.arrayB.append(false)
                            tarefa.nome = name
                        }
                        if let desc = document.data()["desc"] as? String {
                            tarefa.desc = desc
                        }
                        
                        if let pontos = document.data()["pontos"] as? Int {
                            tarefa.pontos = pontos
                        }
                        self.l_tarefas.append(tarefa)
                    }
                    self.listaCadeiras.reloadData()
                }
        }
        
        
        self.db.collection("utilizador").whereField("uid", isEqualTo: user?.uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.docId = document.documentID
                    self.pontos = document.data()["pontos"] as! Int
                }
            }
        }
    }
}
