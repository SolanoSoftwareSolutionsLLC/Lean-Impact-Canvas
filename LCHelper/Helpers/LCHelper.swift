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
        if ( !ready() ){//Helper is not yet set up
            //Init helper vars
            SERVICES_HELPER = services()
            //Additional config
            if services().app() == nil{
                SERVICES_HELPER?.configure()
            }
            
            AUTH_HELPER = authHelper()
            
            USER_HELPER = userHelper()
            

            PROJECT_HELPER = projectHelper()
            
            if authHelper().isSignedIn(){
                userHelper().setUp()
                active = true
                LCDebug.debugMessage(fromWhatClass: "LCHelper",
                                     message: "Configuring complete! User: \(USER_HELPER?.currentUser?.name)")
            }
            
            ready()
        }else{
            //DEBUGGING
            LCDebug.debugMessage(fromWhatClass: "LCHelper",
                                       message: "Already setup.\(ready())")
        }
    }
    
    /*breakDown()
     Purpose:
        Detach FSHelper from current user
     */
    public func breakDown(){
        //Break down UserHelper
        userHelper().breakDown()
        
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
    
    //End Private Helper Methods//
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
}
