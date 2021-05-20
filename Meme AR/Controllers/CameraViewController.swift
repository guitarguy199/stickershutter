//  CameraViewController.swift
//  Sticker Shutter
//
//  Created by Austin O'Neil on 1/23/21.
//

import UIKit
import ARKit
import RealityKit
import SceneKit
import CoreHaptics
import GoogleMobileAds

/*
 AdMob ID
 ca-app-pub-6409562125770170~8758566465
*/

class CameraViewController: UIViewController, ARSessionDelegate,  UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate {


    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var arView: ARView!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!

    var tap: UITapGestureRecognizer!
    
    var selectedImg: String = ""
    
    lazy var memes = Bundle.main.decode([Meme].self, from: "\(selectedImg).json")
    
    var meme: Meme?
    
    let ids = IDs()
    
    let productID = "com.tangentsystems.stickershutter.disableads"

    override func viewWillAppear(_ animated: Bool) {
    
        if let config = arView.session.configuration {
               let opts: ARSession.RunOptions = [.resetTracking,
                                                 .removeExistingAnchors,
                                                 .resetSceneReconstruction]
            
               arView.session.run(config, options: opts)
           }
        registerGestureRecognizer()
        tap.isEnabled = true
        

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.arView.debugOptions = [.showFeaturePoints, .showStatistics, .showAnchorOrigins]
//        self.arView.enableObjectRemoval()
        setupARView()
      
        navigationController?.isNavigationBarHidden = true
        camButtonAppearance()
        setupARView()
        
        bannerView.adUnitID = ids.bannerTest
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        let status = UserDefaults.standard.bool(forKey: "ads_removed")
        
        if status {
            bannerView.isHidden = true
        } else {
            bannerView.load(GADRequest())
        }

        
    }
    
    
    func kill() {
        arView.session.pause()
        arView.removeFromSuperview()
        arView = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let config = arView.session.configuration {
               let opts: ARSession.RunOptions = [.resetTracking,
                                                 .removeExistingAnchors,
                                                 .resetSceneReconstruction]
            
               arView.session.run(config, options: opts)
            kill()
           }
    }
 
    
    func registerGestureRecognizer() {
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
                tap.numberOfTapsRequired = 1
        arView.addGestureRecognizer(tap)
        print("screen tapped")
    }

    
    func setupARView() {
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
    }
     
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        
        let sceneLocation = gestureRecognizer.view as! ARView
        let touchLocation = gestureRecognizer.location(in: sceneLocation)
        guard let query = arView.makeRaycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .vertical)
        else {return}
        
        let results = arView.session.raycast(query)
        if results.count > 0 {
            
        
        if let tapResults = results.first {
            let mesh = MeshResource.generateBox(width: 0.7, height: 0.001, depth: 0.7, cornerRadius: 0.1, splitFaces: false)
         
       tapped()
            let texture = try? TextureResource.load(named: meme!.image)
                var material = UnlitMaterial()
                
                material.baseColor = MaterialColorParameter.texture(texture!)
            material.tintColor = UIColor.white.withAlphaComponent(0.99)
                let modelEntity = ModelEntity.init(mesh: mesh, materials: [material])
                let anchorEntity = AnchorEntity(raycastResult: tapResults)
            anchorEntity.name = "CubeAnchor"
                 anchorEntity.addChild(modelEntity)
                 arView.scene.addAnchor(anchorEntity)
                modelEntity.generateCollisionShapes(recursive: true)
            arView.installGestures([.translation, .rotation, .scale], for: modelEntity)
          }
            tap.isEnabled = false
        }
            
        }
        
    

    

    @IBOutlet weak var camButtonOutlet: UIButton!
    
    func camButtonAppearance() {
        camButtonOutlet.layer.cornerRadius = 0.5 * camButtonOutlet.bounds.size.width
        camButtonOutlet.layer.borderWidth = 1.0
        camButtonOutlet.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPhoto" {
            let destinationVC = segue.destination as! PhotoViewController
            let screenshot = self.view.takeScreenshot()
            destinationVC.image = screenshot
            let renderer = UIGraphicsImageRenderer(size: arView.bounds.size)
            renderer.image { ctx in
                view.drawHierarchy(in: arView.bounds, afterScreenUpdates: true)
            }
        } else if segue.identifier == "goToHelp" {
            let destinationVC = segue.destination as! HelpViewController
            destinationVC.transitioningDelegate = self
            destinationVC.modalPresentationStyle = .custom
        }
        }
    
    

    @IBAction func cameraButton(_ sender: UIButton) {
        camButtonOutlet.isHidden = true
        helpButton.isHidden = true
        backButton.isHidden = true
        flashButton.isHidden = true
        bannerView.isHidden = true
         tapped()
    }
    
    func tapped() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    
    @IBAction func helpButtonPressed(_ sender: UIButton) {
    

    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)

                } catch {
                    print(error)
                }
            }

            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    @IBAction func flashPressed(_ sender: UIButton) {
        toggleFlash()
        tapped()
    }
    
}


extension UIView {
    func takeScreenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil) {
            return image!
        }
        return UIImage()
    }
}

extension CameraViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("ad received")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print(error)
    }
}



//Object Removal Method...needs to reset tap count to work

//extension ARView {
//    func enableObjectRemoval() {
//        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
//        self.addGestureRecognizer(longPressGestureRecognizer)
//        print("long press detected")
//    }
//        @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
//            let location = recognizer.location(in: self)
//
//            if let entity = self.entity(at: location) {
//                if let anchorEntity = entity.anchor
//                   , anchorEntity.name == "CubeAnchor"
//                {
//                    anchorEntity.removeFromParent()
//                    print("removed anchor with name: " + anchorEntity.name)
//
//            }
//        }
//    }
//}
