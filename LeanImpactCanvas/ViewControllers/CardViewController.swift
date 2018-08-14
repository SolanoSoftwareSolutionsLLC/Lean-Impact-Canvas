//
//  CardViewController.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 7/3/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import UIKit
import LCHelper

class CardViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var firstIndex:IndexPath!
    private var secondIndex:IndexPath!
    
    public var deck:LCDeck!
    private var cardListeners:[ListenerRegistration] = []
    private var cards:[String:LCCard] = [:]
    private var sortedCards:[LCCard] = []
    
    private let colors:[UIColor]  = [.red, .blue, .black, .brown, .purple]
    
    private var isConstrainedSizeCellsToViewSize:Bool = false
    private let DEFAULT_CELL_HEIGHT:CGFloat = 80.0
    private let SIZE_NOT_SELECTED_CELLS:CGFloat = 8.0
    private var positionCellSelected:Int!
    
    private var sectionCells:[String:SectionCell] = [:]
    private var activeCellIndex:IndexPath? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.frame.size.width = view.frame.width
        collectionView.frame.size.height = view.frame.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        OrientationUtility.lockOrientation(.allButUpsideDown)
        var listener:ListenerRegistration
        
        for ref in deck.cardOrder{
            listener = ref.addSnapshotListener({ (snap, err) in
                if err == nil{
                    let card = LCCard(data: snap)
                    print("CARD ID HERE: \(card.id)")
                    self.cards[card.id] = card
                    self.sortCards()
                }else{
                    
                }
            })
            self.cardListeners.append(listener)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        OrientationUtility.lockOrientation(.portrait)

        for listener in cardListeners{
            listener.remove()
        }
        cardListeners.removeAll()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            self.performSegue(withIdentifier: "toPresentationSegue", sender: "toPresentation")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as! String == "toPresentation"{
            let dest = segue.destination as! PresentationViewController
            dest.cards = sortedCards
        }else{
            OrientationUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func sortCards(){
        sortedCards = []
        for ref in deck.cardOrder{
            let id = ref.path.replacingOccurrences(of: "CARDS/", with: "")
            print("Cards : \(cards)")
            print("Searching for ID: \(id)")
            sortedCards.append(cards[id]!)
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
extension CardViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedCards.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(collectionView.numberOfItems(inSection: 0))
        let id = sortedCards[indexPath.row].id
        
        if sectionCells[id] != nil {
            print("returning already existing cell")
            return sectionCells[id]!
        }
        
        print("returning new cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! SectionCell
        let card = sortedCards[indexPath.row]
        
        cell.backgroundColor = colors[indexPath.row]
        cell.WIDTH = collectionView.frame.size.width
        
        cell.label.text = card.title
        cell.numOfImages = card.imageURLS.count
        
        sectionCells[id] = cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let oldActive = activeCellIndex
        activeCellIndex = indexPath
        
        var oldActiveCell:SectionCell? = nil
        let newActiveCell:SectionCell = collectionView.cellForItem(at: activeCellIndex!)! as! SectionCell

        if oldActive != nil{//Somthing has been previously selected
            oldActiveCell = collectionView.cellForItem(at: oldActive!) as? SectionCell
            
            if oldActive?.row == activeCellIndex?.row{
                print("Same Cell")
                newActiveCell.active = false
                activeCellIndex = nil
                UIView.animate(withDuration: 0.2, animations: {
                    newActiveCell.frame.size.height = SectionCell.INACTIVE_HEIGHT
                }) { (complete) in
                    let skip = indexPath.row
                    var otherCells:[IndexPath] = []
                    var i = indexPath.row
                    var tempIndex:IndexPath = IndexPath(row: 0, section: 0)
                    
                    while i < collectionView.numberOfItems(inSection: 0){
                        if i == skip{
                            i += 1
                            continue
                        }
                        
                        tempIndex.row = i
                        otherCells.append(tempIndex)
                        i += 1
                    }
                    
                    
                    collectionView.performBatchUpdates({
                        collectionView.reloadItems(at: otherCells)
                        
                    }, completion: nil)
                    
                }
            }else{
                print("NOT same - previous selection")
                oldActiveCell?.active = false
                newActiveCell.active = true
                UIView.animate(withDuration: 0.2, animations: {
                    let skip = [oldActive?.row,self.activeCellIndex?.row]
                    var otherCells:[IndexPath] = []
                    var i = indexPath.row
                    var tempIndex:IndexPath = IndexPath(row: 0, section: 0)
                    
                    while i < collectionView.numberOfItems(inSection: 0){
                        if skip.contains(i){
                            i += 1
                            continue
                        }
                        
                        tempIndex.row = i
                        otherCells.append(tempIndex)
                        i += 1
                    }
                    
                    collectionView.performBatchUpdates({
                        collectionView.reloadItems(at: otherCells)

                    }, completion: { (complete) in
                        oldActiveCell?.frame.size.height = SectionCell.INACTIVE_HEIGHT
                        newActiveCell.frame.size.height = SectionCell.ACTIVE_HEIGHT
                    })
                    
                    
                }) { (complete) in
                    
                }
            }
        }
        else{
            print("No previous selection")
            newActiveCell.active = true
            UIView.animate(withDuration: 0.2, animations: {
                let skip = indexPath.row
                var otherCells:[IndexPath] = []
                var i = indexPath.row
                var tempIndex:IndexPath = IndexPath(row: 0, section: 0)
                
                while i < collectionView.numberOfItems(inSection: 0){
                    if i == skip{
                        i += 1
                        continue
                    }
                    
                    tempIndex.row = i
                    otherCells.append(tempIndex)
                    i += 1
                }
                collectionView.performBatchUpdates({
                    collectionView.reloadItems(at: otherCells)
                    
                }, completion: { (complete) in
                    newActiveCell.frame.size.height = SectionCell.ACTIVE_HEIGHT

                })
            }) { (complete) in
                
            }
        }
    }
}

extension CardViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let cell = collectionView.cellForItem(at: indexPath){
            //print("returning size\((cell as! SectionCell).size)")
            return (cell as! SectionCell).size
        }else{
            //print("returning default size")
            return CGSize(width: collectionView.frame.size.width, height: SectionCell.INACTIVE_HEIGHT)
        }
    }
}
