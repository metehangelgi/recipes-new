//
//  ProfileViewController.swift
//  Recipes
//
//  Created by Metehan Gelgi on 20.12.2022.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {


    @IBOutlet weak var foodsTableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    let dataSource = DataSource()
    let userDataSource = UserDataSource()
    // private let db=Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Profile"
        self.navigationItem.titleView = UIView()
        dataSource.delegate = self
        userDataSource.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser != nil {
            userDataSource.getCurrentUserData()
            self.lockButton.isHidden = true
            self.loginButton.isHidden = true
            self.registerButton.isHidden = true
            self.logoutButton.isHidden = false
            self.foodsTableView.isHidden = false
            self.usernameLabel.isHidden = false
        } else {
            self.lockButton.isHidden = false
            self.loginButton.isHidden = false
            self.registerButton.isHidden = false
            self.logoutButton.isHidden = true
            self.foodsTableView.isHidden = true
            self.usernameLabel.isHidden = true

        }
        
    }
    
    
    @IBAction func logoutAction(_ sender: Any) {
        
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        
        //self.viewWillAppear(true)
        self.tabBarController?.selectedIndex = 0

    }
    
    
    @IBAction func goLogin(_ sender: Any) {
        let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Login") as? LoginViewController
        self.navigationController?.pushViewController(screen!, animated: true)
        //self.navigationController?.popToRootViewController(animated: true)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let cell = sender as? FoodsTableViewCell,
           let indexPath = foodsTableView.indexPath(for: cell),
           let food = dataSource.getFoods(for: indexPath.row),
           let foodDetailController = segue.destination as? FoodDetailViewController {
            foodDetailController.foodIdentifier = food.idMeal
        }
    }
    

}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.getNumberofFoods()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as? FoodsTableViewCell else {
            return UITableViewCell()
        }
        
        
        let result = dataSource.getFoods(for: indexPath.row)
        
        if let food=result, let strMealThumb=food.strMealThumb{
            cell.foodNameField.text = food.strMeal
            cell.loadImage(strMealThumb: strMealThumb)

        } else {
            cell.foodNameField.text = "N/A"
            cell.foodImage.image = UIImage(systemName: "questionmark.circle.fill")
        }
         
        
        return cell
    }
}



extension ProfileViewController:DataDelegate{
    func foodListLoaded(){
        self.foodsTableView.reloadData()
    }
}

extension ProfileViewController:UserDataSourceDelegate{
    func currentUserDetailLoaded(user:User) {
        self.usernameLabel.text = "\(user.firstName) \(user.lastName)"
        dataSource.getFavFoods(idMeals: user.fav)
    }
    
}
