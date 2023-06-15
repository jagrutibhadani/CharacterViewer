//
//  ViewController.swift
//  Simpsonsviewer
//
//  Created by Jagruti Patel CW on 6/13/23.
//

import UIKit
protocol CharacterSelectionDelegate: AnyObject {
    func selectedCharacter(index: Int)
}

class CharacterListVC: UITableViewController {

    private var characterNames: [String] = []
    private var filteredCharacterNames: [String] = []
    private var viewModel: CharacterListViewModel? = nil

    @IBOutlet weak var searchBar: UISearchBar!
    weak var delegate: CharacterSelectionDelegate?
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        var activityVC = UIActivityIndicatorView(style: .large)
        activityVC.startAnimating()
        return activityVC
    }()
    
    lazy var loadingIndicatorView: LoadingIndicatorView = {
        let loadingView = LoadingIndicatorView(frame: self.tableView.frame)
        return loadingView
    }()    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CharacterListViewModel(apiClient: APIClient())
        loadCharacters()
    }
    
    func loadCharacters() {
        loadingIndicatorView.showSpinner(self.tableView)
        viewModel?.bindModelToListViewController = { [weak self] in
            self?.characterNames = self?.viewModel?.charactorNames ?? []
            self?.filteredCharacterNames = self?.characterNames ?? []
            self?.loadingIndicatorView.hideSpinner()
            self?.tableView.reloadData()
            self?.delegate?.selectedCharacter(index: 0)
            self?.title = self?.viewModel?.heading ?? ""
        }
    }
    
    // MARK: tableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCharacterNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characters", for: indexPath)
        cell.textLabel?.text =  filteredCharacterNames[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let characterDetailVC = delegate as? CharacterDetailVC,
           let detailNavigationController = characterDetailVC.navigationController {
            delegate?.selectedCharacter(index: indexPath.row)
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }

}

extension CharacterListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCharacterNames = searchText.isEmpty ? self.characterNames: self.characterNames.filter { $0.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}
