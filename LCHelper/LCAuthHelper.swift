//
//  LCAuthHelper.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 5/31/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation
import GoogleSignIn

public class LCAuthHelper: NSObject {
    
    private var helper:LCHelper? = nil
    private var sharedGID:GIDSignIn? = nil
    
    private let group:DispatchGroup = DispatchGroup()
    
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/
    init(HelperRoot root:LCHelper) {
        super.init()
        
        self.helper = root
        GIDSignIn.sharedInstance().clientID = root.serviceHelper().app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        self.sharedGID = GIDSignIn.sharedInstance()
        
//        //DEBUGGING
//        print(LCDebug.debug(fromWhatClass: "LCAuthHelper",
//        message: "Initilized! Current client ID: \(GIDSignIn.sharedInstance().clientID)"))
    }
    /******************************************************************/
    //----------------------------------------------------------------//
    /******************************************************************/    
    /*GIDInstance()
     Purpose:
     Exposes the shaed GIDInstance. This should only
     be necessary to use in a small number of situations.
     For example when a UI delegate needs to be attached. 
     */
    public func GIDInstance() -> GIDSignIn{
        return self.sharedGID!
    }
    
    /*signIn()
     Purpose:
     Allows client to sign into LeanCanvas and accepts
     a completion block to be excecuted after sign in is
     completed.
     */
    public func signIn(completion:@escaping () -> ()){
        DispatchQueue.global().async {
            self.group.enter()
            self.sharedGID?.signIn()
            self.group.wait()
            
            completion()
        }
    }
    
    /*signOut()
     Purpose:
     Allows client to sign out of LeanCanvas and accepts
     a completion block to be excecuted after sign out is
     completed.
     */
    public func signOut(completion: @escaping ()->() ){
        DispatchQueue.global().async {
            self.group.enter()
            //self.sharedGID?.signOut()
            self.sharedGID?.disconnect()
            self.group.wait()
            
            completion()
            
        }
    }
    
    /*isSignedIn()
     Purpose:
     Returns true if a user is currently signed in
     false otherwise
     */
    public func isSignedIn() -> Bool{
        if Auth.auth().currentUser != nil{
            return true
        }
        return false
    }
}
/******************************************************************/
/********************** Class Extensions **************************/
/******************************************************************/
/*Google Sign-in Delegate Methods*/
extension LCAuthHelper: GIDSignInDelegate{
    //After signing in
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil{
            let GIDAuth = user.authentication
            let FIRAuth:AuthCredential = GoogleAuthProvider.credential(withIDToken: (GIDAuth?.idToken)!, accessToken: (GIDAuth?.accessToken)!)
            
            helper?.serviceHelper().auth()?.signInAndRetrieveData(with: FIRAuth) { (user, err) in
                if err == nil {
                    
                    //DEBUGGING
                    print(LCDebug.debugMessage(fromWhatClass: "LCAuthHelper",
                                               message: "Signed in as: \(user?.user.displayName! ?? "")!"))
                    
                    self.helper?.configure()
                    self.group.leave()
                }else{
                    //Default value below used to silence warning
                    print(LCDebug.debugMessage(fromWhatClass: "LCAuthHelper",
                                               message: (err?.localizedDescription)!))
                }
            }
        }else{
            group.leave()
            print(LCDebug.debugMessage(fromWhatClass: "LCAuthHelper",
                                       message: (error?.localizedDescription)!))
        }
    }
    //After signing out (disconnect() was called)
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if error == nil{
            
            do{
                try Auth.auth().signOut()
            }catch{
                print(LCDebug.debugMessage(fromWhatClass: "LCAuthHelper",
                                           message: "GIDSignIn Delegate - @didDisconnectWith -> SIGN OUT AUTH FAILED!"))
            }
            
            helper?.breakDown()
//            //DEBUGGING
//            print(LCDebug.debugMessage(fromWhatClass: "LCAuthHelper",
//                                       message: "GIDSignIn Delegate - @didDisconnectWith -> Signed out!"))
            self.group.leave()
        }
        else{
            print(LCDebug.debugMessage(fromWhatClass: "LCAuthHelper",
                                       message: (error?.localizedDescription)!))
        }
    }
    
}
/******************************************************************/

