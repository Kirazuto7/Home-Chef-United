//
//  RecipeInstructionsViewCell.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/22/23.
//

import UIKit

class RecipeInstructionsViewCell: UITableViewCell {
    @IBOutlet weak var instructionsTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let toolbar = UIToolbar()
        let button = UIBarButtonItem()
        button.style = .done
        toolbar.setItems([button], animated: true)
        toolbar.sizeToFit()
        instructionsTextView.inputAccessoryView = toolbar
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

/*extension RecipeInstructionsViewCell: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
}*/
