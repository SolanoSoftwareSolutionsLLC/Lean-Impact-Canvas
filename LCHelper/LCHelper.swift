//
//  FSHelper.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 5/21/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation

public class LCHelper {
    
    internal var currentUserUID:String = ""

    //Reference to the firestore roots
    internal var FSRoot:Firestore? = nil
    internal var userRoot:DocumentReference? = nil
    internal var projectsRoot:DocumentReference? = nil
    
    //Enforce singlton design
    private static let SHARED:LCHelper? = LCHelper()
    private var SERVICE_HELPER:LCServiceHelper?
    private var AUTH_HELPER:LCAuthHelper?
    private var USER_HELPER:FSUserHelper?
    private var PROJECT_HELPER:FSProjectHelper?

    
    internal var active:Bool = false //This will be used to ensure that the helper has been properly initilized
    
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    
    //Private initializer in accordance to the Singleton design pattern.
    private init(){}
    
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    //Start Client Accessible Methods//
    
    public func serviceHelper() -> LCServiceHelper{
        if SERVICE_HELPER == nil{
            SERVICE_HELPER = LCServiceHelper(HelperRoot: LCHelper.shared())
        }
        return SERVICE_HELPER!
    }
    public func userHelper() -> FSUserHelper{
        if USER_HELPER == nil{
            USER_HELPER = FSUserHelper(HelperRoot: LCHelper.shared())
        }
        return USER_HELPER!
    }
    public func projectHelper() -> FSProjectHelper{
        if PROJECT_HELPER == nil{
            PROJECT_HELPER = FSProjectHelper(HelperRoot: LCHelper.shared())
        }
        return PROJECT_HELPER!
    }
    public func authHelper() -> LCAuthHelper{
        if AUTH_HELPER == nil{
            AUTH_HELPER = LCAuthHelper(HelperRoot: LCHelper.shared())
        }
        return AUTH_HELPER!
    }
    
    
    /*getS*/
    public static func shared() -> LCHelper{
        return SHARED!
    }
    
    /*Configure
    */
    public func configure(){
        //Init helper vars
        SERVICE_HELPER = serviceHelper()
        //Additional config
        if FirebaseApp.app() == nil{
            SERVICE_HELPER?.configure()
        }
        
        AUTH_HELPER = authHelper()
        USER_HELPER = userHelper()
        PROJECT_HELPER = projectHelper()
    }
    
    /*breakDown()
     Purpose:
        Detach FSHelper from current user
     */
    public func breakDown(){
        userRoot = nil
        projectsRoot = nil
        currentUserUID = ""
        
        active = false
        //DEBUGGING
        print(LCDebug.debugMessage(fromWhatClass: "LCHelper",
                                   message: "Helper broken down. Ready = \(active)"))
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
    internal func ready() -> Bool{
        //DEBUGGING
        print(LCDebug.debugMessage(fromWhatClass: "LCHelper",
                                   message: "Ready? - \(active)"))
        return active
    }
    
    /*createUser()
     Purpose:
        Creates a new user in the Firestore DB if
        the user does not alreay exsists
     */
    internal func createUser(){
        if ready(){
            userExists { (inDB) in
                if ( !inDB ){
                    print(LCDebug.debugMessage(fromWhatClass: "LCUserHelper",
                                               message: "Creating User DB"))
                    let currUser = Auth.auth().currentUser
                    let data = LCModels.NEW_USER(usr: currUser!)
                    
                    self.userRoot?.setData(data, completion: { (err) in
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
     
            userExists{(inDB:Bool) in
                if inDB {
                    //Perform work if user already exists
                }else{
                    //Perform work if user does NOT already exist
                }
            }
     */
    private func userExists(completion: @escaping (Bool)->()) {
        let docRef = FSRoot?.document("USERS/\(currentUserUID)")
        
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
    
    //End Private Helper Methods//
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
}
