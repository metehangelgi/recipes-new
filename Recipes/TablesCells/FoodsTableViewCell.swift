//
//  FoodsTableViewCell.swift
//  Recipes
//
//  Created by Metehan Gelgi on 20.12.2022.
//

import UIKit
import Kingfisher

class FoodsTableViewCell: UITableViewCell {

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodNameField: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImage(strMealThumb:String){
        let url = URL(string: strMealThumb)
        foodImage.kf.setImage(with: url,placeholder: UIImage(systemName: "questionmark.circle.fill"),
                              options: [.loadDiskFileSynchronously,
                                        .cacheOriginalImage],
                              progressBlock: { receivedSize, totalSize in
            // Progress updated
            
        },
                              completionHandler: { result in
            // Done
            
        } )
    }

}
