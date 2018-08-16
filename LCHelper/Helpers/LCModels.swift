//
//  LCModels.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 5/21/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation

public class LCModels {
    /*MODEL CONSTANTS*/
    static let INFO_KEYWORD = "INFO"
    static let PROJECTS_KEYWORD = "PROJECTS"
    static let USERS_KEYWORD = "USERS"
    static let DECK_KEYWORD = "DECK"
    static let DECKS_KEYWORD = "DECKS"
    static let SECTIONS_KEYWORD = "SECTIONS"
    static let PROJECT_NAME_KEYWORD = "name"
    static let CARDS_KEYWORD = "CARDS"
    static let CARD_ORDER_KEYWORD = "cardOrder"
    
    /*STRING REPLACEMENT CONSTANTS*/
    private static let UID_KEYWORD = "$UID"
    private static let PID_KEYWORD = "$PID"
    private static let DID_KEYWORD = "$DID"
    private static let CID_KEYWORD = "$CID"

    
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
    private static let PROJECT_ROOT_PATH =
        PROJECTS_KEYWORD.appending("/").appending(PID_KEYWORD)
    private static let PROJECT_INFO_PATH =
        PROJECTS_KEYWORD.appending("/").appending(PID_KEYWORD).appending("/").appending(INFO_KEYWORD)
    private static let PROJECT_USERS_PATH =
        PROJECTS_KEYWORD.appending("/").appending(PID_KEYWORD).appending("/").appending(USERS_KEYWORD)
    private static let PROJECT_DECKS_PATH =
        PROJECTS_KEYWORD.appending("/").appending(PID_KEYWORD).appending("/").appending(DECK_KEYWORD)
    private static let PROJECT_DECK_PATH =
        PROJECTS_KEYWORD.appending("/").appending(PID_KEYWORD).appending("/").appending(DECK_KEYWORD).appending("/").appending(DID_KEYWORD)
    
    //Card
    private static let CARD_ROOT_PATH =
        CARDS_KEYWORD.appending("/").appending(CID_KEYWORD)
    
    //DECK
    private static let DECK_ROOT_PATH =
        DECKS_KEYWORD.appending("/").appending(DID_KEYWORD)
    
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
    
    /*PROJECT_ROOT*/
    public static func PROJECT_ROOT(withID id:String) -> String{
        return PROJECT_ROOT_PATH.replacingOccurrences(of: PID_KEYWORD, with: id)
    }
    
    
    /*CARD_ROOT*/
    public static func CARD_ROOT(withID id:String) -> String{
        return CARD_ROOT_PATH.replacingOccurrences(of: CID_KEYWORD, with: id)
    }
    
    /*DECK_ROOT*/
    public static func DECK_ROOT(withID id:String) -> String{
        return DECK_ROOT_PATH.replacingOccurrences(of: DID_KEYWORD, with: id)
    }
    
    /*USER_ROOT(usr)
     Purpose:
        Provides the root to the user's document
     */
    public static func USER_ROOT(forUser usr:String) -> String{
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
