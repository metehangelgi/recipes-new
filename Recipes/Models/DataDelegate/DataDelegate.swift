//
//  DataDelegate.swift
//  Recipes
//
//  Created by Metehan Gelgi on 20.12.2022.
//

import Foundation

protocol DataDelegate {
    func foodListLoaded()
    func ingredientListLoaded()
    func imageListLoaded()
    func categoryListLoaded()
    func foodDetailLoaded(food:Meals)
    
}

extension DataDelegate {
    func foodListLoaded() {}
    func ingredientListLoaded() {}
    func imageListLoaded() {}
    func categoryListLoaded() {}
    func foodDetailLoaded(food:Meals) {}
}

