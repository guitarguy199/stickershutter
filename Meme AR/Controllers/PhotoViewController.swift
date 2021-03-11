//
//  PhotoViewController.swift
//  AR Test
//
//  Created by Austin O'Neil on 1/24/21.
//

import UIKit
import SPAlert
import GoogleMobileAds

//INTERSTITIAL APP UNIT ID ca-app-pub-6409562125770170/8339532557


class PhotoViewController: UIViewController, GADBannerViewDelegate, GADFullScreenContentDelegate {
    
    let ids = IDs()

    var image: UIImage = UIImage()
    
    var ad: GADInterstitialAd?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var creditsOutlet: UIButton!
    @IBOutlet weak var downloadOutlet: UIButton!
    @IBOutlet weak var trashOutlet: UIButton!
    @IBOutlet weak var shareOutlet: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var labelView: GADBannerView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        navigationController?.isNavigationBarHidden = true
        view.bringSubviewToFront(topLabel)
        view.bringSubviewToFront(bottomLabel)
        view.bringSubviewToFront(xButton)
        view.bringSubviewToFront(downloadOutlet)
        view.bringSubviewToFront(trashOutlet)
        view.bringSubviewToFront(shareOutlet)
        view.bringSubviewToFront(creditsOutlet)
        view.bringSubviewToFront(labelView)
        labelView.adUnitID = ids.bannerThree
        labelView.rootViewController = self
        labelView.delegate = self
 
        
        let status = UserDefaults.standard.bool(forKey: "ads_removed")
        
        if status {
            labelView.isHidden = true
        } else {
            labelView.load(GADRequest())
            loadAd()
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
    }
    
    func loadAd() {
        let id = ids.intTwo
        GADInterstitialAd.load(withAdUnitID: id, request: GADRequest()) { (ad, error) in
            if error != nil { return }
            self.ad = ad
            self.ad?.fullScreenContentDelegate = self
        }
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("present ads")
    }
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       

    }
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print(error)
    }

    
    @IBAction func shareButton(_ sender: UIButton) {
        let items = [image]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    
    @IBAction func downloadButton(_ sender: UIButton) {
        tapped()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        let alertView = SPAlertView(title: "Saved to Library", preset: .done)
        alertView.present(duration: 1.5, haptic: .success, completion: nil)
       
        
        
    }
    
    func tapped() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    
    @IBAction func creditsButton(_ sender: UIButton) {
       
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        presentAd()
    }
    

    @IBAction func xButton(_ sender: UIButton) {
        presentAd()
        performSegue(withIdentifier: "photoToMenu", sender: self)
    }
    
    func presentAd() {
        
        let x = Int.random(in: 0..<10)
        print(x)
        if x % 2 == 0 {
            self.ad?.fullScreenContentDelegate = self
            self.ad?.present(fromRootViewController: self)
        }
        
        
     
    }
    
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("ad received")
    }
    
    

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print(error)
    }
    
}


