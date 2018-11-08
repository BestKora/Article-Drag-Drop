//
//  GarbageView.swift
//  ImageGallery
//
//  Created by Tatiana Kornilova on 15/06/2018.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import UIKit

class GarbageView: UIView {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        let trashImage = UIImage.imageFromSystemBarButton(.trash)
        let myButton = UIButton(frame: CGRect(x: 0,
                                              y: 0,
                                              width: bounds.height,
                                              height: bounds.height))
        myButton.setImage(trashImage, for: .normal)
        self.addSubview(myButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.subviews.count > 0 {
            self.subviews[0].frame = CGRect(x: bounds.width - bounds.height,
                                            y: 0,
                                            width:  bounds.height,
                                            height: bounds.height)
        }
    }
}

extension UIImage{
    
    class func imageFromSystemBarButton(_ systemItem: UIBarButtonItem.SystemItem, renderingMode:UIImage.RenderingMode = .automatic)-> UIImage {
        
        let tempItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        // add to toolbar and render it
        let bar = UIToolbar()
        bar.setItems([tempItem], animated: false)
        bar.snapshotView(afterScreenUpdates: true)
        
        // got image from real uibutton
        if let itemView = tempItem.value(forKey: "view") as? UIView {
        
        for view in itemView.subviews {
            if view is UIButton {
                let button = view as! UIButton
                let image = button.imageView!.image!
                image.withRenderingMode(renderingMode)
                return image
            }
        }
        }
        return UIImage()
    }
}

