//
//  listaController.swift
//  Fire
//
//  Created by DocAdmin on 5/19/18.
//  Copyright © 2018 Lima. All rights reserved.
//

import UIKit
import Firebase


class listaController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var tableCadeiras: UITableView!
    
    var db: Firestore!
    var array = [String]()
    var array2 = [String]()
    
    
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
                    
                    if let name = document.data()["nome"] as? String {
                        self.array.append(name)
                    }
                    
                    if let desc = document.data()["desc"] as? String {
                        self.array2.append(desc)
                    }
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
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "zz")
        cell.textLabel?.text = array[indexPath.row]
        cell.detailTextLabel?.text = array2[indexPath.row]
        return cell
    }
}
