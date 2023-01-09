//
//  DataSource.swift
//  Recipes
//
//  Created by Metehan Gelgi on 20.12.2022.
//

import Foundation


class DataSource {
   
    private var categoryArray: [Meals] = []
    private var foodArray: [Meals] = []
    
    private var foodDetail:Meals?
    private var ingredientFilterArray:[Meals] = []
    private var ingredientArray:[Meals] = []
    private var favFoods:[Meals] = []
    
    private var foodDetailIngredientArray:[Ingredient] = []
    
    private var apiModel:ApiModel?
    
    private var currentRandomMeal: Meals? = nil
    
    private var imageDataArray:[Data] = []
    
    let userDataSource = UserDataSource()
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"
    var delegate: DataDelegate?
    
    init() {
    }
    
    func getListofCategories(){
        let session = URLSession.shared
        if let url = URL(string: "\(baseURL)/list.php?c=list") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = session.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    
                    self.apiModel = try! JSONDecoder().decode(ApiModel.self, from: data)
                    if let categoryArray = self.apiModel?.meals {
                        self.categoryArray = categoryArray
                    }
                    DispatchQueue.main.async {
                        self.delegate?.categoryListLoaded()
                    }
                }
            }
            dataTask.resume()
        }

    }
    
    func getListofIngredients(){
        let session = URLSession.shared
        if let url = URL(string: "\(baseURL)/list.php?i=list") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = session.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    
                    self.apiModel = try! JSONDecoder().decode(ApiModel.self, from: data)
                    if let ingredientFilterArray = self.apiModel?.meals {
                        self.ingredientFilterArray = ingredientFilterArray
                        self.ingredientArray = ingredientFilterArray
                    }
                    DispatchQueue.main.async {
                        self.delegate?.ingredientListLoaded()
                    }
                }
            }
            dataTask.resume()
        }

    }
    
    func getFoods(with areaIdentifier:String) {
        let session = URLSession.shared
        if let url = URL(string: "\(baseURL)/filter.php?c=\(areaIdentifier)") {
            let request = URLRequest(url: url)
            let dataTask = session.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    
                    self.apiModel = try! JSONDecoder().decode(ApiModel.self, from: data)
                    if let foodArray = self.apiModel?.meals {
                        self.foodArray = foodArray
                    }
                    DispatchQueue.main.async {
                        self.delegate?.foodListLoaded()
                    }
                }
            }
            dataTask.resume()
        }
        
    }
    
    func getFoodsArea(with categoryIdentifier:String) {
        let session = URLSession.shared
        if let url = URL(string: "\(baseURL)/filter.php?a=\(categoryIdentifier)") {
            let request = URLRequest(url: url)
            let dataTask = session.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    
                    self.apiModel = try! JSONDecoder().decode(ApiModel.self, from: data)
                    if let foodArray = self.apiModel?.meals {
                        self.foodArray = foodArray
                    }
                    DispatchQueue.main.async {
                        self.delegate?.foodListLoaded()
                    }
                }
            }
            dataTask.resume()
        }
        
    }
    
    
    func getFoodsbyIngredients(with ingredientIdentifiers:[String]){
        // TODO: Only first filter is applied due to API constraints, apply merging
        let session = URLSession.shared
        if let url = URL(string: "\(baseURL)/filter.php?i=\(ingredientIdentifiers[0])") { // TODO: inner join all 
            let request = URLRequest(url: url)
            let dataTask = session.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    
                    self.apiModel = try! JSONDecoder().decode(ApiModel.self, from: data)
                    if let foodArray = self.apiModel?.meals {
                        self.foodArray = foodArray
                        
                    }
                    DispatchQueue.main.async {
                        self.delegate?.foodListLoaded()
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    
    
    func getFavFoods(idMeals:[String?]) {
        let session = URLSession.shared
        for idMeal in idMeals{
            if let idMeal = idMeal,
               let url = URL(string: "\(baseURL)/lookup.php?i=\(idMeal)") {
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let dataTask = session.dataTask(with: request) { data, response, error in
                    
                    if let data = data {
                        
                        self.apiModel = try! JSONDecoder().decode(ApiModel.self, from: data)
                        if let foodDetail = self.apiModel?.meals[0]{
                            self.foodArray.append(foodDetail)
                        }

                    }
                    DispatchQueue.main.async {

                        self.delegate?.foodListLoaded()
                    }
                }
                dataTask.resume()
            }
        }



        
    }
    
    func randomFoodDetail(){
        let session = URLSession.shared
        if let url = URL(string: "\(baseURL)/random.php") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = session.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    
                    self.apiModel = try! JSONDecoder().decode(ApiModel.self, from: data)
                    if let foodDetail = self.apiModel?.meals[0]{
                        self.currentRandomMeal = foodDetail
                        DispatchQueue.main.async {
                            self.delegate?.foodDetailLoaded(food:foodDetail)
                        }
                    }

                }
            }
            dataTask.resume()
        }

    }
    
    
    
    func getFoodDetail(with foodIdentifier:String){
        let session = URLSession.shared
        if let url = URL(string: "\(baseURL)/lookup.php?i=\(foodIdentifier)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = session.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    
                    self.apiModel = try! JSONDecoder().decode(ApiModel.self, from: data)
                    if let foodDetail = self.apiModel?.meals[0]{
                        self.saveIngredientsList(food: foodDetail)
                        DispatchQueue.main.async {
                            self.delegate?.foodDetailLoaded(food:foodDetail)
                        }
                    }

                }
            }
            dataTask.resume()
        }

    }

    func getNumberofFoodDetailIngredients () -> Int{
        foodDetailIngredientArray.count
    }
    
    func getFoodDetailIngredients(for index: Int) -> Ingredient? {
        guard index < foodDetailIngredientArray.count else {
            return nil
        }
        
        return foodDetailIngredientArray[index]
    }
    
    func getMultiIngredientsNames(for indices: [Int]) -> [String?] {
        var returnIngredientArray:[String] = []
        for index in indices{
            guard index < foodDetailIngredientArray.count else {
                return returnIngredientArray
            }
            
            returnIngredientArray.append(foodDetailIngredientArray[index].strIngredient)
        }
        return returnIngredientArray
        
    }
    
    
    func getNumberofCategories () -> Int{
        categoryArray.count
    }
    
    func getCategories(for index: Int) -> Meals? {
        guard index < categoryArray.count else {
            return nil
        }
        
        return categoryArray[index]
    }
    
    func getNumberofFilterIngredients () -> Int{
        ingredientFilterArray.count
    }
    
    
    func getFilterIngredients(for index: Int) -> Meals? {
        guard index < ingredientFilterArray.count else {
            return nil
        }
        
        return ingredientFilterArray[index]
    }
    
    
    func updateFilterArray(searchText:String){
        
        if(!searchText.isEmpty){
            self.ingredientFilterArray = self.ingredientArray.filter { $0.strIngredient!.contains(searchText) }
        } else {
            self.ingredientFilterArray = self.ingredientArray
        }
        
        self.delegate?.ingredientListLoaded()
        
    }
    
    
    func getNumberofFoods () -> Int{
        foodArray.count
    }
    
    func getRandomFoodID() -> String{
        if let currentRandomMeal = currentRandomMeal,
           let idMeal = currentRandomMeal.idMeal{
            return idMeal
        }
        return ""
        
    }
    
    
    func getFoods(for index: Int) -> Meals?{
        guard index < foodArray.count else {
            return nil
        }
        
        return (foodArray[index])
    }
    

    
    func saveIngredientsList(food: Meals){
        
        let ingredientList:[(String?,String?)] = [(food.strIngredient1,food.strMeasure1),(food.strIngredient2,food.strMeasure2),
                                                  (food.strIngredient3,food.strMeasure3),(food.strIngredient4,food.strMeasure4),
                                                  (food.strIngredient5,food.strMeasure5),(food.strIngredient6,food.strMeasure6),
                                                  (food.strIngredient7,food.strMeasure7),(food.strIngredient8,food.strMeasure8),
                                                  (food.strIngredient9,food.strMeasure9),(food.strIngredient10,food.strMeasure10),
                                                  (food.strIngredient11,food.strMeasure11),(food.strIngredient12,food.strMeasure12),
                                                  (food.strIngredient13,food.strMeasure13),(food.strIngredient14,food.strMeasure14),
                                                  (food.strIngredient15,food.strMeasure15),(food.strIngredient16,food.strMeasure16),
                                                  (food.strIngredient17,food.strMeasure17),(food.strIngredient18,food.strMeasure18),
                                                  (food.strIngredient19,food.strMeasure19),(food.strIngredient20,food.strMeasure20)]
        
        for ingredient in ingredientList{
            if let strIng = ingredient.0,
               let strMes = ingredient.1{
                if strIng==""{
                    break
                }
                self.foodDetailIngredientArray.append(Ingredient(strIngredient: strIng, strMeasurement: strMes))
            }
        }
        
    }
    
    
     
                

    
    
}
