//
//  LCServiceHelper.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 5/30/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation
import FirebaseFunctions

public class LCServiceHelper{
    internal var FSRoot:Firestore? = nil
    
    private let helper:LCHelper
    
    init(HelperRoot root:LCHelper) {
        self.helper = root
    }
    
    internal func configure(){
        FirebaseApp.configure()
        FSRoot = firestore()
    }
    
    public func app() ->FirebaseApp?{
        return FirebaseApp.app()
    }
    
    public func firestore() ->Firestore?{
        Firestore.firestore().settings.areTimestampsInSnapshotsEnabled = true
        return Firestore.firestore()
    }
    
    public func auth() -> Auth?{
        return Auth.auth()
    }
    
    public func function() -> Functions {
        return Functions.functions()
    }
    
    public func storage() -> Storage{
        return Storage.storage()
    }
}
