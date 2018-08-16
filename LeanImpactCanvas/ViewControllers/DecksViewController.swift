//
//  DecksViewController.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 7/3/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import UIKit
import LCHelper

class DecksViewController: UIViewController {

    private var DECKS:[String:LCDeck] = [:]
    private var sortedDECKS:[(key:String,value:LCDeck)] = []
    
    public var proj:LCProject!
    public var DeckRefs:[DocumentReference] = []
    private var deckListeners:[ListenerRegistration] = []
    private var projectListener:ListenerRegistration!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Add Deck Alert
    var addDeckAlertController:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setUpAlertView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addDeckListners()
        addProjectListener()
    }
    
    private func addProjectListener(){
        projectListener = proj.fsRef?.addSnapshotListener { (snap, err) in
            if err == nil{
                self.proj.sync {
                    self.removeDeckListeners()
                    self.addDeckListners()
                }
            }else{
                LCDebug.debugMessage(fromWhatClass: "DecksViewController",
                                     message: "Failed to get project info during listen.")
            }
        }
        
    }
    
    private func addDeckListners(){
        DeckRefs = proj.deckRefs
        
        for ref in DeckRefs{
            deckListeners.append(ref.addSnapshotListener({ (snap, err) in
                if err == nil{
                    let deck = LCDeck(snap: snap!)
                    self.DECKS[deck.id] = deck
                    self.sortedDECKS = self.DECKS.sorted(by: {$0.value.title < $1.value.title})
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }else{
                    LCDebug.debugMessage(fromWhatClass: "DecksViewController",
                                         message: "Unable to get deck \(String(describing: err))")
                }
            }))
        }
    }
    
    private func removeProjectListenter(){
        projectListener.remove()
    }
    
    private func removeDeckListeners(){
        for listner in deckListeners{
            listner.remove()
        }
        deckListeners.removeAll()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeProjectListenter()
        removeDeckListeners()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest:CardViewController = segue.destination as! CardViewController
        dest.deck = sortedDECKS[sender as! Int].value
    }
    
    
    @IBAction func didPressAdd(_ sender: Any) {
        present(addDeckAlertController, animated: true, completion: nil)
    }
    
}
extension DecksViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:DeckCell = collectionView.dequeueReusableCell(withReuseIdentifier: "deckCell", for: indexPath) as! DeckCell
        let deck = sortedDECKS[indexPath.row].value
        
        cell.title.text = deck.title
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toCardsSegue", sender: indexPath.row)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedDECKS.count
    }
    
}
//NEW DECK ALERT VIEW
extension DecksViewController{
    
    private func setUpAlertView(){
        let alert = UIAlertController(title: "Creating a New Deck",
                                                    message: "Give it a name:",
                                                    preferredStyle: .alert)
        let createAction:UIAlertAction = UIAlertAction(title: "Create!", style: .default) { (action) in
            self.createNewDeck(withName: alert.textFields![0].text!)
        }
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //self.addDeckAlertController.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        
        
        addDeckAlertController = alert
    }
    
    private func createNewDeck(withName name:String){
        LCHelper.shared().services().function().httpsCallable("newDeck")
            .call(["deckName": name, "projID":self.proj.id]) { (result, err) in
            if err == nil{
                LCDebug.debugMessage(fromWhatClass: "DecksViewController",
                                     message: "Created new deck got message: \(String(describing: result?.data))")
            }else{
                
            }
        }
    }
}
    
    

