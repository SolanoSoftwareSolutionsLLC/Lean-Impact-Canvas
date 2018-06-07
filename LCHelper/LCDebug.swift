//
//  LCDebug.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 6/7/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation


public class LCDebug{
    public static func debugMessage(fromWhatClass sender:String, message:String) -> String{
        let rtnMessage = "\nDEBUG - \(sender) : \(message)\n"
        return rtnMessage
    }
}
