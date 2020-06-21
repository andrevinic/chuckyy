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
    lazy var headerViewController = FactHeaderViewController(viewModel: self.viewModel)
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .darkGray
        return collectionView
    }()
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView? {
        didSet {
            categoriesCollectionView?.backgroundColor = .blue
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
        self.title = "fatos do Chuck!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        self.setupCollectionView()
        self.setupSearch()
    }
    
    private func setupSearch() {
        self.setupSearchView()
        self.setupSearchBinds()
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
            .subscribe(onNext: { [unowned self] (query) in
                self.searchController.searchBar.text = query
                self.searchController.searchBar.becomeFirstResponder()
                self.viewModel.clearData()
                self.viewModel.fetch(with: query)
                self.showCollectionView()
            }).disposed(by: disposeBag)
        
        self.searchController
            .searchBar
            .rx
            .text
            .orEmpty
            .filter({$0.isEmpty})
            .subscribe(onNext: { [weak self] (_) in
                self?.hideCollectionView()
            }).disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        setupCollectionViewUI()
        setupCollectionViewBinds()
    }
    
    private func setupCollectionViewUI() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.delegate = self
        self.collectionView.register(cellType: FactCollectionViewCell.self)
        self.view.backgroundColor = .white
        self.collectionView.alpha = 0.0
        self.view.addSubview(self.collectionView)
        
        constrain(self.view, self.collectionView) { (view, collectionView) in
            collectionView.top == view.top
            collectionView.leading == view.safeAreaLayoutGuide.leading
            collectionView.trailing == view.safeAreaLayoutGuide.trailing
            collectionView.bottom == view.bottom
        }
    }
    
    private func showCollectionView() {
        self.collectionView.alpha = 1.0
    }
    
    private func hideCollectionView() {
        self.collectionView.alpha = 0.0
    }
    
    private func setupCollectionViewBinds() {
        self.viewModel
            .onFetched
            .drive(self.collectionView
                .rx
                .items(cellIdentifier: FactCollectionViewCell.className, cellType: FactCollectionViewCell.self)) { _, element, cell in
                    cell.bindData(element)
                    
        }.disposed(by: disposeBag)
    }
    
}

extension FactMainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = width
        
        return CGSize(width: width, height: height)
    }
}
