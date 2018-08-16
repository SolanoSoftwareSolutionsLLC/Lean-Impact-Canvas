//
//  SectionCell.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 7/5/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import UIKit
import LCHelper
import Cards

class CardCell: UICollectionViewCell {
    
    public var deckName:String = ""
    public var color:UIColor = UIColor(red: 0, green: 94/255, blue: 112/255, alpha: 1)
    
    public var lcCard:LCCard!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setUp(presentingView:UIViewController!,lcCard:LCCard){
        self.lcCard = lcCard
        // Aspect Ratio of 5:6 is preferred
        let card = CardArticle(frame: CGRect(x: 10, y: 30, width: frame.width - 20 , height: frame.height - 40))
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cardContentVC:CardContentViewController = storyboard.instantiateViewController(withIdentifier: "CardContent") as! CardContentViewController
        
        cardContentVC.setUp(card: lcCard)
        card.delegate = cardContentVC
        card.shouldPresent(cardContentVC, from: presentingView , fullscreen: true)
        
        card.category = deckName
        card.title = lcCard.title
        card.subtitle = lcCard.text
        
        card.backgroundColor = color
        card.shadowBlur = 1

        self.addSubview(card)
    }
}
