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
        self.setupSearchView()
        self.bindStyles()

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
        self.view.addSubview(self.collectionView)
        
        self.viewModel
            .onFetched
            .drive(onNext: { [unowned self] in
                self.collectionView.reloadData()
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
    }
    
    private func fact(indexPath: IndexPath) -> Fact? {
        if self.viewModel.facts.isEmpty {
            return nil
        }
        return self.viewModel.facts[indexPath.row]
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

extension FactViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.viewModel.clearData()
        guard let text = searchBar.text else {
            return
        }
        self.viewModel.fetch(with: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.clearData()
        self.collectionView.reloadData()

    }
}
