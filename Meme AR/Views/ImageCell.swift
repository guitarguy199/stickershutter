//
//  ImageCell.swift
//  Meme AR
//
//  Created by Austin O'Neil on 2/12/21.
//

import UIKit

class ImageCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(image: String) {
        self.imageView.image = UIImage(named: image)
    }
    
    
}
