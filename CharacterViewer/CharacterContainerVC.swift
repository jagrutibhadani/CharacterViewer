//
//  SplitViewController.swift
//  Simpsonsviewer
//
//  Created by Jagruti Patel CW on 6/13/23.
//

import UIKit
class CharacterContainerVC: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        guard
            let leftNavController = self.viewControllers.first as? UINavigationController,
            let masterViewController = leftNavController.viewControllers.first as? CharacterListVC,
            let detailViewController = (self.viewControllers.last as? UINavigationController)?.topViewController as? CharacterDetailVC
        else { fatalError() }
        
        self.preferredDisplayMode = .oneOverSecondary
        self.viewControllers = [masterViewController, detailViewController]
        masterViewController.delegate = detailViewController
        detailViewController.navigationItem.leftItemsSupplementBackButton = false        
    }

    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
