//
//  ProductShowcaseCollectionViewCell.swift
//  PanicAway
//
//  Created by Javier Fransiscus on 26/07/21.
//

import UIKit

class ProductShowcaseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDescription: UILabel!
    @IBOutlet weak var cellDescriptionBottomConstraint: NSLayoutConstraint!
    
    static let identifier = "ProductShowcaseCollectionViewCell"
    var pageControlHeigtBottomConstraint: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        cellDescriptionBottomConstraint.constant = pageControlHeigtBottomConstraint + 50
    }
    
    static func nib()-> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func setCellData(with model: ProductShowcaseSlide){
        cellImageView.image = model.image
        cellTitle.text = model.title
        cellDescription .text = model.description
    }
    
}
