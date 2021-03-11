//
//  CategoryCell.swift
//  Meme AR
//
//  Created by Austin O'Neil on 2/12/21.
//

import UIKit

class CategoryCell: UICollectionViewCell {

   
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
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
        bgView.bringSubviewToFront(categoryLabel)
        bgView.bringSubviewToFront(categoryImageView)
    }

    func setData(category: String, image: String) {
        self.categoryLabel.text = category
        self.categoryImageView.image = UIImage(named: image)
        
    }
    
    
}
