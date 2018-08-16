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
    
    private let colors:[UIColor] = [.gray]
    private static let IMAGE_IDENTIFIER = "imageCell"
    
    public var BG_COLOR:UIColor = .white
    public static let IDENTIFIER:String = "sectionCell"
    
    public var collectionViewSize:CGSize = CGSize()
    public var numOfImages:Int = 1

    
    public var HEIGHT:CGFloat{
        get{
            if active{
                return CGFloat(collectionViewSize.height - 10.0)
            }
            return 50.0
        }
    }
    
    public var WIDTH:CGFloat{
        get{
            return collectionViewSize.width
        }
    }
    
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
    
    public var size:CGSize{
        get{
           return CGSize(width: WIDTH, height: HEIGHT)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("Created with aDecoder")
        self.active = false
        //self.setUp()
    }
    
    private func setUp(){
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
        return numOfImages
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
