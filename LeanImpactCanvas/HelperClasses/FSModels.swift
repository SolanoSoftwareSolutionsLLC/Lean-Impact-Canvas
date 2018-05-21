//
//  FSModels.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 5/21/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation
import Firebase

class FSModels {
    /*MODEL CONSTANTS*/
    static let INFO_KEYWORD = "INFO"
    static let PROJECTS_KEYWORD = "PROJECTS"
    static let USERS_KEYWORD = "USERS"
    static let DECK_KEYWORD = "DECKS"
    static let SECTIONS_KEYWORD = "SECTIONS"
    
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    
    /*NEW_USER(usr)
     Purpose:
        Provides the dictionary need to create a
        new blank Firestore DB record for 'usr'
     */
    static func NEW_USER(usr:User) -> [String:Any]{
        let projectArray:[String] = []
        
        let data:[String:Any] = [
            "INFO":[
                "name":usr.displayName,
                "uid":usr.uid
            ],
            "PROJECTS":projectArray
        ]
        return data
    }
    
    /*NEW_PROJECT(usr, name)
     Purpose:
        Provides the dictionary needed to create a
        new blank project titled 'name' for 'usr'
     */
    static func NEW_PROJECT(forUser usr:User, name:String) -> [String:Any]{
        let data:[String:Any] = [:]
        return data
    }
    
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
}
