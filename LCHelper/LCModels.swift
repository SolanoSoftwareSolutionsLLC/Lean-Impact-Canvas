//
//  LCModels.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 5/21/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation

internal class LCModels {
    /*MODEL CONSTANTS*/
    static let INFO_KEYWORD = "INFO"
    static let PROJECTS_KEYWORD = "PROJECTS"
    static let USERS_KEYWORD = "USERS"
    static let DECK_KEYWORD = "DECK"
    static let DECKS_KEYWORD = "DECKS"
    static let SECTIONS_KEYWORD = "SECTIONS"
    
    /*STRING REPLACEMENT CONSTANTS*/
    static let UID_KEYWORD = "$UID"
    static let PID_KEYWORD = "$PID"
    static let DID_KEYWORD = "$DID"

    
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    /*MODEL PATHS*/
    //User
    static let USER_ROOT_PATH =
        USERS_KEYWORD.appending("/").appending(UID_KEYWORD)
    static let USER_INFO_PATH =
        USERS_KEYWORD.appending("/").appending(UID_KEYWORD).appending("/").appending(INFO_KEYWORD)
    static let USER_PROJECTS_PATH =
        USERS_KEYWORD.appending("/").appending(UID_KEYWORD).appending("/").appending(PROJECTS_KEYWORD)
    
    //Project
    static let PROJECT_INFO_PATH =
        PROJECTS_KEYWORD.appending("/").appending(PID_KEYWORD).appending("/").appending(INFO_KEYWORD)
    static let PROJECT_USERS_PATH =
        PROJECTS_KEYWORD.appending("/").appending(PID_KEYWORD).appending("/").appending(USERS_KEYWORD)
    static let PROJECT_DECKS_PATH =
        PROJECTS_KEYWORD.appending("/").appending(PID_KEYWORD).appending("/").appending(DECK_KEYWORD)
    static let PROJECT_DECK_PATH =
        PROJECTS_KEYWORD.appending("/").appending(PID_KEYWORD).appending("/").appending(DECK_KEYWORD).appending("/").appending(DID_KEYWORD)
    
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    //Data models
    /*NEW_USER(usr)
     Purpose:
        Provides the dictionary needed to create a
        new blank Firestore DB record for 'usr'
     */
    static func NEW_USER(usr:User) -> [String:Any]{
        let projectArray:[String] = []
        
        let data:[String:Any] = [
            INFO_KEYWORD:[
                "name":usr.displayName,
                "uid":usr.uid
            ],
            PROJECTS_KEYWORD:projectArray
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
    //Path Models
    /*USER_ROOT(usr)
     Purpose:
        Provides the root to the user's document
     */
    static func USER_ROOT(forUser usr:String) -> String{
        return USER_ROOT_PATH.replacingOccurrences(of: UID_KEYWORD, with: usr)
    }
    
    /*USER_INFO(usr)
     Purpose:
     Provides the path to the user's info object
     */
    static func USER_INFO(forUser usr:String) -> String{
        return USER_INFO_PATH.replacingOccurrences(of: UID_KEYWORD, with: usr)
    }
    
    /*USER_PROJECTS(usr)
     Purpose:
     Provides the path to the user's current projects
     */
    static func USER_PROJECTS(forUser usr:String) -> String{
        return USER_PROJECTS_PATH.replacingOccurrences(of: UID_KEYWORD, with: usr)
    }
    
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
}
