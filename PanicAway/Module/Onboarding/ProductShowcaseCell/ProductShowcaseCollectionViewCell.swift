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
    
    static let identifier = "ProductShowcaseCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
