//
//  LCDeckSection.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 6/14/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation


public class LCCard{
    
    public var title:String = ""
    public var text:String = ""
    public var createdBy:DocumentReference!
    public var imageURLS:[String] = []
    
    init(ref:DocumentReference) {
       setUp(ref: ref)
    }
    
    private func setUp(ref:DocumentReference){
        let group:DispatchGroup = DispatchGroup()
        group.enter()
        ref.getDocument { (snap, err) in
            if err == nil{
//                LCDebug.debugMessage(fromWhatClass: "LCDeckSection",
//                                     message: "Firestore data recieved for card: \n"
//                                        + String(describing: snap?.data()))
                self.title = snap?.get("title") as! String
                self.text = snap?.get("text") as! String
                self.createdBy = snap?.get("owner") as! DocumentReference
                self.imageURLS = snap?.get("images") as! [String]
                group.leave()
            }
        }
        group.wait()
    }
}
