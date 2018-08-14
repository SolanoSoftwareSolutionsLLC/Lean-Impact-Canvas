//
//  NewProjectViewController.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 8/14/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import UIKit
import LCHelper

class NewProjectViewController: UIViewController {
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var textField: UITextField!
    
    private let helper:LCHelper = LCHelper.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blurEffect.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressNext(_ sender: Any) {
        blurEffect.isHidden = false
        
        helper.services().function().httpsCallable("newProject").call(["projName": textField.text]) { (result, err) in
            if err == nil{
                LCDebug.debugMessage(fromWhatClass: "NewProjectViewController",
                                     message: "Created new project got message: \(result?.data)")
                self.blurEffect.isHidden = true
                self.navigationController?.popViewController(animated: true)
            }else{
                
            }
        }
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title: "Cancel New Project?",
                                                        message: "You sure you don't want to create a new project?",
                                                        preferredStyle: .alert)
        
        let yesAction:UIAlertAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let noAction:UIAlertAction = UIAlertAction(title: "No!", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
