//
//  LCDeckSection.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 6/14/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation


public class LCCard{
    
    public var id:String = ""
    public var title:String = ""
    public var text:String = ""
    public var createdBy:DocumentReference!
    public var imageURLS:[String] = []
    
    private init() {}
    
    public init(data:DocumentSnapshot?){
        self.id = data?.get("id") as! String
        self.title = data?.get("title") as! String
        self.text = data?.get("text") as! String
        self.createdBy = data?.get("owner") as! DocumentReference
        self.imageURLS = data?.get("images") as! [String]
    }
    
    private func getCard(withRef ref:DocumentReference, completion: @escaping (LCCard?)->()){
        var card:LCCard? = nil
        ref.getDocument { (snap, err) in
            if err == nil{
                card = LCCard()
                LCDebug.debugMessage(fromWhatClass: "LCDeckSection",
                                     message: "Firestore data recieved for card: \n"
                                        + String(describing: snap?.data()))
                
                card?.title = snap?.get("title") as! String
                card?.text = snap?.get("text") as! String
                card?.createdBy = snap?.get("owner") as! DocumentReference
                card?.imageURLS = snap?.get("images") as! [String]
            }else{
                LCDebug.debugMessage(fromWhatClass: "LCCard",
                                     message: "Unable to get card due to error: \(err)")
            }
            completion(card)
        }
    }
}
