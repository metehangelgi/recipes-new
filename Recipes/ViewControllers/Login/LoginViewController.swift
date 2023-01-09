//
//  LoginViewController.swift
//  Recipes
//
//  Created by Metehan Gelgi on 20.12.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let userDataSource = UserDataSource()
    let userAuthenticaionHelper = UserAuthenticationHelper()
    
    
    @IBOutlet weak var registerDirectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Sign in"
        userAuthenticaionHelper.userDelegate = self
        
        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)

    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func goRegister(_ sender: Any) {
        let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Register") as? RegisterViewController
        if let controllers = navigationController?.viewControllers.count {
            if controllers >= 3 {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.navigationController?.pushViewController(screen!, animated: true)
            }
        }
    }
    
    
    @IBAction func forgotPassword(_ sender: Any) {
        if let email = email.text{
            let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
            userAuthenticaionHelper.forgetPasswordHelper(email: email)
        }
        
    }
    
    @IBAction func signIn(_ sender: Any) {
        //Getting Email and Passweord
        if let email = email.text,let password = password.text, !email.isEmpty,!password.isEmpty{
            let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
            
            userAuthenticaionHelper.signIn(email: email, password: password)

        } else {
            self.errorLabel.text = "Email or Password is empty!"
            self.errorLabel.alpha = 1
            //self.navigationController?.popToRootViewController(animated: true)
            //self.dismiss(animated: true, completion: nil);
        }

    
    }
    
    
    
}

extension LoginViewController: UserAuthenticationDelegate {
    func emailChecked(checkText:String){
        if checkText == "success"{
            errorLabel.text = "Password Reset Email is sent"
            errorLabel.backgroundColor = UIColor.systemGreen
            registerDirectButton.backgroundColor = UIColor.clear
        } else {
            errorLabel.text = checkText
            errorLabel.backgroundColor = UIColor.systemRed
            registerDirectButton.backgroundColor = UIColor.systemGreen
        }
        errorLabel.alpha = 1
    }
    
    func login(resultText:String) {
        
        if resultText == "success"{
            errorLabel.text = "Welcome Again"
            errorLabel.backgroundColor = UIColor.systemGreen
            self.errorLabel.alpha = 1
            
            
            self.disaplayInfoMessage("Welcome Again to Recipes App")
            //self.navigationController?.popToRootViewController(animated: true)
            //self.tabBarController?.selectedIndex = 0
        } else {
            errorLabel.text = "Email or password is incorrect"
            errorLabel.backgroundColor = UIColor.systemRed
            self.errorLabel.alpha = 1
        }
        
    }
    
    func disaplayInfoMessage(_ theMessage:String) //error label function
    {
        let alert = UIAlertController(title: "Hello", message: theMessage, preferredStyle: UIAlertController.Style.alert);
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            action in
                self.navigationController?.popToRootViewController(animated: true)
            
            
        }
        alert.addAction(okButton);
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


