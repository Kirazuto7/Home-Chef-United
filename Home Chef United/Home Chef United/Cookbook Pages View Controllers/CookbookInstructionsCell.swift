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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
