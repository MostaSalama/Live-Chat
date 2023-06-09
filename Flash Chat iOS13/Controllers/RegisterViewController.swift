//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        
        if let email = emailTextfield.text , let password = passwordTextfield.text{
            Auth.auth().createUser(withEmail: email, password: password) {authResult,error in
                if let e = error  {
                    let alert = UIAlertController(title: "Can not register!", message: "\(e.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertAction.Style.destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    self.navigate(ChatViewController.ID)
                }
            }
        }
        
        
    }
    
}
