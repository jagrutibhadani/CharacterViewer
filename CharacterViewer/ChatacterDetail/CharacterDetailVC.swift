//
//  CharactorDetail.swift
//  Simpsonsviewer
//
//  Created by Jagruti Patel CW on 6/13/23.
//

import UIKit


class CharacterDetailVC: UIViewController {
    private lazy var stackView: UIStackView = {
        let stackVew = UIStackView()
        stackVew.spacing = 10
        stackVew.axis = .vertical
        return stackVew        
    }()
    
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollVew = UIScrollView()
        return scrollVew
    }()
    
    
    private lazy var viewModel: CharacterDetailViewModel? = {
        let viewModel = CharacterDetailViewModel(apiClient: APIClient())
        return viewModel
    }()
    
    lazy var loadingIndicatorView: LoadingIndicatorView = {
        let loadingView = LoadingIndicatorView(frame: self.view.frame)
        return loadingView
    }()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        addStackView()
        showDetails()
    }
    
    private func showDetails() {
        viewModel?.bindModelToDetailViewController = { [weak self] in
            self?.clearStackView()
            self?.addCharacterImage()
            self?.addTitle()
            self?.addDescription()
            self?.loadingIndicatorView.hideSpinner()
        }
    }
    
    private func addStackView() {
        
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true;
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true;
        
        self.scrollView.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10).isActive = true;
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true;
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 10).isActive = true;
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true;
        self.stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
    }
    
    private func addCharacterImage() {
        let image = UIImage(named: "placeHolder")
        characterImageView = UIImageView(image: image)
        if let imageData = viewModel?.characterImageData {
            characterImageView = UIImageView(image: UIImage(data: imageData))
        }        
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.contentMode = .scaleAspectFit
        self.stackView.addArrangedSubview(characterImageView)
    }
    
    private func addTitle() {
        let titleLbl = UILabel()
        titleLbl.text = viewModel?.characterTitle
        titleLbl.font = .boldSystemFont(ofSize: 24)
        titleLbl.textAlignment = .center
        titleLbl.numberOfLines = 0
        stackView.addArrangedSubview(titleLbl)
    }
    
    private func addDescription() {
        let descriptionLbl = UILabel()
        descriptionLbl.text = viewModel?.characterDescription
        descriptionLbl.font = .systemFont(ofSize: 20)
        descriptionLbl.textAlignment = .center
        descriptionLbl.numberOfLines = 0
        stackView.addArrangedSubview(descriptionLbl)
    }
    
    private func clearStackView() {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
}
extension CharacterDetailVC: CharacterSelectionDelegate {
    func selectedCharacter(index: Int) {
        self.clearStackView()
        viewModel?.selectedIndex = index
        loadingIndicatorView.showSpinner(self.view)
        viewModel?.getCharacterImage()
        showDetails()
    }
}

extension CharacterDetailVC: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
