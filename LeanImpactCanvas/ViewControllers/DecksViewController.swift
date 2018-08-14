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
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DeckRefs = proj.deckRefs
        
        for ref in DeckRefs{
            deckListeners.append(ref.addSnapshotListener({ (snap, err) in
                if err == nil{
                    print(snap?.data())
                    let deck = LCDeck(snap: snap!)
                    self.DECKS[deck.id] = deck
                    self.sortedDECKS = self.DECKS.sorted(by: {$0.value.title < $1.value.title})
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }else{
                    LCDebug.debugMessage(fromWhatClass: "DecksViewController", message: "Unable to get deck \(err)")
                }
            }))
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        for listner in deckListeners{
            listner.remove()
        }
        deckListeners.removeAll()
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
