//
//  AddRecipeFirstSectionViewCell.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/22/23.
//

import UIKit

protocol AddRecipeFirstSectionViewCellDelegate: AnyObject {
    func setRecipePhoto(_ addRecipeFirstSectionViewCell: AddRecipeFirstSectionViewCell)
}

class AddRecipeFirstSectionViewCell: UITableViewCell {

    @IBOutlet weak var recipeTitleTextField: UITextField!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var placeholderImageView: UIImageView!
    
    var delegate: AddRecipeFirstSectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }
    
    func setupViews() {
        let placeHolderTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageGestureTapped(gestureRecognizer:)))
        let recipeTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageGestureTapped(gestureRecognizer:)))
        placeHolderTapGesture.numberOfTapsRequired = 1
        recipeTapGesture.numberOfTapsRequired = 1
        recipeImageView.addGestureRecognizer(recipeTapGesture)
        placeholderImageView.addGestureRecognizer(placeHolderTapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showImage(image: UIImage) {
        recipeImageView.image = image
    }
    
    @objc func imageGestureTapped(gestureRecognizer: UIGestureRecognizer) {
        delegate?.setRecipePhoto(self)
    }
}
