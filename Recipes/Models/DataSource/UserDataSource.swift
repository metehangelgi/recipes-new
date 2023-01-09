//
//  UserDataSource.swift
//  391TeamProject
//
//  Created by Lab on 30.11.2021.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth


class UserDataSource{
    
    let dataBase = Firestore.firestore()
    private var userArray: [User] = []
    var delegate: UserDataSourceDelegate?
    
    private var user:User? = nil
    
    func getCurrentUserData(){
         //Get specific document from current user
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        
         let docRef = Firestore.firestore()
            .collection("user")
            .whereField("uid", isEqualTo: userID)

         // Get data
        docRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            } else if querySnapshot!.documents.count != 1 {
                print("More than one document or none")
            } else {
                let document = querySnapshot!.documents.first
                let dataDescription = document?.data()
                self.user = User(firstName: dataDescription?["firstName"] as? String ?? "",
                                 lastName: dataDescription?["lastName"] as? String ?? "",
                                 email: dataDescription?["email"] as? String ?? "",
                                 uid: dataDescription?["uid"] as? String ?? "",
                                 fav: dataDescription?["fav"] as? [String] ?? [])
                
                DispatchQueue.main.async {
                    if let user = self.user {
                        self.delegate?.currentUserDetailLoaded(user:user)
                        
                    }
                    
                }
            }
            
            
            

             
            
            
        }
        
    }
    
    func addFavMeal(with foodIdentifier:String?){
        if let user = user {
            print(user.fav)
        }
        if let foodIdentifier = foodIdentifier,
        let contains = user?.fav.contains(foodIdentifier){
            if contains{
                user?.fav.removeAll(where: { $0 == foodIdentifier })
            } else {
                user?.fav.append(foodIdentifier)
            }
            
            if let user = user{
                Firestore.firestore().collection("user").document(user.uid).setData(["email":user.email,
                                                                                       "firstName":user.firstName,
                                                                                       "lastName":user.lastName,
                                                                                       "uid":user.uid,
                                                                                         "fav":user.fav])
                
                /*
                do {
                    try Firestore.firestore().collection("user").document(user.uid).setData(["email":user.email,
                                                                                           "firstName":user.firstName,
                                                                                           "lastName":user.lastName,
                                                                                           "uid":user.uid,
                                                                                             "fav":user.fav])
                }
                catch {
                  print(error)
                }
                 */
            }
            self.delegate?.favChanged(added: !contains)
        }
        
        

    }
    
    
    func checkUserfav(with foodIdentifier: String) {
        getCurrentUserData()
        if let contains = user?.fav.contains(foodIdentifier){
            self.delegate?.favChecked(check:contains)
        }
            
    }
    
    
}


