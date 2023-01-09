//
//  userDelegate.swift
//  Recipes
//
//  Created by Metehan Gelgi on 2.01.2023.
//

import Foundation

protocol UserAuthenticationDelegate{
    // func userDetailLoaded()
    func emailChecked(checkText:String)
    func login(resultText:String)
    func register(resultText:String)
    func displayMessage(message:String)

}

extension UserAuthenticationDelegate{
    func emailChecked(checkText:String) {}
    func login(resultText:String) {}
    func displayMessage(message:String) {}
    func register(resultText:String){}
}
