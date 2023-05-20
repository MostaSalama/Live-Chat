//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    static let ID = String(describing: ChatViewController.self)
    let db = Firestore.firestore()
    
    var Messeges=[Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages(){
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
            self.Messeges = []
            if let e = error {
                print(e.localizedDescription)
            }else{
                if let snapShotDocuments = querySnapshot?.documents{
                    for doc in snapShotDocuments{
                        let data = doc.data()
                        if let sender = doc[K.FStore.senderField] as? String , let messageBody = doc[K.FStore.bodyField] as?String {
                            let newMessage = Message(sender: sender, body: messageBody)
                            self.Messeges.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield?.text , let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField:messageSender,
                                                                      K.FStore.bodyField:messageBody,
                                                                      K.FStore.dateField:Date().timeIntervalSince1970]) { error in
                if let e = error {
                    let alert = UIAlertController(title: "can not send your message !", message: "\(e.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK!", style: UIAlertAction.Style.destructive,handler: nil))
                    self.present(alert,animated: true,completion: nil)
                    print(e)
                } else {
                    print("Success!")
                    self.messageTextfield.text = .none
                    
                }
            }
        }
        
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
    do {
      try Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
        let alert = UIAlertController(title: "Can not sign out!", message: "\(signOutError)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
      print("Error signing out: %@", signOutError)
    }
      
    }
    
    
}

