//
//  GFError.swift
//  CapXSubmission
//
//  Created by Adarsh Singh on 10/10/24.
//

import Foundation

enum GFError: String, Error{
    case invalidSymbol = "This username created invalid request. Please try again"
    case unableToCompleteRequest = "Unable to complete your request. Please check your Internet."
    case invalidResponse = "Invalid Response from the server. Try again later."
    case invalidData = "The data recieved from the server was invalid. Please try again"
}
