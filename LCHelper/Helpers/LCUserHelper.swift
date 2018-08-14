//
//  FSUserHelper.swift
//  FSHelper
//
//  Created by Hassam Solano-Morel on 5/24/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation

public class LCUserHelper{
    private let helper:LCHelper
    public var currentUser:LCUser? = nil
    
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    init(HelperRoot root:LCHelper) {
        self.helper = root
    }
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    
    /*user()
     Purpose:
     Client access to Auth.currentUser
     WARNING:
     This method is included for convience purposes and should
     be seldom used!
     */
    public func fsUser () -> User? {
        return Auth.auth().currentUser
    }
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    public func breakDown(){
        currentUser = nil
    }
    
    internal func setUp(){
        let authUser:User? = helper.authHelper().AuthInstance()?.currentUser
        self.currentUser = LCUser(uid: (authUser?.uid)!)
    }
    
    /*userExists(completion)
     Purpose:
     Checks the Firestore DB for the current users record
     Notes:
     This method requires a completion block as all Firestore
     requests are async calls. Call this method as follows:
     
     /*Start Example*/
     userExists{(inDB:Bool) in
     if inDB {
     //Perform work if user already exists
     }else{
     //Perform work if user does NOT already exist
     }
     }
     /*End Example*/
     
     */
    internal func checkUserExists(ref:DocumentReference!,completion: @escaping (Bool)->()) {
        ref?.getDocument { (document, error) in
            var inDB:Bool = false
            
            if let document = document, document.exists {
                inDB = true
                //DEBUGGING
                print(LCDebug.debugMessage(fromWhatClass: "LCUserHelper",
                                           message: "User exsists"))
            } else {
                //DEBUGGING
                print(LCDebug.debugMessage(fromWhatClass: "LCUserHelper",
                                           message: "User does not exsist"))
            }
            completion(inDB)
        }
        
    }
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    
}
