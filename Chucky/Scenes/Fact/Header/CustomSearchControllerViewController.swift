//
//  CustomSearchControllerViewController.swift
//  Chucky
//
//  Created by Andre Nogueira on 20/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        setShowsCancelButton(false, animated: false)
    }
}

class CustomSearchControllerViewController: UISearchController, UISearchBarDelegate {

    lazy var _searchBar: CustomSearchBar = {
          [unowned self] in
        let result = CustomSearchBar(frame: .zero)
          result.delegate = self

          return result
      }()

      override var searchBar: UISearchBar {
          get {
              return _searchBar
          }
      }

}
