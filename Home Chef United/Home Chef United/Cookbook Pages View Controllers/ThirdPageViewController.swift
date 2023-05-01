//
//  ThirdPageViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/24/23.
//

import UIKit

class ThirdPageViewController: UIViewController {
    
    @IBOutlet weak var instructionsTableView: UITableView!
    
    var recipe: FavoriteRecipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionsTableView.delegate = self
        instructionsTableView.dataSource = self
        setupBackgroundView(for: self.view, with: UIImage(named: "RecipePage")!)
    }
    
}

extension ThirdPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let instructionCell = instructionsTableView.dequeueReusableCell(withIdentifier: "CookbookInstructionsCell", for: indexPath) as! CookbookInstructionsCell
        let instruction = recipe.instructions[indexPath.row]
        instructionCell.cookbookInstructionNumberLabel.text = "\(indexPath.row + 1))"
        instructionCell.cookbookInstructionLabel.text = instruction
        return instructionCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TimerHeaderView(frame: CGRect(x: 0, y: 0, width: instructionsTableView.frame.size.width, height: 64))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
}
