//
//  FSHelper.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 5/21/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation
import Firebase

class FSHelper {
    
    private var currentUserUID:String = ""

    //Reference to the firestore roots
    private let root = Firestore.firestore()
    private var userRoot:DocumentReference? = nil
    private var projectsRoot:DocumentReference? = nil
    
    //Enforce singlton design
    static let shared:FSHelper = FSHelper()
    private var active:Bool = false //This will be used to ensure that the helper has been properly initilized
    
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    
    //Private initializer in accordance to the Singleton design pattern.
    private init(){
        setUp()
    }
    
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    //Start Client Accessible Methods//
    
    /*setUp()
     Purpose:
        1. Attach FSHelper to current user
        2. Create user Firestore DB if does NOT exists
     */
    func setUp(){
        if ( !ready() ){
            if(Auth.auth().currentUser != nil){
                currentUserUID = String((Auth.auth().currentUser?.uid)!)
                
                userRoot = root.document("USERS/\(currentUserUID)")
                projectsRoot = root.document("PROJECTS/\(currentUserUID)")
                
                active = true
                print("FSHelper: Set up for user \(currentUserUID).  READY")//DEBUGGING
                
                createUser()
            }else{
                print("FSHelper: Not yet set up. User NOT signed in:\n1. SignIn the user\n2. Call <FSHelperRef>.setup()")//DEBUGGING
            }
        }else{
            print("FSHelper: Already setup. Ready!")//DEBUGGING
            let _ = ready()//DEBUGGING
        }
    }
    
    /*breakDown()
     Purpose:
        Detach FSHelper from current user
     */
    func breakDown(){
        userRoot = nil
        projectsRoot = nil
        currentUserUID = ""
        
        active = false
        print("FSHelper: Broken down. NOT READY")//DEBUGGING
        let _ = ready()//DEBUGGING
    }
    
    //End Client Accessible Methods//
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    //Start Private Helper Methods//
   
    /*ready()
     Purpose:
        1. Checks is FSHelper is currectly setup
        to work with the currect user
        2. Prints debug info to the cosole
     Note:
        If FSHelper is not ready try this:
            1. Sign in the user (FirebaseAuth)
            2. call <FSHelperRef>.setUp()
     */
    private func ready() -> Bool{
        print("FSHelper: Ready? - \(active)")//DEBUGGING
        return active
    }
    
    /*createUser()
     Purpose:
        Creates a new user in the Firestore DB if
        the user does not alreay exsists
     */
    private func createUser(){
        if ready(){
            userExists { (inDB) in
                if ( !inDB ){
                    print("Creating User DB")
                    let currUser = Auth.auth().currentUser
                    let data = FSModels.NEW_USER(usr: currUser!)
                    
                    self.userRoot?.setData(data, completion: { (err) in
                        if (err != nil) {
                            print(err?.localizedDescription ?? "")//DEBUGGING
                        }
                    })
                }else{
                    print("FSHelper: User profile already in database.")
                }
            }
        }else{
            print("FSHelper: Could not create user. FSHelper not ready. Run <FSHelperRef>.setUp() and try again")
        }
    }
    
    /*userExists(completion)
     Purpose:
        Checks the Firestore DB for the current users record
     Notes:
        This method requires a completion block as all Firestore
        requests are async calls. Call this method as follows:
     
            userExists{(inDB:Bool) in
                if inDB {
                    //Perform work if user already exists
                }else{
                    //Perform work if user does NOT already exist
                }
            }
     */
    private func userExists(completion: @escaping (Bool)->()) {
        let docRef = root.document("USERS/\(currentUserUID)")
        
        docRef.getDocument { (document, error) in
            var inDB:Bool = false

            if let document = document, document.exists {
                inDB = true
                print("FSHelper: User exsists")//DEBUGGING
            } else {
                print("FSHelper: User does not exist")//DEBUGGING
            }
            completion(inDB)
        }
        
    }
    
    //End Private Helper Methods//
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
}
