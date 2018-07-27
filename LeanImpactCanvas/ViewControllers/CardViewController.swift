//
//  CardViewController.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 7/3/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var firstIndex:IndexPath!
    private var secondIndex:IndexPath!
    
    private let colors:[UIColor]  = [.red, .blue, .black, .brown, .purple]
    
    private var isConstrainedSizeCellsToViewSize:Bool = false
    private let DEFAULT_CELL_HEIGHT:CGFloat = 80.0
    private let SIZE_NOT_SELECTED_CELLS:CGFloat = 8.0
    public var NUMBER_OF_CARDS: Int!
    private var positionCellSelected:Int!
    
    private var sections:[SectionCell?] = []
    private var activeCellIndex:IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.frame.size.width = view.frame.width
        collectionView.frame.size.height = view.frame.height
        
        if sections.count == 0 {
            fillSectionsArray()
        }
        
        print("Number of cards \(NUMBER_OF_CARDS)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        OrientationUtility.lockOrientation(.allButUpsideDown)

    }
    override func viewWillDisappear(_ animated: Bool) {
        OrientationUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    private func fillSectionsArray(){
        for _ in 0...NUMBER_OF_CARDS{
            sections.append(nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension CardViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NUMBER_OF_CARDS
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(collectionView.numberOfItems(inSection: 0))
        
        if sections[indexPath.row] != nil {
            print("returning already existing cell")
            return sections[indexPath.row]!
        }
        
        print("returning new cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! SectionCell
        cell.backgroundColor = colors[indexPath.row]
        cell.WIDTH = collectionView.frame.size.width
        
        sections[indexPath.row] = cell
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
        

        
        
        //        if !cell.active{
        //            if !isConstrainedSizeCellsToViewSize{
        //                return CGSize(width: collectionView.bounds.size.width, height: DEFAULT_CELL_HEIGHT)
        //
        //            }
        //            else{
        //                return CGSize(width: collectionView.bounds.size.width, height:collectionView.bounds.size.height/CGFloat(collectionView.numberOfItems(inSection: 0)));
        //            }
        //        }else{
        //            if indexPath.row == 0{
        //                return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height - ((CGFloat(NUMBER_OF_CARDS))*SIZE_NOT_SELECTED_CELLS));
        //            }
        //                //This is to create the depth appearance for the not selected cells, tweak the default width factor(0.92) and the incremental value (4) as you wish
        //            else if (indexPath.row < (NUMBER_OF_CARDS - 1)){
        //                return CGSize(width:(0.92 * collectionView.bounds.size.width) + CGFloat(4.0 * Double(indexPath.row)),
        //                              height: SIZE_NOT_SELECTED_CELLS);
        //            }
        //
        //            //And the final cell (double than the others)
        //            else{
        //                return CGSize(width: collectionView.bounds.size.width, height: 2 * SIZE_NOT_SELECTED_CELLS);
        //            }
        //        }
    }
    
    
    
    
}

















