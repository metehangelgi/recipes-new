//
//  CategoriesViewController.swift
//  Recipes
//
//  Created by Metehan Gelgi on 20.12.2022.
//

import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet weak var categoriesTableView: UITableView!
    private let dataSource = DataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Categories"
        dataSource.delegate = self
        dataSource.getListofCategories()
        
    }
    
    
    

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? CategoriesTableViewCell,
           let indexPath = categoriesTableView.indexPath(for: cell),
           let category = dataSource.getCategories(for: indexPath.row),
           let foodsController = segue.destination as? FoodsViewController {
            foodsController.categoryIdentifier = category.strCategory
        }
    }
    

}


extension CategoriesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.getNumberofCategories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoriesTableViewCell else {
            return UITableViewCell()
        }
        
        if let category = dataSource.getCategories(for: indexPath.row) {
            
            cell.categoryNameLabel.text = category.strCategory
        } else {
            cell.categoryNameLabel.text = "N/A"
            
        }
        
        return cell
    }
}



extension CategoriesViewController: DataDelegate{
    func categoryListLoaded(){
        self.categoriesTableView.reloadData()
    }
}
