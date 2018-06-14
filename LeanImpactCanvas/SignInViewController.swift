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
        OrientationUtility.lockOrientation(.portrait)
                        
        helper = LCHelper.shared()
        helper.authHelper().GIDInstance().uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        signedIn = helper.authHelper().isSignedIn()
        toProjectsView()
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
            self.toProjectsView()
            self.performSegue(withIdentifier: "toProjectsSegue", sender: nil)
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
            print("IN SEGUE")
            performSegue(withIdentifier: "toProjectsSegue", sender: nil)
        }else{
            print("NO SEGUE")
        }
    }
}
/******************************************************************/
//----------------------------------------------------------------//
/******************************************************************/
