//
//  recompensas.swift
//  Fire
//
//  Created by DocAdmin on 6/15/18.
//  Copyright © 2018 Lima. All rights reserved.
//

import UIKit
import Firebase


class recompensas: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var db: Firestore!
    var listaRecompensas = [CRecompensas]()
    var idc = 0
    
    @IBOutlet weak var tableRecompensas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        db.collection("recompensas").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {

                    var recompensas = CRecompensas()
                    
                    if let name = document.data()["nome"] as? String {
                        recompensas.nome = name
                        
                    }
                    
                    if let desc = document.data()["pontos"] as? Int {
                        recompensas.pontos = desc
                    }
                    
                    self.listaRecompensas.append(recompensas)
                }
                
                self.tableRecompensas.reloadData()
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(listaRecompensas[indexPath.row])
        self.idc = indexPath.row
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaRecompensas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "zz")
        cell.textLabel?.text = listaRecompensas[indexPath.row].nome
        cell.detailTextLabel?.text = String(describing: listaRecompensas[indexPath.row].pontos)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
}
