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
    
    public var description: String{
        return "LCProject: "
            + "{id: \(id)}"
            + "{name: \(name), "
            + "users: \(users), "
            + "decks: \(decks)}\n"
    }
    
    public init (snap:DocumentSnapshot){
        self.name = snap.get("name") as! String
        self.id = snap.get("id") as! String
        self.users = snap.get(LCModels.USERS_KEYWORD) as! [DocumentReference]
        self.deckRefs = snap.get(LCModels.DECKS_KEYWORD) as! [DocumentReference]
    }
    
    public init(){}
    
//    internal static func  getProjectWithRef(ref:DocumentReference,  completion: @escaping (LCProject?)->()){
//        ref.getDocument { (snap, err) in
//            var project:LCProject? = nil
//            if err == nil{
//                project = LCProject()
//                
//                LCDebug.debugMessage(fromWhatClass: "LCProject",
//                                     message: "Firestore data recieved for project: \n"
//                                        + String(describing: snap?.data()))
//                
//                project?.deckRefs = snap?.get("DECKS") as! [DocumentReference]
//                project?.users = snap?.get(LCModels.USERS_KEYWORD) as! [DocumentReference]
//                project?.name = snap?.get("name") as! String
//                project?.id = snap?.get("id") as! String
//                
//                DispatchQueue.global().async {
//                    project?.getDecks()
//                }
//            }else{
//                LCDebug.debugMessage(fromWhatClass: "LCProject", message: "Unable to get project due to error: \(err)")
//            }
//            completion(project)
//        }
//    }
//    
//    private func getDecks(){
//        for deckRef in deckRefs{
//            LCDeck.getDeck(withRef: deckRef) { (deck) in
//                self.decks.append(deck!)
//            }
//        }
//    }
}
