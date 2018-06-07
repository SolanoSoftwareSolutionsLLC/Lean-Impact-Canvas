//
//  LCServiceHelper.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 5/30/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation

public class LCServiceHelper{
    internal var FSRoot:Firestore? = nil
    
    private let helper:LCHelper
    
    init(HelperRoot root:LCHelper) {
        self.helper = root
    }
    
    internal func configure(){
        FirebaseApp.configure()
        setup()
    }
    
    internal func app() ->FirebaseApp?{
        return FirebaseApp.app()
    }
    internal func firestore() ->Firestore?{
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        return Firestore.firestore()
    }
    internal func auth() -> Auth?{
        return Auth.auth()
    }
    
    /*setUp()
     Purpose:
     1. Attach LCHelper to current user
     2. Create user Firestore DB if does NOT exists
     */
    private func setup(){
        FSRoot = Firestore.firestore()
        
        
        if ( !helper.ready() ){
            if(auth()?.currentUser != nil){
                
                helper.currentUserUID = String((auth()?.currentUser?.uid)!)
    
                helper.userRoot = FSRoot?.document("USERS/\(helper.currentUserUID)")
                helper.projectsRoot = FSRoot?.document("PROJECTS/\(helper.currentUserUID)")
                
                helper.active = true
                print("FSHelper: Set up for user \(helper.currentUserUID).  READY")//DEBUGGING
                
                helper.createUser()
                
            }else{
                print("FSHelper: Not yet set up. User NOT signed in:\n1. SignIn the user\n2. Call <FSHelperRef>.setup()")//DEBUGGING
            }
        }else{
            print("FSHelper: Already setup. Ready!")//DEBUGGING
            let _ = helper.ready()//DEBUGGING
        }
    }
    
}
