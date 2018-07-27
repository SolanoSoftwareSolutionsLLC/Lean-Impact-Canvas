//
//  LCProjectDeck.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 6/14/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation

public class LCDeck{
    
    public var cards:[LCCard] = []
    public var title:String = ""
    private var sectionOrder:[DocumentReference] = []
    
    private var ref:DocumentReference
    
    init(ref:DocumentReference) {
        self.ref = ref
    }
    
    public func setUp(ref:DocumentReference, completion: ()->()){
        LCDebug.debugMessage(fromWhatClass: "LCDeck",
                             message: "Setting up deck: \(ref.path)")
        
        let group:DispatchGroup = DispatchGroup()
        group.enter()
        
        ref.getDocument { (snap, err) in
            if err == nil{
                LCDebug.debugMessage(fromWhatClass: "LCProjectDeck",
                                     message: "Firestore data recieved for deck: \n"
                                        + String(describing: snap?.data()))
                self.title = snap?.get("title") as! String
                self.sectionOrder = snap?.get(LCModels.CARD_ORDER_KEYWORD) as! [DocumentReference]
                //self.parseCards()
            }
            group.leave()
            print("PASS THE DECK LEAVE!\n")
        }
        group.wait()
        
        completion()
    }
    
    public func parseCards(completion: ()->()){
        for section in sectionOrder{
            self.cards.append(LCCard(ref:section))
        }
        completion()
    }
    
}
