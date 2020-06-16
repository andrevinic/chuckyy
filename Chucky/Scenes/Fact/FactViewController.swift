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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .green
        return collectionView
    }()
    
    override var baseViewModel: BaseViewModelContract? {
        return self.viewModel
    }
    
    private let viewModel: FactViewModel
    
    init(viewModel: FactViewModel) {
        self.viewModel = viewModel
        super.init()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperties()

        self.bindStyles()
    }
    
    private func bindProperties() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(cellType: FactCollectionViewCell.self)
    }
    private func bindStyles() {
        
        self.collectionView.tintColor = .blue
        
        constrain(view, collectionView) { (view, collectionView) in
            collectionView.top == view.safeAreaLayoutGuide.top
            collectionView.bottom == view.safeAreaLayoutGuide.bottom
            collectionView.left == view.safeAreaLayoutGuide.left
            collectionView.right == view.safeAreaLayoutGuide.right
        }
    }

}

extension FactViewController: UICollectionViewDelegate {
    
}

extension FactViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: FactCollectionViewCell.self, for: indexPath)

        
        return cell
    }
    
}
