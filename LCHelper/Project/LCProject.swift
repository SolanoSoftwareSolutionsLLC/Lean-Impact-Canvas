//
//  ProjectModel.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 6/14/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation

public class LCProject:CustomStringConvertible{
    public let helper:LCHelper = LCHelper.shared()
    
    public var decks:[LCDeck] = []
    public var name:String!
    public var id:String!
    
    public var users:[DocumentReference]!
    public var deckRefs:[DocumentReference]!
    
    public var fsRef:DocumentReference!
    
    public var description: String{
        return "LCProject: "
            + "{id: \(id)}"
            + "{name: \(name), "
            + "users: \(users), "
            + "decks: \(decks)}\n"
    }
    
    public init (snap:DocumentSnapshot){
        self.setUp(snap: snap)
    }
    
    public init(){}
    
    public func sync(completion:@escaping ()->()){
        fsRef.getDocument { (snap, err) in
            if err == nil{
                self.setUp(snap: snap!)
                completion()
            }
        }
    }
    
    private func setUp(snap:DocumentSnapshot){
        self.name = snap.get("name") as! String
        self.id = snap.get("id") as! String
        self.users = snap.get(LCModels.USERS_KEYWORD) as! [DocumentReference]
        self.deckRefs = snap.get(LCModels.DECKS_KEYWORD) as! [DocumentReference]
        self.fsRef = helper.services().FSRoot?.document(LCModels.PROJECT_ROOT(withID: self.id))
    }
}
