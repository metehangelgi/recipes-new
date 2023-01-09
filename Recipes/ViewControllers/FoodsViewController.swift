//
//  FoodsViewController.swift
//  Recipes
//
//  Created by Metehan Gelgi on 20.12.2022.
//

import UIKit

class FoodsViewController: UIViewController {
    
    
    @IBOutlet weak var foodsTableView: UITableView!
    
    var categoryIdentifier: String?
    var ingredientIdentifiers: [String]?
    var areaIdentifier: String?
    
    let dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Foods"
        dataSource.delegate = self
        if let categoryIdentifier = categoryIdentifier {
            self.title = "\(categoryIdentifier) Meals"
            dataSource.getFoods(with: categoryIdentifier)
        } else if let areaIdentifier = areaIdentifier{
            self.title = "\(areaIdentifier) Meals"
            dataSource.getFoodsArea(with: areaIdentifier)
        } else if let ingredientIdentifiers = ingredientIdentifiers{
            
            self.title = "\(ingredientIdentifiers.joined(separator: " and ")) Meals"
            dataSource.getFoodsbyIngredients(with: ingredientIdentifiers)
        }else {
            print("error")
        }
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

extension FoodsViewController: UITableViewDataSource {
    
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



extension FoodsViewController: DataDelegate{
    func foodListLoaded() {
        self.foodsTableView.reloadData()
    }
    
    func imageListLoaded() {
        self.foodsTableView.reloadData()
    }
    
}
