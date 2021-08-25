//
//  ProductShowcaseViewController.swift
//  PanicAway
//
//  Created by Javier Fransiscus on 26/07/21.
//

import UIKit

class ProductShowcaseViewController: UIViewController {

    @IBOutlet weak var productShowcaseCollectionView: UICollectionView!
    @IBOutlet weak var productShowcasePageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!

    var slides: [ProductShowcaseSlide] = []

    var currentPage = 0 {
        didSet {
            productShowcasePageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Get Started".localized(), for: .normal)
                skipButton.isEnabled = false
                skipButton.setTitleColor(.clear, for: .normal)
            } else {
                nextButton.setTitle("Next".localized(), for: .normal)
                skipButton.isEnabled = true
                skipButton.setTitleColor(UIColor(named: "Main"), for: .normal)

            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Onboarding Data
        slides = [
            ProductShowcaseSlide(title: "Cope with panic attack".localized(),
                                 description:"Guided breathing to relieve your panic attack and a one-click emergency contact.".localized(),
                                 image: UIImage(named: "OnboardingStress") ?? #imageLiteral(resourceName: "OnboardingBatikGringsing")),
        
            ProductShowcaseSlide(title: "Cultural Tradition".localized(),
                                 description:"Gringsing Batik belief to shield and protect people from danger.".localized(),
                                 image: UIImage(named: "OnboardingBatikGringsing") ?? #imageLiteral(resourceName: "hold4")),
            ProductShowcaseSlide(title: "Quick Access".localized(),
                                 description: "Seek assistance quickly by using Shortcut and a watchOS Complications.".localized(),
                                 image: UIImage(named: "OnboardingWatch") ?? #imageLiteral(resourceName: "breatheIn59")),
            ProductShowcaseSlide(title: "Widget".localized(),
                                 description: "Contact your support system and get relaxed in one click.".localized(),
                                 image: UIImage(named: "OnboardingWidget") ?? #imageLiteral(resourceName: "Hold 3_00050")),
        ]

        productShowcaseCollectionView.backgroundColor = UIColor(named: "Background")

        productShowcasePageControl.numberOfPages = slides.count

        productShowcaseCollectionView.register(ProductShowcaseCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductShowcaseCollectionViewCell.identifier)
        productShowcaseCollectionView.delegate = self
        productShowcaseCollectionView.dataSource = self
        currentPage = 0
        skipButton.setTitle("Skip".localized(), for: .normal)
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func pageControlSwiped(_ sender: Any) {
        currentPage = productShowcasePageControl.currentPage
        swipeTo(page: currentPage)
    }

    @IBAction func nextButtonClick(_ sender: Any) {
        if currentPage == slides.count - 1 {
            nextView()
        } else {
            currentPage += 1
            swipeTo(page: currentPage)

        }
    }

    @IBAction func skipButtonPressed(_ sender: Any) {
        setDefaultBreathingTechnique()
        setDefaultBreathingCycle()
        setDefaultAudio()
        navigateToProfileName()
        
    }

    func nextView() {
        setDefaultBreathingTechnique()
        setDefaultBreathingCycle()
        setDefaultAudio()
        navigateToProfileName()
        
    }


    func swipeTo(page current: Int) {
        let index = IndexPath(item: current, section: 0)
        productShowcaseCollectionView.isPagingEnabled = false
        productShowcaseCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        productShowcaseCollectionView.isPagingEnabled = true
    }

    private func navigateToChooseBreathingTechnique() {
        let vc = BreathingChoiceViewController(entryPoint: .onBoarding)
        self.navigationController?.pushViewController(vc, animated: true)
    }


    private func navigateToEmergencyContact() {
        let vc = EmergencyContactViewController(entryPoint: .onBoarding)
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

    private func setDefaultAudio() {
        UserDefaults.standard.setValue(true, forKey: "defaultAudioState")
    }

}

extension ProductShowcaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
