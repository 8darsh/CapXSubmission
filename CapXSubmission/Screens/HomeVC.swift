//
//  HomeVC.swift
//  CapXSubmission
//
//  Created by Adarsh Singh on 10/10/24.
//

import UIKit

class HomeVC: UIViewController {
    
    let stockSearchTextField = GFTextField(textAlignment: .center)
    let searchButton = GFButton(backgroundColor: .systemGreen, title: "Get Stock")
    
    var isStockSymbolEntered: Bool{
        return !stockSearchTextField.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        configureUI()
        configureSearchButton()
    }
    
    
    
    func configureUI(){
        view.addSubview(stockSearchTextField)
        view.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            stockSearchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            stockSearchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            stockSearchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stockSearchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            searchButton.topAnchor.constraint(equalTo: stockSearchTextField.bottomAnchor, constant: 40),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureSearchButton(){
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    @objc func searchButtonTapped(){
        guard isStockSymbolEntered else{
            presentErrorOnMainThread(with: "Enter the stock")
            return
        }
        print(stockSearchTextField.text!)
        let stockDetailVC = StockDetailVC(stockSymbol: stockSearchTextField.text!)
        let navController = UINavigationController(rootViewController: stockDetailVC)
        
        present(navController, animated: true)
    }
    

    
}
