//
//  LCProjectHelper.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 5/24/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation

public class LCProjectHelper{
    private let helper:LCHelper
    private let group:DispatchGroup = DispatchGroup()
    init(HelperRoot root:LCHelper) {
        self.helper = root
    }
    
    public func loadDecks(forProject proj:LCProject, completion: ([LCDeck]) -> ()){
        if proj.deckRefs != nil{
            proj.decks = []
            let group:DispatchGroup = DispatchGroup()
            
            for deckRef in proj.deckRefs{
                group.enter()
                LCDeck.getDeck(withRef: deckRef, completion: { (deck) in
                    if deck != nil{
                        proj.decks.append(deck!)
                    }
                    group.leave()
                })
            }
            
            group.wait()
        }else{
            LCDebug.debugMessage(fromWhatClass: "LCProjectHelper",
                                 message: "Unable to load decks for project \(proj)")
        }
    }
}
