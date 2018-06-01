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
    
    @IBOutlet weak var listaCadeiras: UITableView!
    var nomeCadeira: String = ""	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(nomeCadeira)
        
       
        
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        db.collection("tarefas").whereField("cadeira", isEqualTo: nomeCadeira).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let name = document.data()["nome"] as? String {
                        self.array.append(name)
                        self.arrayB.append(false)
                    }
                }
                self.listaCadeiras.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrayB[indexPath.row]{
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
            arrayB[indexPath.row] = false
        }else{
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
            arrayB[indexPath.row] = true
        }
        
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
         let alert = UIAlertController(title: "Informaçao", message: array[indexPath.row], preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
        
       
        
        print(indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "zz")
        cell.textLabel?.text = array[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.detailButton
        return cell
    }
}
