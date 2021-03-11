//
//  MenuViewController.swift
//  Meme AR
//
//  Created by Austin O'Neil on 1/24/21.
//

import UIKit
import GoogleMobileAds


// APP ID ca-app-pub-6409562125770170~8758566465
//AD UNIT ID ca-app-pub-6409562125770170/2401682300

//TEST ID ca-app-pub-3940256099942544/2934735716

// iPad marketing attr <a href="https://www.vecteezy.com/free-vector/black">Black Vectors by Vecteezy</a>

class MenuViewController: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var continueOutlet: UIButton!
    @IBOutlet weak var tutorialView: UIImageView!
    

    let categories = Bundle.main.decode([Categories].self, from: "categories.json")
    let ids = IDs()
    
    var ad: GADInterstitialAd?
    var width = 150.0
    var cellMarginSize = 16.0
    let productID = "com.tangentsystems.stickershutter.disableads"
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
//        resetDefaults()
    }
    
//    func resetDefaults() {
//        let defaults = UserDefaults.standard
//        let dictionary = defaults.dictionaryRepresentation()
//        dictionary.keys.forEach { key in
//            defaults.removeObject(forKey: "isFirstTime")
//        }
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueOutlet.layer.cornerRadius = 25
        self.continueOutlet.alpha = 0
        self.tutorialView.alpha = 0

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.setupGridView()
        self.collectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "categoryCellID")
        bannerView.adUnitID = ids.bannerOne
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        let status = UserDefaults.standard.bool(forKey: "ads_removed")
        let defaults = UserDefaults.standard

        if defaults.object(forKey: "isFirstTime") == nil {
        print("Working")
            UIView.animate(withDuration: 1.2) {
                self.continueOutlet.alpha = 1
                self.tutorialView.alpha = 1
            }
            defaults.set("No", forKey: "isFirstTime")
        } else {
            tutorialView.isHidden = true
            continueOutlet.isHidden = true
            print("Didnt work")
        }
        if status {
            bannerView.isHidden = true
        } else {
            bannerView.load(GADRequest())
            loadAd()
        }
 
        
    }
    
    override func viewDidLayoutSubviews() {
        self.setupGridView()
        self.collectionView.reloadData()
    }
    
  
    
    func setupGridView() {
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    

    
    @IBAction func continuePressed(_ sender: Any) {
        UIView.animate(withDuration: 0.7) {
            self.continueOutlet.alpha = 0
            self.tutorialView.alpha = 0
        }
    }
    
    @IBAction func helpPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 1.2) {
            self.continueOutlet.alpha = 1
            self.tutorialView.alpha = 1
        }
    }
    
    
    
    func loadAd() {
        
        let id = ids.intOne
              GADInterstitialAd.load(withAdUnitID: id, request: GADRequest()) { ad, error in
                   if error != nil { return }
                   self.ad = ad
                   self.ad?.fullScreenContentDelegate = self
                  
          
           }
    }
    
    func presentAd() {
        self.ad?.fullScreenContentDelegate = self
        self.ad?.present(fromRootViewController: self)
    }

}

func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("present ads")
}
func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("dimissed ad")

}
func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    print(error)
}

// MARK: Collection View

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellID", for: indexPath) as! CategoryCell
        cell.setData(category: self.categories[indexPath.row].category, image: self.categories[indexPath.row].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedVC = storyboard?.instantiateViewController(withIdentifier: "SelectImageViewController") as! SelectImageViewController
        selectedVC.selectedCategory = categories[indexPath.row].category
        navigationController?.pushViewController(selectedVC, animated: true)
        
    }
    
    
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWidth()
        return CGSize(width: width, height: width)
    }
    
    func calculateWidth() -> CGFloat {
        let estimatedWidth = CGFloat(width)
        let cellCount = floor(self.view.frame.size.width / estimatedWidth)
        let margin = CGFloat(cellMarginSize * 2)
        let cellWidth = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        return cellWidth
    }
    
    
}



// MARK: GAD Banner Delegate

extension MenuViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("ad received")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print(error)
    }
}


