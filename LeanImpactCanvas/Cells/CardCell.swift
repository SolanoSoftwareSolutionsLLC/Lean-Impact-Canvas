//
//  SectionCell.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 7/5/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import UIKit
import Cards

class CardCell: UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setUp(presentingView:UIViewController!){
        print("CREATED!!")
        // Aspect Ratio of 5:6 is preferred
        let card = CardArticle(frame: CGRect(x: 10, y: 30, width: frame.width - 20 , height: frame.height - 40))
        
        card.category = "DECK_NAME"
        card.title = "CARD_NAME"
        
        card.backgroundColor = UIColor(red: 0, green: 94/255, blue: 112/255, alpha: 1)
        //card.hasParallax = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let cardContentVC = storyboard.instantiateViewController(withIdentifier: "CardContent")
        card.shouldPresent(cardContentVC, from: presentingView , fullscreen: true)
        
        self.addSubview(card)
        
    }
}
