//
//  CreditsViewController.swift
//  Meme AR
//
//  Created by Austin O'Neil on 1/25/21.
//

import UIKit
import StoreKit

class CreditsViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {


    @IBOutlet weak var removeOutlet: UIButton!
    @IBOutlet weak var restoreOutlet: UIButton!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    
    var myProduct: SKProduct?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProducts()
        self.removeOutlet.layer.cornerRadius = 25
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    

    @IBAction func privacyPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://tangentsyste.ms/privacy-policy")!)
    }
    
    @IBAction func termsPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://tangentsyste.ms/terms-of-service")!)
    }
    
    
    
    
    @IBAction func removePressed(_ sender: UIButton) {
     buyRemoveAds()
        UIView.animate(withDuration: 0.2) {
            self.labelOne.textColor = .gray
            self.labelTwo.textColor = .gray
            self.removeOutlet.backgroundColor = .white
        }
      
    }
    
    
    
    @IBAction func restorePressed(_ sender: UIButton) {
        SKPaymentQueue.default().restoreCompletedTransactions()
        print("pressed")
    }
    
    
    
    
    // MARK: In App Purchase Methods
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: ["com.tangentsystems.stickershutter.removeallads"])
        request.delegate = self
        request.start()
    }
    
    func buyRemoveAds() {
        guard let myProduct = myProduct else {
            return
        }

        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: myProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            print("Fetching...")
        }
        print("Working")
    }
    
    func removeAds() {
        UserDefaults.standard.set(true, forKey: "ads_removed")
        self.labelOne.isHidden = true
        self.labelTwo.isHidden = true
        self.removeOutlet.isHidden = true
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "Error", message: "Something went wrong. Please try again later.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func successAlert() {
        let alert = UIAlertController(title: "Success!", message: "Thanks for your purchase.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    



    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            myProduct = product
            print(product.productIdentifier)
            print(product.price)
            print(product.localizedTitle)
            print(product.localizedDescription)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("Purchasing...")
                break
                
            case .purchased, .restored:
                
                removeAds()
                successAlert()
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            case .failed, .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                errorAlert()
                break
                
            default:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            }
        }
    }
    
    
    
    //Old payment quene
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            if transaction.transactionState == .purchased {
//                SKPaymentQueue.default().finishTransaction(transaction)
//                successAlert()
//                print("Transaction successful")
//                removeAds()
//            } else if transaction.transactionState == .failed {
//
//                if let error = transaction.error {
//                    let errorDescription = error.localizedDescription
//                    print("transaction failed with\(errorDescription)")
//                    errorAlert()
//                }
//
//                SKPaymentQueue.default().finishTransaction(transaction)
//
//            } else if transaction.transactionState == .restored {
//                removeAds()
//                SKPaymentQueue.default().finishTransaction(transaction)
//            }
//        }
//    }
//
    //    func buyRemoveAds() {
    //        if SKPaymentQueue.canMakePayments() {
    //            let paymentRequest = SKMutablePayment()
    //            paymentRequest.productIdentifier = productID
    //            SKPaymentQueue.default().add(paymentRequest)
    //        } else {
    //            print("PaymentQuene failed")
    //            errorAlert()
    //        }
    //    }
        

}
