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

    private let searchController = UISearchController(searchResultsController: nil)
   
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .darkGray
        return tableView
    }()
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .darkGray
        return collectionView
    }()
    
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
        self.setupCollectionView()
        self.setupTableView()

        self.setupSearchView()
        self.bindStyles()
        self.fetchCategories()
    }
    private func fetchCategories() {
        self.viewModel.categories()
    }
    
    @available(iOS 11.0, *)
    private func setupSearchView() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "busque o que desejar"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        self.navigationController?.navigationBar.backgroundColor = .darkGray
        self.searchController.searchBar.backgroundColor = .darkGray
        
    }
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(cellType: FactCollectionViewCell.self)
        self.view.backgroundColor = .white
        self.collectionView.alpha = 0.0
        self.view.addSubview(self.collectionView)
        
        self.viewModel
            .onFetched
            .drive(onNext: { [unowned self] in
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)

    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: CategoriesTableViewCell.self)
        self.view.addSubview(self.tableView)

        self.viewModel
            .onCategories
            .drive(onNext: { _ in
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
        
    }
    
    @available(iOS 11.0, *)
    private func bindStyles() {
        
        self.collectionView.tintColor = .blue
        
        constrain(view, collectionView) { (view, collectionView) in
            collectionView.top == view.top
            collectionView.bottom == view.safeAreaLayoutGuide.bottom
            collectionView.left == view.safeAreaLayoutGuide.left
            collectionView.right == view.safeAreaLayoutGuide.right
        }
        
        constrain(view, tableView) { (view, tableView) in
                   tableView.top == view.top
                   tableView.bottom == view.safeAreaLayoutGuide.bottom
                   tableView.left == view.safeAreaLayoutGuide.left
                   tableView.right == view.safeAreaLayoutGuide.right
               }
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

    private func hideCollectionView() {
        self.collectionView.alpha = 0.0
        self.tableView.alpha = 1.0
    }
    
    private func hideTableView() {
        self.collectionView.alpha = 1.0
        self.tableView.alpha = 0.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.layoutSubviews()
        self.tableView.layoutIfNeeded()
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
        hideTableView()
        self.viewModel.clearData()
        guard let text = searchBar.text, !text.isEmpty else {
            hideCollectionView()
            return
        }
        self.viewModel.fetch(with: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.isEmpty {
            return
        }
        self.viewModel.clearData()
        hideCollectionView()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
}
