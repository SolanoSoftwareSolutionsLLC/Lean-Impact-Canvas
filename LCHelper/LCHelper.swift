//
//  LCHelper.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 5/21/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation

public class LCHelper {
        
    private static let SHARED:LCHelper = LCHelper()
    
    private var SERVICES_HELPER:LCServiceHelper?
    private var AUTH_HELPER:LCAuthHelper?
    private var USER_HELPER:LCUserHelper?
    private var PROJECT_HELPER:LCProjectHelper?

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
    
    public func services() -> LCServiceHelper{
        if SERVICES_HELPER == nil{
            SERVICES_HELPER = LCServiceHelper(HelperRoot: LCHelper.shared())
        }
        return SERVICES_HELPER!
    }
    public func userHelper() -> LCUserHelper{
        if USER_HELPER == nil{
            USER_HELPER = LCUserHelper(HelperRoot: LCHelper.shared())
        }
        return USER_HELPER!
    }
    public func projectHelper() -> LCProjectHelper{
        if PROJECT_HELPER == nil{
            PROJECT_HELPER = LCProjectHelper(HelperRoot: LCHelper.shared())
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
        return SHARED
    }
    
    /*Configure
    */
    public func configure(){
        //Init helper vars
        SERVICES_HELPER = services()
        //Additional config
        if services().app() == nil{
            SERVICES_HELPER?.configure()
        }
        
        AUTH_HELPER = authHelper()
        USER_HELPER = userHelper()
        PROJECT_HELPER = projectHelper()
        
        setup()
    }
    
    /*breakDown()
     Purpose:
        Detach FSHelper from current user
     */
    public func breakDown(){
        //Break down UserHelper
        userHelper().root = nil
        userHelper().currentUserUID = ""

        //Break down ProjectHelper
        projectHelper().root = nil
        
        //Break down LSHelper (self)
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
    
    /*setUp()
     Purpose:
     1. Attach LCHelper to current user
     2. Create user Firestore DB if does NOT exists
     */
    private func setup(){
        services().FSRoot = Firestore.firestore()
        
        if ( !ready() ){
            if(authHelper().isSignedIn()){
                let UID = String((services().auth()?.currentUser?.uid)!)

                //Set up UserHelper
                userHelper().currentUserUID = UID
                userHelper().root = services().FSRoot?.document("USERS/\(UID)")
                
                //Set up ProjectHelper
                projectHelper().root = services().FSRoot?.document("PROJECTS/\(UID)")
                
                //Set up LCHelper (self)
                active = true
                
                //This next setup line depends on (self).active == true
                userHelper().createUser()
                
                //DEBUGGING
                print(LCDebug.debugMessage(fromWhatClass: "LCHelper",
                                           message: "Set up for user \(UID).  READY"))
                
            }else{
                //DEBUGGING
                print(LCDebug.debugMessage(fromWhatClass: "LCHelper",
                                           message: "Not yet set up. User NOT signed in:\n1. SignIn the user\n2. Call <LCHelperRef>.configure()"))
            }
        }else{
            //DEBUGGING
            print(LCDebug.debugMessage(fromWhatClass: "LCHelper",
                                       message: "Already setup.\(ready())"))
        }
    }
    
    //End Private Helper Methods//
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
}
