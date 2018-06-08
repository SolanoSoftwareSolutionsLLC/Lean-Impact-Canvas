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
    
    internal var root:DocumentReference? = nil
    internal var currentUserUID:String = ""

    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    init(HelperRoot root:LCHelper) {
        self.helper = root
    }
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    /*userProjects()
     Purpose:
        Client access to a dictionary of the current user's projects. Actual
        processing is handled by LCProjectHelper. 
     Return:
        [PROJECT_NAME:FIRESTORE/PATH/TO/PROJECT]
     */
    public func userProjects(completion:@escaping (_ dataDict : [String:String])->()){
        let data = helper.projectHelper().getProjects(forUser: currentUserUID)
        completion(data)
    }
    /*user()
     Purpose:
        Client access to Auth.currentUser
     WARNING:
        This method is included for convience purposes and should
        be seldom used!
     */
    public func user() -> User?{
        return helper.services().auth()?.currentUser
    }
    
    /*user()
     Purpose:
        Client access to the current user's UID
     */
    public func userID() -> String{
        return currentUserUID
    }
    
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    /*createUser()
     Purpose:
        Creates a new user in the Firestore DB if
        the user does not alreay exsists
     */
    internal func createUser(){
        if helper.ready(){
            userExists { (inDB) in
                if ( !inDB ){
                    
                    print(LCDebug.debugMessage(fromWhatClass: "LCUserHelper",
                                               message: "Creating User DB"))
                    
                    let currUser = self.helper.services().auth()?.currentUser
                    let data = LCModels.NEW_USER(usr: currUser!)
                    
                    self.root?.setData(data, completion: { (err) in
                        if (err != nil) {
                            print(LCDebug.debugMessage(fromWhatClass: "LCUserHelper",
                                                       message: "@createUser() \(err?.localizedDescription ?? "")"))
                        }
                    })
                }else{
                    print(LCDebug.debugMessage(fromWhatClass: "LCUserHelper",
                                               message: "User profile already in database."))
                }
            }
        }else{
            print(LCDebug.debugMessage(fromWhatClass: "LCUserHelper",
                                       message: "Could not create user. FSHelper not ready. Run <FSHelperRef>.setUp() and try again"))
        }
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
    private func userExists(completion: @escaping (Bool)->()) {
        let docRef = helper.services().firestore()?
            .document("USERS/\(currentUserUID)")
        
        docRef?.getDocument { (document, error) in
            var inDB:Bool = false
            
            if let document = document, document.exists {
                inDB = true
//                //DEBUGGING
//                print(LCDebug.debugMessage(fromWhatClass: "LCUserHelper",
//                                           message: "User exsists"))
            } else {
//                //DEBUGGING
//                print(LCDebug.debugMessage(fromWhatClass: "LCUserHelper",
//                                           message: "User does not exsist"))
            }
            completion(inDB)
        }
        
    }
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    
}
