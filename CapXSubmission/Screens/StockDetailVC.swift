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
    
    private var viewModel = StockViewModel()
    
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
        configVC()
        configureUI()
        initViewModel()
        
        observeEvent()
        
    }
    
    func configVC(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
    }
    func configureUI(){
        
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
            stockPriceDisplay.heightAnchor.constraint(equalToConstant: 20),
            
            stockPrice.topAnchor.constraint(equalTo: stockPriceDisplay.bottomAnchor, constant: 10),
            stockPrice.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stockPrice.widthAnchor.constraint(equalToConstant: 100),
            stockPrice.heightAnchor.constraint(equalToConstant: 10),
            
            percentageChangeDisplay.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            percentageChangeDisplay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            percentageChangeDisplay.widthAnchor.constraint(equalToConstant: 100),
            percentageChangeDisplay.heightAnchor.constraint(equalToConstant: 20),
            
            percentageChange.topAnchor.constraint(equalTo: percentageChangeDisplay.bottomAnchor, constant: 10),
            percentageChange.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            percentageChange.widthAnchor.constraint(equalToConstant: 100),
            percentageChange.heightAnchor.constraint(equalToConstant: 10)
            
        ])
    }
    
    @objc func dismissVC(){
        self.dismiss(animated: true)
    }
    
    func configureUIElements(with stock: StockData){
        title = stockSymbol
        stockPrice.text = stock.fetchStockDataForTodayAndYesterday(lastRefreshed: stock.metaData.lastRefreshed).todayData?.close
        
        percentageChange.text = viewModel.calculatePercentageChange(with: stock.fetchStockDataForTodayAndYesterday(lastRefreshed: stock.metaData.lastRefreshed).todayData?.close ?? "0", and: stock.fetchStockDataForTodayAndYesterday(lastRefreshed: stock.metaData.lastRefreshed).yesterdayData?.close ?? "0").0
        
        percentageChange.textColor = viewModel.calculatePercentageChange(with: stock.fetchStockDataForTodayAndYesterday(lastRefreshed: stock.metaData.lastRefreshed).todayData?.close ?? "0", and: stock.fetchStockDataForTodayAndYesterday(lastRefreshed: stock.metaData.lastRefreshed).yesterdayData?.close ?? "0").1
 
        
    }
    
    func initViewModel(){
        viewModel.getStock(symbol: stockSymbol)
    }
    
    func observeEvent(){
        viewModel.eventHandler = { [weak self] event in
            
            guard let self else {return}
            
            switch event {
            case .dataLoded(let stock):
                DispatchQueue.main.async {
                    self.configureUIElements(with: stock)
                }
                
            case .error(let error):
                presentErrorOnMainThread(with: error?.rawValue ?? "Something went wrong")
                

            }
        }
    }
    
}
#Preview {
    StockDetailVC(stockSymbol: "AAPL")
}
    

