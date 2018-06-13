//
//  listaController.swift
//  Fire
//
//  Created by DocAdmin on 5/19/18.
//  Copyright © 2018 Lima. All rights reserved.
//

import UIKit
import Firebase


class listaController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableCadeiras: UITableView!
    
    var db: Firestore!
    var listaCadeiras = [CCadeiras]()
    var idc = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("adasdsadsadsa----")
        
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        db.collection("cadeiras").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
              
                for document in querySnapshot!.documents {
                    /*let x = String(describing: document.data()["desc"])
                    self.array.append(x)*/
                    
                    var cadeira = CCadeiras()
                    
                    if let name = document.data()["nome"] as? String {
                        cadeira.nome = name
                        
                    }
                    
                    if let desc = document.data()["desc"] as? String {
                        cadeira.desc = desc
                    }
                    
                    self.listaCadeiras.append(cadeira)
                }
                
                self.tableCadeiras.reloadData()
            }
        }
        
        
       /*
         db.collection("cadeiras").whereField("curso", isEqualTo: "EI")
         .addSnapshotListener { querySnapshot, error in
         guard let snapshot = querySnapshot else {
         print("Error fetching snapshots: \(error!)")
         return
         }
         self.array = [String]()
         self.array2 = [String]()
         
         snapshot.documentChanges.forEach { diff in
         
         if let name = diff.document.data()["nome"] as? String {
         self.array.append(name)
         }
         
         if let desc = diff.document.data()["desc"] as? String {
         self.array2.append(desc)
         }
         
         }
         
         self.tableCadeiras.reloadData()
         }

         */
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(listaCadeiras[indexPath.row])
        self.idc = indexPath.row
        self.performSegue(withIdentifier: "segueCadeiras", sender: tableView)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueCadeiras") {
            let ltarefas = (segue.destination as! listaTarefas)
            ltarefas.nomeCadeira = (listaCadeiras[self.idc].nome)!
        }
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaCadeiras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "zz")
        cell.textLabel?.text = listaCadeiras[indexPath.row].nome
        cell.detailTextLabel?.text = listaCadeiras[indexPath.row].desc
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
}
