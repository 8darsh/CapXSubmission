//
//  viewModel.swift
//  CapXSubmission
//
//  Created by Adarsh Singh on 10/10/24.
//

import Foundation
import UIKit

final class viewModel{
    
    let stockSymbol: String!
    var stock: StockData?
    var eventHandler: ((_ event: Event) -> Void)?
    
    init(stockSymbol: String) {
        self.stockSymbol = stockSymbol
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    
    func getStock(symbol: String){
        
        NetworkManager.shared.getStockData(with: symbol) { [weak self] result in
            
            guard let self else {return}
            
            switch result {
            case .success(let stock):
                
                self.stock = stock
            case .failure(let error):
                self.eventHandler?(.error(error))

            }
        }
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
    
}

extension viewModel{
    enum Event{
        case error(Error?)
    }
}
