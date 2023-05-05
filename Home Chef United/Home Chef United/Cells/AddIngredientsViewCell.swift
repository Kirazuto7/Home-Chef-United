//
//  AddIngredientsViewCell.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/22/23.
//

import UIKit

protocol AddIngredientsViewCellDelegate: AnyObject {
    func didAddTap(_ addIngredientsViewCell: AddIngredientsViewCell)
    func didRemoveTap(_ addIngredientsViewCell: AddIngredientsViewCell)
}

class AddIngredientsViewCell: UITableViewCell {

    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var measurementTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    weak var delegate: AddIngredientsViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ingredientTextField.delegate = self
        measurementTextField.delegate = self
        addCancelToTextFields(forTextFields: [ingredientTextField, measurementTextField])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Outlet Actions
    
    @IBAction func addMoreIngredients(_ sender: Any) {
        // TODO: - Create a new Ingredient Cell row
        delegate?.didAddTap(self)
    }
    
    @IBAction func removeIngredient(_ sender: Any) {
        delegate?.didRemoveTap(self)
    }
    
}

extension AddIngredientsViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}
