//
//  CardContentViewController.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 8/16/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import UIKit
import LCHelper
import SDWebImage
import Cards

class CardContentViewController: UIViewController {
    
    private var card:LCCard!
    private var changesMade:Bool = false

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.delegate = self
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func setUp(card:LCCard){
        self.card = card
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
extension CardContentViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return card.imageURLS.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardImageCell", for: indexPath) as! CardImageCell
        
        if indexPath.row < card.imageURLS.count{
            let imageRef:StorageReference = LCHelper.shared().services().storage().reference(forURL: card.imageURLS[indexPath.row])
            imageRef.downloadURL { (url, err) in
                if err == nil{
                    cell.image.sd_setImage(with: url, placeholderImage: UIImage(named: "cards"), options: SDWebImageOptions.progressiveDownload, completed: nil)
                }else{
                    print("ERROR!!")
                }
            }
        }else{
            cell.image.image = #imageLiteral(resourceName: "plus")
        }
    
        return cell
    }
}
extension CardContentViewController:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        changesMade = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        card.text = textView.text
    }
}
extension CardContentViewController:CardDelegate{
    func cardDidShowDetailView(card: Card) {
        textView.text = self.card.text
        imageCollectionView.reloadData()
    }
    func cardWillCloseDetailView(card: Card) {
        print("ABOUT TO EXIT!!")
        if changesMade{
            self.card.updateOnDB()
        }
    }
}
