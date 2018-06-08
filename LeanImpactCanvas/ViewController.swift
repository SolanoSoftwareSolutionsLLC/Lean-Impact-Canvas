//
//  ViewController.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 5/16/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import UIKit
import GoogleSignIn
import LCHelper

class ViewController:UIViewController,GIDSignInUIDelegate {
    
    @IBOutlet weak var signOutBttn: UIButton!
    @IBOutlet weak var signInBttn: UIButton!
    
    private var helper:LCHelper!
    
    private var signedIn:Bool!{
        willSet{
            if newValue == nil{
                self.signedIn = false
            }
        }
        
        didSet{
            DispatchQueue.main.async {
//                //DEBUGGING
//                print(LCDebug.debugMessage(fromWhatClass: "ViewController",
//                                           message: "value of self.signedIn set to \(self.signedIn!)"))
                self.toggleSignInButtons()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper = LCHelper.shared()
        helper.authHelper().GIDInstance().uiDelegate = self
        
        signedIn = helper.authHelper().isSignedIn()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressSignIn(_ sender: Any) {
//        DEBUGGING
//        print(LCDebug.debugMessage(fromWhatClass: "ViewController",
//                                   message: " @didPressSignIn ()"))

        helper.authHelper().signIn {
            self.signedIn = self.helper.authHelper().isSignedIn()
            
            self.helper.userHelper().userProjects(completion: { (data) in
                print(data)
            })
            
            
        }
    }

    @IBAction func didPressSignOut(_ sender: Any) {
//        DEBUGGING
//        print(LCDebug.debugMessage(fromWhatClass: "ViewController",
//                                   message: " @didPressSignOut ()"))
        helper.authHelper().signOut {
            self.signedIn = self.helper.authHelper().isSignedIn()
        }
     
    }
}
/******************************************************************/
/*Class helper methods*/
extension ViewController{
    private func toggleSignInButtons(){
        if signedIn {
            signOutBttn.isEnabled = true
            signInBttn.isEnabled = false
        }else{
            signOutBttn.isEnabled = false
            signInBttn.isEnabled = true
        }
    }
}
/******************************************************************/
//----------------------------------------------------------------//
/******************************************************************/
