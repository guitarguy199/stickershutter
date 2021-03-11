//
//  TutorialViewController.swift
//  Meme AR
//
//  Created by Austin O'Neil on 1/24/21.
//

import UIKit

class HelpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
    }
}
