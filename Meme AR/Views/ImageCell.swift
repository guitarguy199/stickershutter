//
//  ImageCell.swift
//  Meme AR
//
//  Created by Austin O'Neil on 2/12/21.
//

import UIKit

class ImageCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBgView: UIView!
    
    @IBDesignable
    class RoundedCornerView: UIView {
        
        @IBInspectable
        var cornerRadius: CGFloat {
            set { layer.cornerRadius = newValue}
            get { return layer.cornerRadius}
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        imageBgView.bringSubviewToFront(imageView)
        imageBgView.layer.shadowColor = UIColor.black.cgColor
        imageBgView.layer.shadowRadius = 3.0
        imageBgView.layer.shadowOffset = .zero
        imageBgView.layer.shadowOpacity = 0.5
    }

    func setData(image: String) {
        self.imageView.image = UIImage(named: image)
    }
    
    
}
