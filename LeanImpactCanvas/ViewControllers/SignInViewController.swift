//
//  SignInViewController.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 5/16/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import UIKit
import GoogleSignIn
import LCHelper


class SignInViewController:UIViewController,GIDSignInUIDelegate {
    
    @IBOutlet weak var signInBttn: UIButton!
    
    private var user:LCUser!
    private var helper:LCHelper!
    private var signedIn:Bool!{
        willSet{
            if newValue == nil{
                self.signedIn = false
            }
        }
        
        didSet{
            DispatchQueue.main.async {
                //DEBUGGING
                print(LCDebug.debugMessage(fromWhatClass: "ViewController",
                                           message: "value of self.signedIn set to \(self.signedIn!)"))
                self.toggleSignInButtons()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OrientationUtility.lockOrientation(.portrait)
        print("MADE IT TO HERE!!!")

        helper = LCHelper.shared()
        helper.authHelper().GIDInstance().uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if helper.authHelper().isSignedIn(){
            LCDebug.debugMessage(fromWhatClass: "SignInViewController",
                                 message: "User is signed in setting current user in helper")
            signedIn = true
            toProjectsView()
        }
        else{
            signedIn = false
            toggleSignInButtons()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressSignIn(_ sender: Any) {
        //DEBUGGING
        LCDebug.debugMessage(fromWhatClass: "ViewController",
                             message: " @didPressSignIn ()")

        helper.authHelper().signIn {
            self.signedIn = self.helper.authHelper().isSignedIn()
            self.toProjectsView()
        }
    }
}
/******************************************************************/
/*Class helper methods*/
extension SignInViewController{
    private func toggleSignInButtons(){
        if signedIn {
            signInBttn.isEnabled = false
        }else{
            signInBttn.isEnabled = true
        }
    }
    
    private func toProjectsView(){
        if signedIn {
            LCDebug.debugMessage(fromWhatClass: "SignInViewController",
                                 message: "User is signed in. Segue to projects")
            performSegue(withIdentifier: "toProjectsSegue", sender: nil)
        }else{
            LCDebug.debugMessage(fromWhatClass: "SignInViewController",
                                 message: "User is NOT signed in.")
        }
    }
}
/******************************************************************/
//----------------------------------------------------------------//
/******************************************************************/
