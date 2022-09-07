//
//  HomeTBViewController.swift
//  TestPAger
//
//  Created by MacOS on 07/09/2022.
//

import UIKit
import FSPagerView

class HomeTBViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.numberOfPages = imgArray.count
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.setImage(UIImage(named: "Rectangle735"), for: UIControl.State.selected)
            self.pageControl.setImage(UIImage(named: "Rectangle738"), for: UIControl.State.normal)
        }
    }
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    let imgArray = ["Group2562-1","9c42156" ,"helianth11863" , "pexelsphoto462118"]
    let carTypeArray = [  "Maza","Nissan","Mase", "Volvo"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setFSPageControl()
        setupCollectionView()
        let logo = UIImage(named: "tilteNavg")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
}
// MARK: - UICollectionView Car Type
extension HomeTBViewController: UICollectionViewDelegate , UICollectionViewDataSource {
    
    func setupCollectionView(){
//        collectionView.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carTypeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        cell.configureCell(name: carTypeArray[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}



// MARK: - FSPageControl
extension HomeTBViewController: FSPagerViewDelegate , FSPagerViewDataSource  {
    
    func setFSPageControl() {
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.automaticSlidingInterval = 3
    }
    
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named:imgArray[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.contentView.layer.shadowColor = UIColor.clear.cgColor
        cell.contentView.layer.shadowRadius = 0
        cell.contentView.layer.shadowOpacity = 0
        cell.contentView.layer.shadowOffset = .zero
        return cell
        
    }
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imgArray.count
    }
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
    }
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        self.pageControl.currentPage = index
    }
    
    
}
extension UICollectionViewFlowLayout {

    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }

}
