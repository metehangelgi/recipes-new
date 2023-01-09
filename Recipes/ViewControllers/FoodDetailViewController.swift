//
//  FoodDetailViewController.swift
//  Recipes
//
//  Created by Metehan Gelgi on 20.12.2022.
//

import UIKit
import FirebaseAuth

class FoodDetailViewController: UIViewController {
    
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var foodRecipeText: UITextView!
    
    var foodIdentifier: String?
    let dataSource = DataSource()
    let userDataSource = UserDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Meal"
        dataSource.delegate = self
        userDataSource.delegate = self
        
        
        if let foodIdentifier = foodIdentifier {
            dataSource.getFoodDetail(with: foodIdentifier)
            userDataSource.checkUserfav(with: foodIdentifier)
        }
        
        if Auth.auth().currentUser != nil {
            favouriteButton.alpha = 1
        }   else { favouriteButton.alpha = 0 }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let foodIdentifier = foodIdentifier {
            userDataSource.checkUserfav(with: foodIdentifier)
        }
            
        
    }
    
    @IBAction func goCategories(_ sender: Any) {
        let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Foods") as? FoodsViewController


        if let categoryLabel:String = categoryButton.currentTitle {
            screen!.categoryIdentifier = categoryLabel
            self.navigationController?.pushViewController(screen!, animated: true)

        }
    }
    
    @IBAction func goAreas(_ sender: Any) {
        let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Foods") as? FoodsViewController


        if let areaLabel :String = areaButton.currentTitle {
            screen!.areaIdentifier = areaLabel
            self.navigationController?.pushViewController(screen!, animated: true)

        }
    }
    
    
    
    @IBAction func favMeal(_ sender: Any) {
        userDataSource.addFavMeal(with: foodIdentifier)
    }
    

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let categoryLabel:String = categoryButton.currentTitle,
           let foodsController = segue.destination as? FoodsViewController {
         foodsController.categoryIdentifier = categoryLabel
     }
    }
    

}

extension FoodDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.getNumberofFoodDetailIngredients()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell") as? FoodDetailTableViewCell else {
            return UITableViewCell()
        }
        
        if let ingredient = dataSource.getFoodDetailIngredients(for: indexPath.row) {
            
            cell.ingredientLabel.text = ingredient.strIngredient
            cell.measurementLabel.text = ingredient.strMeasurement
        } else {
            cell.ingredientLabel.text = "N/A"
            cell.measurementLabel.text = "N/A"
            
        }
        
        return cell
    }
}


extension FoodDetailViewController: DataDelegate{
    func foodDetailLoaded(food:Meals){
        self.ingredientsTableView.reloadData()
        foodNameLabel.text = food.strMeal
        areaButton.setTitle(food.strArea, for: .normal)
        categoryButton.setTitle(food.strCategory, for: .normal)
        foodRecipeText.text = food.strInstructions
        
        //foodImage.image = UIImage(data: foodImageData)
        if let strMealThumb = food.strMealThumb{
            let url = URL(string: strMealThumb)
            foodImage.kf.setImage(with: url,placeholder: UIImage(systemName: "questionmark.circle.fill"),
                                  options: [.loadDiskFileSynchronously,
                                            .cacheOriginalImage])
        }


    }
}

extension FoodDetailViewController:UserDataSourceDelegate{
    
    func favChecked(check:Bool) {
        if check{
            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
    }
    
    func favChanged(added: Bool) {
        if added{
            print("yesss")
            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            print("nooo")
            favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}

