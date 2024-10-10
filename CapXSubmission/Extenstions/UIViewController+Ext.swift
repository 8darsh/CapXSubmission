//
//  UIViewController+Ext.swift
//  CapXSubmission
//
//  Created by Adarsh Singh on 10/10/24.
//

import UIKit

extension UIViewController{
    
    func presentErrorOnMainThread(with error: String){
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Bad Stuff Happend", message: error, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel)
            ac.addAction(action)
            self.present(ac, animated: true)
        }
    }
}
