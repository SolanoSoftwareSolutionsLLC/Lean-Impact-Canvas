//
//  LCDeckSection.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 6/14/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation


public class LCDeckSection{
    
    public var title:String
    public var text:String
    public var createdBy:DocumentReference
    public var imageURLS:[String]
    
    init(fromData data:DocumentSnapshot ) {
        title = data.get("title") as! String
        text = data.get("text") as! String
        createdBy = data.get("title") as! DocumentReference
        imageURLS = data.get("images") as! [String]
    }
}
