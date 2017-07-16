//
//  LoginViewController.swift
//  ParseProject
//
//  Created by John Zoldos on 7/10/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let friend = PFObject(className: "Contact")
        friend["firstName"] = "Jack"
        friend["lastName"] = "Zoldos"
        friend.saveInBackground { (success: Bool, error: Error?) in
            if success {
                print("Yay")
            } else {
                print(error?.localizedDescription)
                print("Boo")
            }
        }*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    @IBAction func onSignIn(_ sender: UIButton) {
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
            
            if user != nil {
                print("You're logged in.")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print(error?.localizedDescription) 
            }
            
        }
    }
    
    @IBAction func onSignUp(_ sender: UIButton) {
        let newUser = PFUser()
        newUser.username = usernameField.text!
        newUser.password = passwordField.text!
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if(success) {
                print("Success!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
                if((error! as NSError).code == 202) {
                    print("Username is already taken")
                }
            }
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
