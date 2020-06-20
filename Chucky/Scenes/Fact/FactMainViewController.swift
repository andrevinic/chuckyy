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

class FactViewController: BaseViewController {

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
    lazy var searchViewController = SearchViewController(viewModel: self.viewModel)
    
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
//
//    private let collectionView: UICollectionView = {
//        let viewLayout = UICollectionViewFlowLayout()
//        viewLayout.scrollDirection = .vertical
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
//        collectionView.backgroundColor = .darkGray
//        return collectionView
//    }()
    
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
//        self.setupCollectionView()
        self.setupTableView()
        self.setupSearchView()
//        self.bindStyles()
        self.fetchCategories()
    }
    private func fetchCategories() {
        self.viewModel.categories()
    }
    
    @available(iOS 11.0, *)
    private func setupSearchView() {
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "busque o que desejar"
//        searchController.searchBar.delegate = self
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//        self.navigationController?.navigationBar.backgroundColor = .darkGray
//        self.searchController.searchBar.backgroundColor = .darkGray
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Pesquisar"
        searchController.searchBar.delegate = self
        searchController.searchBar.accessibilityIdentifier = "repository-search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        guard let containerHeader = self.containerSearchHeader else { return }
        containerHeader.addSubview(self.searchViewController.view)

        constrain(self.searchViewController.view, containerHeader) { (view, container) in
            view.height == container.height
            view.width == container.width
            view.leading == container.leading
            view.trailing == container.trailing
        
        }
        
    }
    
    private func setupTableView() {
        guard let tableView = self.tableView else { return }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: CategoriesTableViewCell.self)
        self.view.addSubview(tableView)

        self.viewModel
            .onCategories
            .drive(onNext: { _ in
                tableView.reloadData()
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

extension FactViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = width

       return CGSize(width: width, height: height)
    }
}

extension FactViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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

extension FactViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories().count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: CategoriesTableViewCell.self, for: indexPath)
        cell.set(with: self.category(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: true)
        let category = self.category(indexPath: indexPath)
        self.searchController.searchBar.text = category
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.searchController.searchBar.text = ""
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        self.searchController.searchBar.text = ""
    }
    
}

extension FactViewController: UISearchBarDelegate {
    
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
