//
//  CookbookTableViewCell.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/21/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth

protocol RecipeCollectionViewCellDelegate: class {
    func recipeCollectionView(recipeCollectionView: RecipeCollectionViewCell?, index: Int, section: Int, tableViewCell: CookbookTableViewCell)
    func removeRecipeFromCollectionView(recipeCollectionView: RecipeCollectionViewCell?, index: Int, section: Int, tableViewCell: CookbookTableViewCell)
    func editRecipeFromCollectionView(recipeCollectionView: RecipeCollectionViewCell?, index: Int, section: Int, sectionName: String, tableViewCell: CookbookTableViewCell)
}

class CookbookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipesCollectionView: UICollectionView!
    var recipeCells: [FavoriteRecipe]?
    var section: Int?
    var sectionName: String?
    weak var cellDelegate: RecipeCollectionViewCellDelegate?
    var user: User? = Auth.auth().currentUser
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 150, height: 180)
        flowLayout.minimumLineSpacing = 16.0
        flowLayout.minimumInteritemSpacing = 16.0
        self.recipesCollectionView.collectionViewLayout = flowLayout
        self.recipesCollectionView.showsHorizontalScrollIndicator = false
        
        self.recipesCollectionView.dataSource = self
        self.recipesCollectionView.delegate = self
        
        let cellNib = UINib(nibName: "RecipeCollectionViewCell", bundle: nil)
        self.recipesCollectionView.register(cellNib, forCellWithReuseIdentifier: "RecipeCollectionCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CookbookTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func updateCellWith(row: [FavoriteRecipe], for section: Int, as sectionName: String) {
        self.section = section
        self.sectionName = sectionName
        self.recipeCells = row
        self.recipesCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recipeCells?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionCell", for: indexPath) as? RecipeCollectionViewCell {
            if let recipeArray = self.recipeCells {
                cell.configure(for: recipeArray[indexPath.item])
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? RecipeCollectionViewCell
        self.cellDelegate?.recipeCollectionView(recipeCollectionView: cell, index: indexPath.item, section: section!, tableViewCell: self)
        self.cellDelegate?.removeRecipeFromCollectionView(recipeCollectionView: cell, index: indexPath.item, section: section!, tableViewCell: self)
        self.cellDelegate?.editRecipeFromCollectionView(recipeCollectionView: cell, index: indexPath.item, section: section!, sectionName: sectionName!, tableViewCell: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
}
