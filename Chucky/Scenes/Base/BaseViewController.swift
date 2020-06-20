//
//  BaseViewController.swift
//  Chucky
//
//  Created by Andre Nogueira on 15/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import NotificationBannerSwift

class BaseViewController: UIViewController {

    internal var baseViewModel: BaseViewModelContract? {
        return nil
    }
    
    internal let disposeBag = DisposeBag()
    internal let hud = CustomLoadingView()
    private var banner: NotificationBanner?

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
      
      public init() {
          super.init(nibName: nil, bundle: nil)
      }

      @available(*, unavailable,
      message: "Loading this view controller from a nib is unsupported."
      )
      public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
          super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      }
      
      @available(*, unavailable,
      message: "Loading this view controller from a nib is unsupported."
      )
      public required init?(coder aDecoder: NSCoder) {
          fatalError("Loading this view controller from a nib is unsupported.")
      }

      override func viewDidLoad() {
          super.viewDidLoad()
          setup()
      }
    
    private func setup() {
       self.setupLoading()
       self.bindLoading()
       self.bindError()
    }
    
    internal func setupLoading() {
           self.view.addSubview(hud)
           hud.translatesAutoresizingMaskIntoConstraints = false
           self.view.addConstraints([
               hud.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
               hud.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
               hud.widthAnchor.constraint(equalToConstant: 80),
               hud.heightAnchor.constraint(equalToConstant: 80)
           ])
           hud.isHidden = true
       }
       
       internal func bindLoading() {
           
           baseViewModel?
               .loading
               .drive(onNext: { [unowned self] isLoading in
                   if isLoading {
                       self.hud.isHidden = false
                   } else {
                       self.hud.isHidden = true
                   }
               }).disposed(by: disposeBag)
       }
       
       internal func bindError() {
           
           baseViewModel?
               .onError
               .drive(onNext: { [unowned self] error in
                   self.banner?.dismiss()
                   self.banner = NotificationBanner(title: nil,
                                                    subtitle: error.errorMessage,
                                                    leftView: nil,
                                                    rightView: nil,
                                                    style: .danger,
                                                    colors: nil)
                   self.banner?.show()
               }).disposed(by: disposeBag)
       }
       
       deinit {
           print("🅲 the \(self) was deinitalized")
       }

}

