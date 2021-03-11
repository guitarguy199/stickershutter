//
//  SelectImageViewController.swift
//  Meme AR
//
//  Created by Austin O'Neil on 2/12/21.
//

import UIKit

class SelectImageViewController: UIViewController {
    
    lazy var selectedArray = Bundle.main.decode([Meme].self, from: "\(selectedCategory).json")
    var selectedCategory: String = ""
    var width = 150.0
    var cellMarginSize = 16.0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.setupGridView()
        
        self.collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "imageCellID")
      
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
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
    }
    

}

extension SelectImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCellID", for: indexPath) as! ImageCell
        cell.setData(image: self.selectedArray[indexPath.row].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedVC = storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        selectedVC.selectedImg = selectedCategory
        selectedVC.meme = selectedArray[indexPath.row]
        navigationController?.pushViewController(selectedVC, animated: true)

    }
    
    
}

extension SelectImageViewController: UICollectionViewDelegateFlowLayout {
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
