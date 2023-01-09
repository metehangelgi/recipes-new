//
//  IngredientsViewController.swift
//  Recipes
//
//  Created by Metehan Gelgi on 20.12.2022.
//

import UIKit

class IngredientsViewController: UIViewController {

    
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var ingredientsCollectionView:UICollectionView!
    
    let dataSource = DataSource()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Ingredients at Home"
        self.navigationItem.titleView = UIView()
        dataSource.delegate = self
        dataSource.getListofIngredients()
        ingredientsCollectionView.allowsMultipleSelection = true
        
        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    

    
    // MARK: - Navigation
    @IBAction func continueAction(_ sender: Any) {
        if let indexPaths = ingredientsCollectionView.indexPathsForSelectedItems {
            if indexPaths.count > 0 && indexPaths.count < 3{
                errorLabel.alpha = 0
                var ingredientNames: [String] = []
                for indexPath in indexPaths{
                    if let ingredient = dataSource.getFilterIngredients(for:indexPath.row),
                    let strIngredient = ingredient.strIngredient{
                        ingredientNames.append(strIngredient)
                    }
                        
                }
                
                let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Foods") as? FoodsViewController
                screen!.ingredientIdentifiers = ingredientNames
                
                self.navigationController?.pushViewController(screen!, animated: true)
                
            } else {
                errorLabel.alpha = 1
            }

            
        }

                    
        
        
    }
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        /*
        if
            let cell = sender as? UICollectionViewCell,
            let indexPaths = ingredientsCollectionView.indexPathsForSelectedItems,
            let player = dataSource.getIngredientsFilter(for: [indexPath.row for indexPath in indexPaths]),
            let foodsController = segue.destination as? FoodsViewController {
            foodsController.categoryIdentifier = category.strCategory
        }
         */
         
        
    }
     */
    

}

extension IngredientsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //navigationController?.popViewController(animated: <#T##Bool#>)
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.getNumberofFilterIngredients()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientCollection", for: indexPath) as? IngredientsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let filterIngredient = dataSource.getFilterIngredients(for: indexPath.row) {
            
            cell.ingredientLabel.text = filterIngredient.strIngredient
        } else {
            cell.ingredientLabel.text = "N/A"
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader", for: indexPath)

             return headerView
         }

         return SearchReusableView()

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIn indexPath: IndexPath) {

        if ingredientsCollectionView.indexPathsForSelectedItems?.count != 0{
            self.continueButton.isEnabled = true
            self.errorLabel.alpha = 0
        } else {
            self.continueButton.isEnabled = false
            self.errorLabel.alpha = 1
        }

        collectionView.reloadData()
    }
}


extension IngredientsViewController: DataDelegate{
    func ingredientListLoaded(){
        self.ingredientsCollectionView.reloadData()
    }
}

extension IngredientsViewController: UISearchBarDelegate{
    //MARK: - SEARCH
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text{
            dataSource.updateFilterArray(searchText:searchText)
        }
    }
    
    /*
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.updateFilterArray(searchText:searchText)

    }*/
     
}
