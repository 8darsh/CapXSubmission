//
//  NetworkManager.swift
//  CapXSubmission
//
//  Created by Adarsh Singh on 10/10/24.
//

import Foundation

enum apiUrl: String{
    case baseUrl = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol="
    case endUrl = "&apikey=demo"
}

class NetworkManager{
    
    //Created Singleton Object
    static let shared = NetworkManager()
    init(){}
    
    func getStockData(with symbol: String, completed: @escaping(Result<StockData,GFError>) -> Void){
        let endPoint = apiUrl.baseUrl.rawValue + symbol + apiUrl.endUrl.rawValue
        
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidSymbol))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            
            if error != nil{
                completed(.failure(.unableToCompleteRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else{
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data else{
                completed(.failure(.invalidData))
                return
            }
            
            
            do{
                let decoder = JSONDecoder()
                let stock = try decoder.decode(StockData.self, from: data)
                completed(.success(stock))
            }catch{
                completed(.failure(.invalidData))
            }
            
            
        }
        task.resume()
    }
}
