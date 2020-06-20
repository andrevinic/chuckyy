//
//  SearchViewController.swift
//  Chucky
//
//  Created by Andre Nogueira on 20/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Cartography

class SearchViewController: BaseViewController {

    let collectionViewCategories: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    private let viewModel: FactViewModel
    
    init(viewModel: FactViewModel) {
        self.viewModel = viewModel
        super.init()
        self.title = "Buscar"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProperties()
        self.viewModel.categories()
        
        self.viewModel.onCategories
            .drive(collectionViewCategories
            .rx
            .items(cellIdentifier: CategoryCollectionViewCell.className, cellType: CategoryCollectionViewCell.self)) {
                _, element, cell in
                cell.bindData(element)
        }.disposed(by: self.disposeBag)
    }
    
    func setupProperties() {
        self.collectionViewCategories.register(cellType: CategoryCollectionViewCell.self)
        self.collectionViewCategories.delegate = self

        self.view.addSubview(collectionViewCategories)
        
        constrain(view, self.collectionViewCategories) { (view, collection) in
            collection.trailing == view.safeAreaLayoutGuide.trailing
            collection.leading == view.safeAreaLayoutGuide.leading
            collection.top == view.top
            collection.bottom == view.bottom
        }
        
    }

}

extension SearchViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        cell.alpha = 0.0
        UIView.animate(withDuration: 0.2, delay: (0.02 * Double(indexPath.row)), options: .curveLinear, animations: {
            cell.alpha = 1.0
        }, completion: nil)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//         return CGSize(width: 100, height: 100)
//     }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    //--------------------------------------------------------------------------------

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }

    //--------------------------------------------------------------------------------

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: ( self.collectionViewCategories.frame.size.width - 120 ) / 2,
            height: 60
        )
    }

    //--------------------------------------------------------------------------------

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
