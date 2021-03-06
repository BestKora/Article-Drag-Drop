//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by Tatiana Kornilova on 20/06/2018.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Public API
    var imageURL: URL? {
        didSet { updateUI()}
    }
    
    var changeAspectRatio : (() -> Void)?
    
    private func updateUI() {
        if let url = imageURL{
            imageView.image = nil
            spinner?.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async {
                //---- image cached -------
                if let chachedImage = imageCache.object(forKey:
                                       url.absoluteString as NSString){
                    DispatchQueue.main.async {
                        self.imageView?.image =  chachedImage
                        self.spinner?.stopAnimating()
                    }
                 //-------------------------
                } else {
                    let urlContents = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let imageData = urlContents,
                            url == self.imageURL,
                            let image = UIImage(data: imageData) {
                            imageCache.setObject(image, forKey:
                                            url.absoluteString as NSString)
                            self.imageView?.image =  image
                        } else {
                            self.imageView?.image =
                                "Error 😡".emojiToImage()?.applyBlurEffect()
                            self.changeAspectRatio?()
                        }
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }
}

extension String {
    func emojiToImage() -> UIImage? {
        let size = CGSize(width: 160 , height: 160)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        #colorLiteral(red: 0.7368795971, green: 0.9366820587, blue: 0.9764705896, alpha: 0.7592037671).set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        (self as NSString).draw(in: rect,
                                withAttributes: [
                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)
            ]
        )
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    func applyBlurEffect()-> UIImage {
        let imageToBlur = CIImage(image: self)
        let filter =  CIFilter(name: "CIGaussianBlur")
        filter?.setValue(imageToBlur, forKey: "inputImage")
        filter?.setValue(5, forKey: "inputRadius")
        let resultImage = filter?.value(forKey: "outputImage") as? CIImage
        let blurredImage = UIImage(ciImage: resultImage!)
        
        return blurredImage
    }
}
