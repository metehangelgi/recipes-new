//
//  ApiModel.swift
//  Recipes
//
//  Created by Metehan Gelgi on 20.12.2022.
//

import Foundation


struct ApiModel:Decodable{
    let meals: [Meals]
}
