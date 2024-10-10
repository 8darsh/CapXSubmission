//
//  StockDetailVC.swift
//  CapXSubmission
//
//  Created by Adarsh Singh on 10/10/24.
//

import UIKit

class StockDetailVC: UIViewController {
    
    let stockPrice:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .bold)
        
        return label
    }()
    let percentageChange:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .bold)
       
        return label
    }()
    
    let stockPriceDisplay:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "Stock price"
        return label
    }()
    
    let percentageChangeDisplay:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "Change"
        return label
    }()
    
    var stockSymbol: String!
    
    init(stockSymbol: String) {
        super.init(nibName: nil, bundle: nil)
        self.stockSymbol = stockSymbol
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureUI()
        
        getStock(symbol: stockSymbol)
    }
    
    func configureUI(){
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        
        view.addSubview(stockPrice)
        view.addSubview(percentageChange)
        view.addSubview(stockPriceDisplay)
        view.addSubview(percentageChangeDisplay)
        
        stockPrice.translatesAutoresizingMaskIntoConstraints = false
        percentageChange.translatesAutoresizingMaskIntoConstraints = false
        stockPriceDisplay.translatesAutoresizingMaskIntoConstraints = false
        percentageChangeDisplay.translatesAutoresizingMaskIntoConstraints = false
        

        NSLayoutConstraint.activate([
            
            stockPriceDisplay.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stockPriceDisplay.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stockPriceDisplay.widthAnchor.constraint(equalToConstant: 100),
            stockPriceDisplay.heightAnchor.constraint(equalToConstant: 40),
            
            stockPrice.topAnchor.constraint(equalTo: stockPriceDisplay.bottomAnchor, constant: 10),
            stockPrice.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stockPrice.widthAnchor.constraint(equalToConstant: 100),
            stockPrice.heightAnchor.constraint(equalToConstant: 40),
            
            percentageChangeDisplay.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            percentageChangeDisplay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            percentageChangeDisplay.widthAnchor.constraint(equalToConstant: 100),
            percentageChangeDisplay.heightAnchor.constraint(equalToConstant: 40),
            
            percentageChange.topAnchor.constraint(equalTo: percentageChangeDisplay.bottomAnchor, constant: 10),
            percentageChange.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            percentageChange.widthAnchor.constraint(equalToConstant: 100),
            percentageChange.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    @objc func dismissVC(){
        self.dismiss(animated: true)
    }
    
    func configureUIElements(with stock: StockData){
        title = stockSymbol
        stockPrice.text = stock.fetchStockDataForTodayAndYesterday().todayData?.close
        percentageChange.text = calculatePercentageChange(with: stock.fetchStockDataForTodayAndYesterday().todayData?.close ?? "0", and: stock.fetchStockDataForTodayAndYesterday().yesterdayData?.close ?? "0")
        
    }
    
    
    func calculatePercentageChange(with today: String, and yesterday: String) -> String{
        let trimmedToday = today.trimmingCharacters(in: .whitespaces)
        let trimmedYesterday = yesterday.trimmingCharacters(in: .whitespaces)

        guard let todayCloseVal = Double(trimmedToday),
              let yesterdayCloseVal = Double(trimmedYesterday),
              yesterdayCloseVal != 0 else {
            return "N/A" // Return a placeholder if conversion fails or yesterday's value is zero
        }

        // Calculate the percentage change
        let percentageChange = ((todayCloseVal - yesterdayCloseVal) / yesterdayCloseVal) * 100

        // Format and return the result
        return String(format: "%.2f%%", percentageChange)
    }
    func getStock(symbol: String){
        
        NetworkManager.shared.getStockData(with: "IBM") { [weak self] result in
            
            guard let self else {return}
            
            switch result {
            case .success(let stock):
                print(stock)
                DispatchQueue.main.async {
                    self.configureUIElements(with: stock)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Bad Happend", message: error.rawValue, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel)
                    ac.addAction(action)
                    self.present(ac, animated: true)
                }

            }
        }
    }
    

}
