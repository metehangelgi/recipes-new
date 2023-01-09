//
//  UserHelper.swift
//  Recipes
//
//  Created by Metehan Gelgi on 2.01.2023.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore


class UserAuthenticationHelper {
    
    let userDataSource = UserDataSource()
    var userDelegate : UserAuthenticationDelegate?
    
    
    func forgetPasswordHelper(email:String) {
        
        if !email.isEmpty{
            sendEmail(email: email)
        } else {
            let errorLabelText = "Email is empty!"
            self.userDelegate?.emailChecked(checkText: errorLabelText)
        }
        
    }
    
    func sendEmail(email:String){
        let docRef = Firestore.firestore()
            .collection("user")
            .whereField("email", isEqualTo: email)
        
        docRef.getDocuments { (querySnapshot, err) in
            if err != nil || querySnapshot!.documents.count != 1{
                let errorLabelText = "User is not Exist"
                self.userDelegate?.emailChecked(checkText: errorLabelText)
            } else {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if error != nil {
                        let errorLabelText =  "Password Reset Email cannot be sent"
                        self.userDelegate?.emailChecked(checkText: errorLabelText)
                    } else {
                        // errorLabelText = "Password Reset Email is sent"
                        let errorLabelText =  "success"
                        self.userDelegate?.emailChecked(checkText: errorLabelText)
                    }
                }
            }

        }
        
        
    }
    
    func signIn(email:String,password:String) {
        
        //Firebase sign function
        Auth.auth().signIn(withEmail: email, password: password) { (result, errorSignIn) in
            var result:String = ""
            //Check for error
            if errorSignIn != nil {
                if let resultText = errorSignIn?.localizedDescription {
                    result = resultText
                }
            } else {
                //result = "Welcome Again"
                result = "success"
                 }
            self.userDelegate?.login(resultText: result)
            }
    }
    
    func signUp (email:String,password:String,firstname:String,lastname:String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, errorLoginImformation) in
        
            if errorLoginImformation != nil {
                self.userDelegate?.displayMessage(message:"User couldn't be created, check your email and password requirements")
                //self.disaplayErrorMessage("User couldn't be created, check your password requirements")
            } else {
                let dataBase = Firestore.firestore()
                
                dataBase.collection("user").document(result!.user.uid ).setData(["firstName":firstname, "lastName":lastname, "email":email, "uid": result!.user.uid, "fav":[] ]) { (errorDataBase) in
                    if errorDataBase != nil {
                        self.userDelegate?.displayMessage(message:"Couldn't reach database")
                        //self.disaplayErrorMessage("Couldn't reach database")
                    } else { // Account created
                        self.userDelegate?.register(resultText: "Registration Successful")

                    }
                }
                
            }
        }

    }
     
    
    
    
    
}
