//
//  IngredientsCollectionViewCell.swift
//  Recipes
//
//  Created by Metehan Gelgi on 20.12.2022.
//

import UIKit

class IngredientsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var ingredientLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // selectedImage.image = UIImage(systemName: "plus.circle")
        
        let view = UIView(frame: bounds)
        self.backgroundView = view
        
        let coloredView = UIView(frame: bounds)
        coloredView.backgroundColor = UIColor.red
        self.selectedBackgroundView = coloredView
        
        
        
    }
        
}
