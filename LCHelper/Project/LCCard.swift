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
    public var owner:DocumentReference!
    public var imageURLS:[String] = []
    public var fsRef:DocumentReference!
    
    private init() {}
    
    public init(snap:DocumentSnapshot?){
        setUp(data: snap)
    }
    
    public func sync(completion:@escaping ()->()){
        fsRef.getDocument { (snap, err) in
            self.setUp(data: snap)
            completion()
        }
    }
    public func updateOnDB(){
        //Setup Data
        var data:[String:Any] = [:]
        data["id"] = self.id
        data["title"] = self.title
        data["text"] = self.text
        data["owner"] = self.owner
        data["images"] = self.imageURLS
        
        fsRef.updateData(data)
    }
    
    private func setUp(data:DocumentSnapshot?){
        self.id = data?.get("id") as! String
        self.title = data?.get("title") as! String
        self.text = data?.get("text") as! String
        self.owner = data?.get("owner") as! DocumentReference
        self.imageURLS = data?.get("images") as! [String]
        self.fsRef = LCHelper.shared().services().FSRoot?.document(LCModels.CARD_ROOT(withID: self.id))
    }
    
}
