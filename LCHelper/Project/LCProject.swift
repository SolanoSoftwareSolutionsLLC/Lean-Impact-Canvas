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
    public var users:[DocumentReference]!
    
    private var deckRefs:[DocumentReference]!
    
    public var description: String{
        return "LCProject: "
            + "{name: \(name), "
            + "users: \(users), "
            + "decks: \(decks)}\n"
    }
    
    init(ref:DocumentReference){
        setUp(ref: ref)
    }
    
    private func setUp(ref:DocumentReference){
        let group:DispatchGroup = DispatchGroup()
        group.enter()
        ref.getDocument { (snap, err) in
            if err == nil{
//                LCDebug.debugMessage(fromWhatClass: "LCProject",
//                                     message: "Firestore data recieved for project: \n"
//                                        + String(describing: snap?.data()))
//                
                self.deckRefs = snap?.get(LCModels.DECKS_KEYWORD) as! [DocumentReference]
                self.users = snap?.get(LCModels.USERS_KEYWORD) as! [DocumentReference]
                self.name = snap?.get("name") as! String
                group.leave()
            }
        }
        group.wait()
    }
    
    public func loadDecks(completion: (_ success:Bool) -> ()){
        for deckRef in deckRefs {
            print("Attempting to load deck: \(deckRef.path)")
            let deck = LCDeck(ref: deckRef)
            decks.append(deck)
            print("COMING BACK!!!")
        }
        completion(true)
    }
}
