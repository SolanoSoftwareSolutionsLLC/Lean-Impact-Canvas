//
//  ProjectsViewController.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 6/13/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import UIKit
import LCHelper
import SDWebImage

class ProjectsViewController: UIViewController {
    @IBOutlet weak var profileBttn: UIButton!
    @IBOutlet weak var projectsCollectionView: UICollectionView!
    
    private let helper:LCHelper = LCHelper.shared()
    private var projects:[String:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileBttn.sd_setBackgroundImage(with: helper.userHelper().user()?.photoURL, for: UIControlState.normal, completed: nil)
        projectsCollectionView.delegate = self
        projectsCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressProfileBtn(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        let yesAction:UIAlertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.helper.authHelper().signOut(completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
        let noAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressAddProjectBttn(_ sender: Any) {
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
extension ProjectsViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ProjectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! ProjectCell
        
        if projects != nil{
            for (key,value) in projects{
                cell.TitleLabel.text = key
                cell.ProjectDescriptionTextField.text = value
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
