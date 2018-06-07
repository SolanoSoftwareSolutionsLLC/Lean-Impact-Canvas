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
    }
    
    internal func app() ->FirebaseApp?{
        return FirebaseApp.app()
    }
    
    internal func firestore() ->Firestore?{
        Firestore.firestore().settings.areTimestampsInSnapshotsEnabled = true
        return Firestore.firestore()
    }
    
    internal func auth() -> Auth?{
        return Auth.auth()
    }
}
