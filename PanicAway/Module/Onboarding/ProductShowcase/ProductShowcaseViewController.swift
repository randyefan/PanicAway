//
//  ProductShowcaseViewController.swift
//  PanicAway
//
//  Created by Javier Fransiscus on 26/07/21.
//

import UIKit

class ProductShowcaseViewController: UIViewController{
    
    @IBOutlet weak var productShowcaseCollectionView: UICollectionView!
    @IBOutlet weak var productShowcasePageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var slides: [ProductShowcaseSlide] = []
    
    var currentPage = 0  {
        didSet{
            productShowcasePageControl.currentPage = currentPage
            if currentPage == slides.count - 1{
                nextButton.setTitle("Get Started", for: .normal)
                skipButton.isEnabled = false
                skipButton.setTitleColor(.clear, for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
                skipButton.isEnabled = true
                skipButton.setTitleColor(UIColor(named: "Main"), for: .normal)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = [
        ProductShowcaseSlide(title: "Cope with panic attack", description:"Guided breathing to relieve your panic attack, and a one-touch emergency contact to notify your loved ones", image: #imageLiteral(resourceName: "OnboardingStress")),
        ProductShowcaseSlide(title: "Connect to apple watch", description: "Immediately get help anytime anywhere when you are experiencing panic attack", image: #imageLiteral(resourceName: "OnboardingWatch"))
        
        ]
        
        productShowcaseCollectionView.backgroundColor = UIColor(named: "Background")
        
        self.productShowcaseCollectionView.register(ProductShowcaseCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductShowcaseCollectionViewCell.identifier)
        self.productShowcaseCollectionView.delegate = self
        self.productShowcaseCollectionView.dataSource = self
        
    }

    @IBAction func nextButtonClick(_ sender: Any) {
        if currentPage == slides.count - 1 {
            
        }else{
            currentPage += 1
            let index = IndexPath(item: currentPage, section: 0)
            self.productShowcaseCollectionView.isPagingEnabled = false
            self.productShowcaseCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            self.productShowcaseCollectionView.isPagingEnabled = true
        }
    
        
    }
    
}

extension ProductShowcaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductShowcaseCollectionViewCell.identifier, for: indexPath) as! ProductShowcaseCollectionViewCell
        
        cell.setCellData(with: slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
