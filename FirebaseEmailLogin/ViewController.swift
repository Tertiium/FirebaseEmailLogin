//
//  ViewController.swift
//  FirebaseEmailLogin
//
//  Created by user on 02/03/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var senhaTextField: UITextField!
    
    
    // MARK: - Properties
    
    // MARK: - Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    
    @IBAction func resetarSenha(_ sender: UIButton) {
        if let email = self.emailTextField.text{
            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
                print("==Erro ao mandar email de PasswordReset: \(error)")
            })
        }
    }
    @IBAction func createAccount(_ sender: UIButton) {
        if let email = self.emailTextField.text, let senha = self.senhaTextField.text{
            
            FIRAuth.auth()?.createUser(withEmail: email, password: senha, completion: { (user, error) in
                
                if error != nil{
                    print("==Erro ao criar a conta: \(error!)")
                    self.login()
                }else{
                    print("User Created!!")
                    self.login()
                }
                
            })
            
        }
    }
    
    // MARK: - Function
    
    func login(){
        if let email = self.emailTextField.text, let senha = self.senhaTextField.text{

            FIRAuth.auth()?.signIn(withEmail: email, password: senha, completion: { (user, error) in
                if error != nil {
                    print("==Erro ao autenticar: \(error!)")
                }else{
                    
                    FIRAuth.auth()?.addStateDidChangeListener({ (FIRAuth, FIRUser) in
                        if let logginUser = FIRUser {
                            if logginUser.isEmailVerified == false{
                                logginUser.sendEmailVerification(completion: { (error) in
                                    print("Erro ao mandar Email: \(error)")
                                })
                                print("Email não verificado ainda!")
                            }else{
                                print("Email Verificado: \(logginUser.email ?? "")")
                                print("Login!!!")
                            }
                        }else{
                            print("No user is signed in.")
                        }
                    })
                }
            })
        
        }
    }

}

