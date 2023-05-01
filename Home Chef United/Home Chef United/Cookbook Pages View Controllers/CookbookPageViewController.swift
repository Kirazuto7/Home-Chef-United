//
//  CookbookPageViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/22/23.
//

import UIKit

class CookbookPageViewController: UIPageViewController {
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [newPageViewController(forPageNum: 1),
                newPageViewController(forPageNum: 2),
                newPageViewController(forPageNum: 3)]
    }()
    
    var recipe: FavoriteRecipe!
    var statusBarView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
        navigationController?.navigationBar.backgroundColor = .clear
        self.tabBarController?.tabBar.isHidden = true
        statusBarView?.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        navigationController?.navigationBar.backgroundColor = appBackgroundColor
        self.tabBarController?.tabBar.isHidden = false
        statusBarView?.isHidden = false
    }
    // Pages start from 1
    private func newPageViewController(forPageNum page: Int) -> UIViewController {
        switch page {
        case 1:
            let firstPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstPageViewController") as! FirstPageViewController
            firstPageVC.recipe = recipe
            return firstPageVC
        case 2:
            let secondPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondPageViewController") as! SecondPageViewController
            secondPageVC.recipe = recipe
            return secondPageVC
        case 3:
            let thirdPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdPageViewController") as! ThirdPageViewController
            thirdPageVC.recipe = recipe
            return thirdPageVC
        default:
            print("DEFAULT")
            return UIViewController()
        }
    }

}

extension CookbookPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard orderedViewControllers.count > previousIndex else { return nil }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < orderedViewControllers.count else { return nil }
        return orderedViewControllers[nextIndex]
    }
    
    
}
