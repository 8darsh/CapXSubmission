//
//  Stock.swift
//  CapXSubmission
//
//  Created by Adarsh Singh on 10/10/24.
//

import Foundation

struct StockData: Codable{
    let metaData: MetaData
    let timeSeriesDaily: [String: TimeSeriesData]
    
    enum CodingKeys: String, CodingKey{
        case metaData = "Meta Data"
        case timeSeriesDaily = "Time Series (Daily)"
        
    }
    
    func fetchStockDataForTodayAndYesterday(lastRefreshed: String) -> (todayData: TimeSeriesData?, yesterdayData: TimeSeriesData?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let refrehedDate = dateFormatter.date(from: lastRefreshed) ?? Date.now
        // Get today's date
        let today = Calendar.current.date(byAdding: .day, value: 0, to: refrehedDate)!
        let todayString = dateFormatter.string(from: today)

        // Get yesterday's date
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let yesterdayString = dateFormatter.string(from: yesterday)

        // Access data for today and yesterday
        let todayData = timeSeriesDaily[todayString]
        
        let yesterdayData = timeSeriesDaily[yesterdayString]

        return (todayData, yesterdayData)
    }
}
struct MetaData: Codable{
    
    let symbol: String
    let lastRefreshed: String
    
    enum CodingKeys: String, CodingKey{
        case symbol = "2. Symbol"
        case lastRefreshed = "3. Last Refreshed"
       
    }
    
}

struct TimeSeriesData: Codable{
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String

    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}
