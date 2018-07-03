//
//  ProjectModel.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 6/14/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation

public class LCProject{
    public let helper:LCHelper = LCHelper.shared()
    
    private var reference:DocumentReference
    private var decksRef:CollectionReference
    
    public var DECKS:[LCProjectDeck]
    public var NAME:String
    public var USERS:[DocumentReference]

    
    init(ref:DocumentSnapshot){
        reference = ref.reference
        decksRef = ref.reference.collection(LCModels.DECKS_KEYWORD)
        
        USERS = ref.get(LCModels.USERS_KEYWORD) as! [DocumentReference]
        NAME = ref.get(LCModels.PROJECT_NAME_KEYWORD) as! String
        DECKS = []
        
        DispatchQueue.global().async {
            self.loadDecks()
        }
    }
        
    private func loadDecks(){
        decksRef.getDocuments { (snap, err) in
            if err == nil{
                var doc:DocumentSnapshot
                for ref in (snap?.documents)!{
                    doc = ref
                    self.DECKS.append(LCProjectDeck(data: doc))
                }
                
            }else{
                LCDebug.debugMessage(fromWhatClass: "LCProject", message: "Unable to find number of decks")
            }
        }
    
    }
}
