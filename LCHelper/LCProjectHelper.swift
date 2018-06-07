//
//  LCProjectHelper.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 5/24/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation

public class LCProjectHelper{
    private let helper:LCHelper
    private let group:DispatchGroup = DispatchGroup()
    internal var root:DocumentReference? = nil
    
    init(HelperRoot root:LCHelper) {
        self.helper = root
    }
    
    /*getProjects(user)
     Purpose:
        Creates a dictionary of the given user's projects
     Return:
        [PROJECT_NAME:FIRESTORE/PATH/TO/PROJECT]
     */
    internal func getProjects(forUser user:String) -> [String:String]{
        let path = LCModels.USER_ROOT(forUser: user)
        var rtnDict:[String:String] = [:]
        
        group.enter()
        
        //Get list of projectIDs
        helper.services().firestore()?.document(path).getDocument(completion: { (snap, err) in
            let array:Array<DocumentReference> = snap?.get(LCModels.PROJECTS_KEYWORD) as! Array<DocumentReference>
            
            //Get info for each projctID
            for doc in array {
                self.group.enter()//Make sure thread waits for each project info get
                doc.getDocument(completion: { (proj, err) in
                    if err == nil{
                        let info:[String:String] = (proj?.data()![LCModels.INFO_KEYWORD])! as! [String : String]
                        
                        //Insert into rtnDict
                        rtnDict[info["name"]!] = doc.path
                    }else{
                        print(LCDebug.debugMessage(fromWhatClass: "LCProjectHelper",
                                                   message: "Projects @ \(doc.path) does NOT exist"))
                    }
                    
                    self.group.leave()//Leave project info get
                })
            }
            
            self.group.leave()
        })
        
        //Wait until all results are in
        group.wait()
        //Return results
        //DEBUGGING
        print(LCDebug.debugMessage(fromWhatClass: "LCProjectHelper",
                                   message: "@getProjects - Got:\n \(rtnDict)"))
        return rtnDict
    }
    
    
}
