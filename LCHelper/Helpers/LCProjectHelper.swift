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
    internal func getProjects(forUser user:LCUser, completion:(_ result:[LCProject])->()){
        var rtnArr:[LCProject] = []

        if let projPath = user.projects{
            for path in projPath{
                rtnArr.append(LCProject(ref: path))
            }
        }else{
            LCDebug.debugMessage(fromWhatClass: "LCProjectHelper",
                                 message: "Unable to get projects for user \(user.name)")
        }
        
        completion(rtnArr)
        
        
        
//
//        let path = LCModels.USER_ROOT(forUser: user)
//
//        group.enter()
//
//        //Get list of projectIDs
//        helper.services().firestore()?.document(path).getDocument(completion: { (snap, err) in
//            let array:Array<DocumentReference> = snap?.get(LCModels.PROJECTS_KEYWORD) as! Array<DocumentReference>
//
//            //Get info for each projctID
//            for doc in array {
//                self.group.enter()//Make sure thread waits for each project info get
//                doc.getDocument(completion: { (proj, err) in
//                    if proj != nil{
//                        rtnArr.append(LCProject(ref: proj!))
//                    }else{
//                        print(LCDebug.debugMessage(fromWhatClass: "LCProjectHelper",
//                                                   message: "Projects @ \(doc.path) does NOT exist"))
//                    }
//
//                    self.group.leave()//Leave project info get
//                })
//            }
//
//            self.group.leave()
//        })
//
//        //Wait until all results are in
//        group.wait()
//        //Return results
//        //DEBUGGING
//        LCDebug.debugMessage(fromWhatClass: "LCProjectHelper",
//                             message: "@getProjects - Got \(rtnArr.count) projects\n")
//        return rtnArr
    }

    
    
}
