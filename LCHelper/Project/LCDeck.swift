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
    public var cardOrder:[DocumentReference] = []
    public var id:String = ""
    
    //private var ref:DocumentReference
    
    public init (snap:DocumentSnapshot){
        self.id = snap.get("id") as! String
        self.title = snap.get("title") as! String
        self.cardOrder = snap.get("cardOrder") as! [DocumentReference]
    }

    internal init() {}
    
    internal static func getDeck(withRef ref:DocumentReference, completion: @escaping (LCDeck?)->()){
        var deck:LCDeck? = nil
        ref.getDocument { (snap, err) in
            if err == nil{
                deck = LCDeck()
                LCDebug.debugMessage(fromWhatClass: "LCProjectDeck",
                                     message: "Firestore data recieved for deck: \n"
                                        
                                        + String(describing: snap?.data()))
                deck?.title = snap?.get("title") as! String
                deck?.cardOrder = snap?.get(LCModels.CARD_ORDER_KEYWORD) as! [DocumentReference]
            }else{
                LCDebug.debugMessage(fromWhatClass: "LCDeck",
                                     message: "Unable to get deck due to error: \(err)")
            }
            completion(deck)
        }
    }
    
    public func loadCards(){
        let group:DispatchGroup = DispatchGroup()
        for card in self.cardOrder{
            group.enter()
            card.getDocument { (snap, err) in
                print("IN HERE PROCESSING A DECK")
                if err != nil {
                    self.cards.append(LCCard(data: snap))
                }
                group.leave()
            }
        }
        group.wait()
    }
}
