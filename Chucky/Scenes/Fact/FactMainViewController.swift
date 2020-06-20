//
//  FactViewController.swift
//  Chucky
//
//  Created by Andre Nogueira on 15/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cartography

class FactMainViewController: BaseViewController {

    @IBOutlet weak var containerSearchHeader: UIView? {
        didSet {
            containerSearchHeader?.backgroundColor = .clear
        }
    }
    private var searchController = UISearchController(searchResultsController: nil) {
        didSet {
            self.searchController.searchBar.showsCancelButton = false;

        }
    }
    
    lazy var headerViewController = FactHeaderViewController(viewModel: self.viewModel)
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView? {
        didSet {
            categoriesCollectionView?.backgroundColor = .blue
        }
    }
    @IBOutlet weak var tableView: UITableView? {
        didSet {
            tableView?.backgroundColor = .darkGray
            tableView?.isHidden = true
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    override var baseViewModel: BaseViewModelContract? {
        return self.viewModel
    }
    
    private let viewModel: FactViewModel
    
    init(viewModel: FactViewModel) {
        self.viewModel = viewModel
        super.init()
        self.title = "Buscar"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    private func setup() {
        self.setupSearchView()
        self.fetchCategories()
    }
    private func fetchCategories() {
        self.viewModel.categories()
    }
    
    @available(iOS 11.0, *)
    private func setupSearchView() {

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Pesquisar"
        searchController.searchBar.delegate = self
        searchController.searchBar.accessibilityIdentifier = "repository-search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        guard let containerHeader = self.containerSearchHeader else { return }
        containerHeader.addSubview(self.headerViewController.view)

        constrain(self.headerViewController.view, containerHeader) { (view, container) in
            view.height == container.height
            view.width == container.width
            view.leading == container.leading
            view.trailing == container.trailing
        
        }
       
        self.headerViewController
        .outSearch
        .asObservable()
        .subscribe(onNext: { (text) in
            self.searchController.searchBar.text = text
            self.searchBarTextDidEndEditing(self.searchController.searchBar)

        }).disposed(by: disposeBag)

    }
    

    private func fact(indexPath: IndexPath) -> Fact? {
        if self.viewModel.facts.isEmpty {
            return nil
        }
        return self.viewModel.facts[indexPath.row]
    }
    
    private func category(indexPath: IndexPath) -> String {
        return self.viewModel.categoriesList[indexPath.row]
    }
    
    private func categories() -> [String] {
        return self.viewModel.categoriesList
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView?.layoutSubviews()
        self.tableView?.layoutIfNeeded()
    }
}

extension FactMainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = width

       return CGSize(width: width, height: height)
    }
}

extension FactMainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.facts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: FactCollectionViewCell.self, for: indexPath)
        
        if let fact = self.fact(indexPath: indexPath) {
            cell.set(with: fact)
        }
        return cell
    }
    
}


extension FactMainViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        hideTableView()
        self.viewModel.clearData()
       
        guard let text = searchBar.text, !text.isEmpty else {
//            hideCollectionView()
            return
        }
        
        self.viewModel.fetch(with: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text, text.isEmpty {
            return
        }
        
        self.viewModel.clearData()
//        hideCollectionView()
        DispatchQueue.main.async {
            self.tableView?.reloadData()
            self.tableView?.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
}
