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
    
    private var DECKS:[LCDeck] = []
    public var proj:LCProject!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self 

    }
    
    override func viewDidAppear(_ animated: Bool) {
        proj.loadDecks { (success) in
            if success{
                self.DECKS = proj.decks
            }
            collectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest:CardViewController = segue.destination as! CardViewController
        dest.NUMBER_OF_CARDS = 5//DECKS[sender as! Int].sections.count
    }
 
}
extension DecksViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:DeckCell = collectionView.dequeueReusableCell(withReuseIdentifier: "deckCell", for: indexPath) as! DeckCell
        cell.title.text = DECKS[indexPath.row].title
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toCardsSegue", sender: indexPath.row)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DECKS.count
    }
    
}
