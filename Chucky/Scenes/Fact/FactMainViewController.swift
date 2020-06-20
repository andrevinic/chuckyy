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
    
    private var searchController = CustomSearchControllerViewController()
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .darkGray
        return collectionView
    }()
    
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
        self.setupCollectionView()
        self.setupSearchBinds()
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
        
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.delegate = self
        self.collectionView.register(cellType: FactCollectionViewCell.self)
        self.view.backgroundColor = .white
        self.collectionView.alpha = 0.0
        self.view.addSubview(self.collectionView)
        
        self.viewModel
            .onFetched
            .drive(self.collectionView
                .rx
                .items(cellIdentifier: FactCollectionViewCell.className, cellType: FactCollectionViewCell.self)) { _, element, cell in
                    cell.bindData(element)
                    
        }.disposed(by: disposeBag)
        
    }
    
    private func setupSearchBinds() {
        
        let query = self.searchController
            .searchBar
            .rx
            .text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({!$0.isEmpty})
            .asObservable()
        
        Observable.merge(
            self.headerViewController
                .outSearch
                .asObservable(),
            query)
            .subscribe(onNext: { (query) in
                self.searchController.searchBar.text = query
                self.searchController.searchBar.becomeFirstResponder()
                self.viewModel.clearData()
                self.viewModel.fetch(with: query)
            }).disposed(by: disposeBag)
        
        self.searchController
            .searchBar
            .rx
            .cancelButtonClicked
            .subscribe(onNext: { (_) in
                print("test")
            }).disposed(by: disposeBag)
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

extension FactMainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = width
        
        return CGSize(width: width, height: height)
    }
}
