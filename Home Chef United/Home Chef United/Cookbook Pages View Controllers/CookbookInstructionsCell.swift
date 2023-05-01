//
//  CookbookInstructionsCell.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/25/23.
//

import UIKit

class CookbookInstructionsCell: UITableViewCell {
    
    @IBOutlet weak var cookbookInstructionNumberLabel: UILabel!
    @IBOutlet weak var cookbookInstructionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gradient = CAGradientLayer()
        let topColor = CGColor(red: 255/255, green: 126/255, blue: 95/255, alpha: 1)
        let bottomColor = CGColor(red: 254/255, green: 180/255, blue: 123/255, alpha: 1)
        gradient.frame = bounds
        gradient.locations = [0.0, 1.0]
        gradient.colors = [topColor, bottomColor]
        let view = UIImageView()
        view.image = gradientImage(fromLayer: gradient)
        backgroundView = view
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
