//
//  MainViewController.swift
//  Recipes
//
//  Created by Metehan Gelgi on 20.12.2022.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var randomFoodImage: UIImageView!
    @IBOutlet weak var randomFoodButton: UIButton!
    
    private var dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Home"
        self.navigationItem.titleView = UIView()
        navigationItem.hidesBackButton = true
        dataSource.delegate = self
        dataSource.randomFoodDetail()
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let foodDetailController = segue.destination as? FoodDetailViewController {
            foodDetailController.foodIdentifier = dataSource.getRandomFoodID()
        }
    }
    
    

}

extension HomeViewController: DataDelegate {
    func foodDetailLoaded(food:Meals){
        randomFoodButton.setTitle(food.strMeal, for: .normal)
        //randomFoodImage.image = UIImage(data: foodImageData)
        if let strMealThumb = food.strMealThumb{
            let url = URL(string: strMealThumb)
            randomFoodImage.kf.setImage(with: url,placeholder: UIImage(systemName: "questionmark.circle.fill"),
                                  options: [.loadDiskFileSynchronously,
                                            .cacheOriginalImage])
        }
    }
}
