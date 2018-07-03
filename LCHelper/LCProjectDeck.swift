//
//  LCProjectDeck.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 6/14/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation

public class LCProjectDeck{
    
    public var sections:[LCDeckSection] = []
    private var sectionOrder:[DocumentReference]
    
    init(data:DocumentSnapshot) {
        sectionOrder = data.get(LCModels.DECK_SECTION_ORDER_KEYWORD) as! [DocumentReference]
        //parseSections()
    }
    
    private func parseSections(){
        var i = 0
        for section in sectionOrder{
            section.getDocument { (snap, err) in
                if err == nil{
                    self.sections[i] = (LCDeckSection(fromData: snap!))
                }else{
                    LCDebug.debugMessage(fromWhatClass: "LCProjectDeck",
                                         message: "Unable to init section \(err?.localizedDescription)")
                }
            }
            i+=1
        }
    }
    
}
