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
        
        //Onboarding Data
        slides = [
            ProductShowcaseSlide(title: "Cope with panic attack",
                                 description:"Guided breathing to relieve your panic attack and a one-click emergency contact.",
                                 image: UIImage(named: "OnboardingStress") ?? #imageLiteral(resourceName: "OnboardingBatikGringsing")),
        
            ProductShowcaseSlide(title: "Cultural Tradition",
                                 description:"Gringsing Batik belief to shield and protect people from danger",
                                 image: UIImage(named: "OnboardingBatikGringsing") ?? #imageLiteral(resourceName: "hold4")),
            ProductShowcaseSlide(title: "Quick Access",
                                 description: "Seek assistance quickly by using Shortcut and a watchOS Complications.",
                                 image: UIImage(named: "OnboardingWatch") ?? #imageLiteral(resourceName: "breatheIn59")),
            ProductShowcaseSlide(title: "Widget",
                                 description: "Seek assistance quickly by using widget, Shortcut and a watchOS Complications.",
                                 image: UIImage(named: "OnboardingWidget") ?? #imageLiteral(resourceName: "Hold 3_00050")),
        ]
        
        productShowcaseCollectionView.backgroundColor = UIColor(named: "Background")
        
        productShowcasePageControl.numberOfPages = slides.count
        
        productShowcaseCollectionView.register(ProductShowcaseCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductShowcaseCollectionViewCell.identifier)
        productShowcaseCollectionView.delegate = self
        productShowcaseCollectionView.dataSource = self
        
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func pageControlSwiped(_ sender: Any) {
        currentPage = productShowcasePageControl.currentPage
        swipeTo(page: currentPage)
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        if currentPage == slides.count - 1 {
            nextView()
        }else{
        currentPage += 1
        swipeTo(page: currentPage)
           
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        setDefaultBreathingTechnique()
        setDefaultBreathingCycle()
        navigateToProfileName()
        
    }
    
    func nextView(){
        setDefaultBreathingTechnique()
        setDefaultBreathingCycle()
        navigateToProfileName()
        
    }
    
    
    func swipeTo(page current:Int){
        let index = IndexPath(item: current, section: 0)
        productShowcaseCollectionView.isPagingEnabled = false
        productShowcaseCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        productShowcaseCollectionView.isPagingEnabled = true
    }
    
    private func navigateToChooseBreathingTechnique() {
        let vc = BreathingChoiceViewController(entryPoint: .onBoarding)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAppleHealthAuthorize() {
        let vc = OnboardingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToProfileName(){
        let vc = ProfileNameOnBoardingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - TODO: Handle With Save User Default With Group
    private func setDefaultBreathingTechnique() {
        UserDefaults.standard.setValue(0, forKey: "defaultBreatheId")
    }
    
    private func setDefaultBreathingCycle() {
        UserDefaults.standard.setValue(4, forKey: "defaultBreathingCycle")
    }
    
}

extension ProductShowcaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductShowcaseCollectionViewCell.identifier, for: indexPath) as! ProductShowcaseCollectionViewCell
        
        cell.setCellData(with: slides[indexPath.row])
        cell.pageControlHeigtBottomConstraint = countPageControlBottomConstraint()
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
    
    func countPageControlBottomConstraint() -> CGFloat{
        return self.view.frame.height - productShowcasePageControl.frame.maxY
        
    }
    
}
