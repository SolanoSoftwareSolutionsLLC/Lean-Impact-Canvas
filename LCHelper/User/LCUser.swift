//
//  LCUser.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 7/26/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation

public class LCUser{
    public var name:String!
    public var uid:String!
    public var projectRefs:[DocumentReference]!
    
    private var userDocRef:DocumentReference!
    
    private init() {}
    
    public init (uid:String){
        self.uid = uid
        syncUser {}
    }
    
    public func syncUser(_ completion:@escaping ()->()){
        let userRef:DocumentReference = (LCHelper.shared().services().FSRoot?.document(LCModels.USER_ROOT(forUser: self.uid)))!
        
        userRef.getDocument { (data, err) in
            self.name = data?.get("name") as! String
            self.uid = data?.get("uid") as! String
            self.projectRefs = data?.get(LCModels.PROJECTS_KEYWORD) as! [DocumentReference]
            
            LCDebug.debugMessage(fromWhatClass: "LCUser",
                                 message: "User has been synced with DB")
            completion()
        }
    }

    

}
