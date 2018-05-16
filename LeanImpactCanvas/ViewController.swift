//
//  ViewController.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 5/16/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController:UIViewController {
    
    @IBOutlet weak var signOutBttn: UIButton!
    @IBOutlet weak var googleSignInButtnView: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        toggleSignInButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressSignOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance().signOut()
            
            toggleSignInButtons()
        } catch {
            print(AuthErrorCode.keychainError)
            
        }
    }
}
/******************************************************************/
/*Class helper methods*/
extension ViewController{
    private func toggleSignInButtons(){
        if Auth.auth().currentUser != nil{
            signOutBttn.isEnabled = true
            googleSignInButtnView.isEnabled = false
        }else{
            signOutBttn.isEnabled = false
            googleSignInButtnView.isEnabled = true
        }
    }
}
/******************************************************************/
//----------------------------------------------------------------//
/******************************************************************/
/*Google Sign-in Delegate Methods*/
extension ViewController: GIDSignInDelegate, GIDSignInUIDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil{
            let GIDAuth = user.authentication
            let FIRAuth:AuthCredential = GoogleAuthProvider.credential(withIDToken: (GIDAuth?.idToken)!, accessToken: (GIDAuth?.accessToken)!)
            
            Auth.auth().signIn(with: FIRAuth) { (user, err) in
                if err == nil {
                    print("Signed in as: " + (user?.displayName)! )
                    self.toggleSignInButtons()
                }else{
                    //Default value below used to silence warning
                    print(err?.localizedDescription ?? "")
                }
                
            }
        }
    }
}
/******************************************************************/

