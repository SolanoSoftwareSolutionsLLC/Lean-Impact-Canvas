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
    @IBOutlet weak var nameLabel: UITextView!
    
    private let helper:LCHelper = LCHelper.shared()
    
    private var lcProjects:[String:LCProject] = [:]
    private var sortedLCProjects: [(key: String, value: LCProject)] = []
    private var projectListeners:[ListenerRegistration] = []
    private var userListener:ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileBttn.sd_setBackgroundImage(with: helper.userHelper().fsUser()?.photoURL,
                                          for: UIControlState.normal, completed: nil)
        
        projectsCollectionView.delegate = self
        projectsCollectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addUserListener()
        addProjectListeners()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeUserListener()
        removeProjectListeners()
    }
    
    private func addUserListener(){
        let userRef:DocumentReference = (helper.services().firestore()?
            .document(LCModels.USER_ROOT(forUser: (helper.userHelper().currentUser?.uid)!)))!
        
        self.userListener = userRef.addSnapshotListener({ (snap, err) in
            self.helper.userHelper().currentUser?.syncUser {
                self.nameLabel.text = (self.helper.userHelper().currentUser?.name)! + "!"

                self.removeProjectListeners()
                self.addProjectListeners()
            }
        })
    }
    
    private func addProjectListeners(){
        var listener:ListenerRegistration
        self.lcProjects.removeAll()
        
        if (helper.userHelper().currentUser?.projectRefs != nil){
            for ref in (helper.userHelper().currentUser?.projectRefs)!{
                listener = ref.addSnapshotListener({ (snap, err) in
                    if err == nil{
                        let project = LCProject(snap: snap!)
                        self.lcProjects[project.id] = project
                        self.sortedLCProjects = self.lcProjects.sorted(by: {$0.value.name < $1.value.name})
                        print("SORTED LCPROJECTS COUNT: \(self.sortedLCProjects.count)")
                        DispatchQueue.main.async {
                            self.projectsCollectionView.reloadData()
                        }
                    }else{
                    }
                })
                self.projectListeners.append(listener)
            }
        }
    }
    
    private func removeUserListener(){
        userListener.remove()
    }
    
    private func removeProjectListeners(){
        for listener in projectListeners{
            listener.remove()
        }
        projectListeners.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressProfileBtn(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title: "Sign Out?",
                                                        message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
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
    
    @IBAction func didPressAddProjectBttn(_ sender: Any) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DecksViewController{
            let dest:DecksViewController = segue.destination as! DecksViewController
            dest.proj = sortedLCProjects[sender as! Int].value
        }
    }
}

extension ProjectsViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ProjectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! ProjectCell
        let project = self.sortedLCProjects[indexPath.row].value
        
        cell.TitleLabel.text = project.name
        cell.ProjectDescriptionTextField.text = "This is a test of the description"
        cell.NumberOfDecksLabel.text = String(describing: project.deckRefs.count)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDecksSegue", sender: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sortedLCProjects.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
