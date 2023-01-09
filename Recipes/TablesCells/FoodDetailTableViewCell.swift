//
//  FoodDetailTableViewCell.swift
//  Recipes
//
//  Created by Metehan Gelgi on 20.12.2022.
//

import UIKit

class FoodDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var measurementLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
