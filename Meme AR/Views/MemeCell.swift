//
//  MemeCell.swift
//  Meme AR
//
//  Created by Austin O'Neil on 1/25/21.
//

import UIKit

class MemeCell: UITableViewCell {

   
    @IBOutlet weak var memeImage: UIImageView!
    
    @IBOutlet weak var memeLabel: UILabel!
    
    @IBOutlet weak var cellOutlet: UIStackView!
    @IBOutlet weak var roundedCorners: UILabel!
    @IBOutlet weak var mainView: UIView!
    
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
//        roun.layer.cornerRadius = memeLabel.frame.size.height / 5
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//extension UIStackView {
//    public func addSoftUIEffectForView(cornerRadius: CGFloat = 15.0, themeColor: UIColor = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1.0)) {
//        self.layer.cornerRadius = cornerRadius
//        self.layer.masksToBounds = false
//        self.layer.shadowRadius = 2
//        self.layer.shadowOpacity = 1
//        self.layer.shadowOffset = CGSize( width: 2, height: 2)
//        self.layer.shadowColor = UIColor(red: 223/255, green: 228/255, blue: 238/255, alpha: 1.0).cgColor
//
//        let shadowLayer = CAShapeLayer()
//        shadowLayer.frame = bounds
//        shadowLayer.backgroundColor = themeColor.cgColor
//        shadowLayer.shadowColor = UIColor.white.cgColor
//        shadowLayer.cornerRadius = cornerRadius
//        shadowLayer.shadowOffset = CGSize(width: -2.0, height: -2.0)
//        shadowLayer.shadowOpacity = 1
//        shadowLayer.shadowRadius = 2
//        self.layer.insertSublayer(shadowLayer, at: 0)
//    }
//}
