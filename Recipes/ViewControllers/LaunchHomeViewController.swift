//
//  ViewController.swift
//  Recipes
//
//  Created by Metehan Gelgi on 18.12.2022.
//

import UIKit
import FirebaseAuth

class LaunchHomeViewController: UIViewController {

    @IBOutlet weak var plate: UIImageView!
    @IBOutlet weak var fork: UIImageView!
    @IBOutlet weak var spoon: UIImageView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var guestButton: UIButton!
    @IBOutlet weak var welcomeButton: UIButton!
    
    // private var isUserLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Recipes"
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut){
            self.objectsShowing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.registerButton.alpha = 0
            self.loginButton.alpha = 0
            self.guestButton.alpha = 0
            self.welcomeButton.alpha = 1
        } else {
            self.registerButton.alpha = 1
            self.loginButton.alpha = 1
            self.guestButton.alpha = 1
            self.welcomeButton.alpha = 0
        }

    }
    
    
    @IBAction func WelcomeBackAction(_ sender: Any) {
        
        //let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabController") as! UITabBarController
        //self.navigationController?.setViewControllers([vc], animated: false)
        //self.present(vc, animated: true)
        let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabController") as? UITabBarController
        self.navigationController?.pushViewController(screen!, animated: true)
        self.navigationController?.setViewControllers([screen!], animated: false)
        
    }
    
    
    @IBAction func GuestButtonAction(_ sender: Any) {
        
        //let storyboard = UIStoryboard(name: "TabController", bundle: Bundle.main)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabController") as! UITabBarController
        self.present(vc, animated: true)
        //let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabController") as? UITabBarController
        //self.navigationController?.pushViewController(screen!, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func objectsShowing(){
        spoon.alpha = 1
        fork.alpha = 1
        plate.alpha = 1
    }


}

