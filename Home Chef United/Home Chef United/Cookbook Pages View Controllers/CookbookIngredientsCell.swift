//
//  CookbookIngredientsCell.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/24/23.
//

import UIKit

class CookbookIngredientsCell: UITableViewCell {

    
    @IBOutlet weak var ingredientNumberLabel: UILabel!
    @IBOutlet weak var ingredientNameLabel: UILabel!
    @IBOutlet weak var ingredientMeasurementLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
