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
    public var fsRef:DocumentReference!
    
    //private var ref:DocumentReference
    
    public init (snap:DocumentSnapshot){
       setUp(data: snap)
    }

    internal init() {}
    
    public func sync(completion:@escaping ()->()){
        fsRef.getDocument { (snap, err) in
            self.setUp(data: snap)
            completion()
        }
       
    }
    
    private func setUp(data:DocumentSnapshot?){
        self.id = data?.get("id") as! String
        self.title = data?.get("title") as! String
        self.cardOrder = data?.get("cardOrder") as! [DocumentReference]
        self.fsRef = (LCHelper.shared().services().FSRoot?.document(LCModels.DECK_ROOT(withID: self.id)))!
    }
}
