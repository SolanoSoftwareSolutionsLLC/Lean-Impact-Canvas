//
//  SectionCell.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 7/5/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import UIKit

class SectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var textView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let colors:[UIColor] = [.red, .blue, .green]
    
    public static let IDENTIFIER:String = "sectionCell"
    private static let IMAGE_IDENTIFIER = "imageCell"
    
    public static let ACTIVE_HEIGHT:CGFloat = 500.0
    public static let INACTIVE_HEIGHT:CGFloat = 50.0
    
    public var WIDTH:CGFloat = 100.0
    
    public var BG_COLOR:UIColor = .white
    public var active:Bool = false{
        didSet{
            if active{
                print("HidingStack")
                self.stackView.isHidden = false
                self.setUp()
            }else{
                print("ShowingStack")
                self.stackView.isHidden = true
            }
        }
    }
    
    public var numOfImages:Int = 1
    
    public var size:CGSize{
        get{
            if active{
                return CGSize(width: WIDTH, height: SectionCell.ACTIVE_HEIGHT)
            }
            return CGSize(width: WIDTH, height: SectionCell.INACTIVE_HEIGHT)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("Created with aDecoder")
        self.active = false
        
     
    }
    
    public func setUp(){
        //stackView.distribution = .fillEqually

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.backgroundColor = self.backgroundColor
        
        collectionView.reloadData()
    }
    public func toggleActive(){
        active = !active
    }
    
}

extension SectionCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
//    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Searching for num of images")
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCell.IMAGE_IDENTIFIER, for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        
        print("Printing image cell")
        return cell
    }
}
extension SectionCell:UITextFieldDelegate{
    
}
