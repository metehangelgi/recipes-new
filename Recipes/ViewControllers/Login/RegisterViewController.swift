//
//  RegisterViewController.swift
//  Recipes
//
//  Created by Metehan Gelgi on 21.12.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    let userAuthenticaionHelper = UserAuthenticationHelper()
    
    // private let database=Database.database().reference()
    // let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Sign up"
        userAuthenticaionHelper.userDelegate = self
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signUp(_ sender: Any) {
        if let email = email.text,let password = password.text, let firstname = firstname.text, let lastname=lastname.text,
           !email.isEmpty,!password.isEmpty,!firstname.isEmpty,!lastname.isEmpty{
            
            let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
            let firstname = firstname.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastname.trimmingCharacters(in: .whitespacesAndNewlines)
            
            userAuthenticaionHelper.signUp(email:email, password:password, firstname:firstname, lastname:lastname)
            
        } else {
            self.errorLabel.text = "Email or Password is empty!"
            self.errorLabel.alpha = 1
        }
            
        
    }
    
    func disaplayErrorMessage(_ theMessage:String) //error label function
    {
        let alert = UIAlertController(title: "Alert", message: theMessage, preferredStyle: UIAlertController.Style.alert);
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            action in
        }
        alert.addAction(okButton);
        self.present(alert, animated: true, completion: nil)
    }
    
    

}

extension RegisterViewController: UserAuthenticationDelegate {
    func displayMessage(message:String) {
        self.disaplayErrorMessage(message)
    }
    
    func register(resultText:String){
        self.errorLabel.text = resultText
        self.errorLabel.backgroundColor = UIColor.systemGreen
        self.errorLabel.alpha = 1
        
        navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.selectedIndex = 0
        
        //let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainScreen") as? HomeViewController
        //self.navigationController?.pushViewController(screen!, animated: true)

    }
}
