//
//  UserDataSourceDelegate.swift
//  391TeamProject
//
//  Created by Lab on 30.11.2021.
//

import Foundation

//Intiliazs delegate
protocol UserDataSourceDelegate{
    // func userDetailLoaded()
    func currentUserDetailLoaded(user:User)
    func favChecked(check:Bool)
    func favChanged(added:Bool)
}

extension UserDataSourceDelegate{
    func currentUserDetailLoaded(user:User) {}
    func favChecked(check:Bool) {}
    func favChanged(added:Bool) {}
    
}
