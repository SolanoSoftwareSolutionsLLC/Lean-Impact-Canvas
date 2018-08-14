//
//  PresentationViewController.swift
//  LeanImpactCanvas
//
//  Created by Hassam Solano-Morel on 7/3/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import UIKit
import PDFKit
import SwiftyJSON
import CoreMotion
import LCHelper

class PresentationViewController: UIViewController, PDFViewDelegate {
    
    var pdfView:PDFView!
    var document:PDFDocument!
    var cards:[LCCard]!
    
    let motionManager:CMMotionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.initPDFView()
        self.addTestAnnotation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        OrientationUtility.lockOrientation(.allButUpsideDown)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        OrientationUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("Presentation transitionted to size!!")
        if UIDevice.current.orientation.isPortrait {
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func initPDFView(){
        pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        pdfView.displayDirection = .horizontal
        pdfView.displayMode = .singlePage
        
        pdfView.autoScales = true
        
        let url = Bundle.main.url(forResource: "whiteBG", withExtension: "pdf")
        let tempDoc = PDFDocument(url: url!)
        self.document = tempDoc
        pdfView.document = tempDoc
    }
    
    /*
     This method adds all current annotiations to
     to the underlying PDFView
     */
    private func addTestAnnotation(){
        var boundsX:Int;
        var boundsY:Int;
        var boundsWidth:Int;
        var boundsHeight:Int;
        var bounds:CGRect;
        var sectionAnnotation:PDFAnnotation;
        
        var i = 0;

        for card in cards {
            boundsX = 100
            boundsY = 300
            boundsWidth = 600
            boundsHeight = 288
            bounds = CGRect(x: boundsX, y: boundsY, width: boundsWidth, height: boundsHeight)
            
            sectionAnnotation = PDFAnnotation(bounds: bounds, forType: .freeText, withProperties: nil)
            sectionAnnotation.fontColor = .black
            sectionAnnotation.font = UIFont(name: "Helvetica", size: 30)
            sectionAnnotation.contents = card.text
            sectionAnnotation.color = .clear
            
            pdfView.document?.page(at: i)?.addAnnotation(sectionAnnotation)
            
            i+=1;
        }
    }
}
