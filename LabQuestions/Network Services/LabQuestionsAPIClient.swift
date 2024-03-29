//
//  LabQuestionsAPIClient.swift
//  LabQuestions
//
//  Created by Eric Davenport on 12/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct LabQuestionsAPIClient {
  static func FetchQuestions(completion: @escaping (Result<[Questions],AppError>) -> ()) {
   
    
    let urlString = "https://5df04c1302b2d90014e1bd66.mockapi.io/questions"
    
    // cresate a url from the endpointString
    guard let url = URL(string: urlString) else {
      completion(.failure(.badURL(urlString)))
      return
    }
    
    // make URLRequest object to pass to the netwrkHelper
    let request = URLRequest(url: url)
    
    // set the http method, e.g GET, POST, DELETE, PUT, UPDATE ....
    // request.httpMethod = "POST"
    // request.httpBody = data
    
    // this is required when posting so we inform the POST request of the data type
    // oif we do not provide the header value as "application/json"
    // we will get a decoding error when attempting to decode the JSON
    // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    NetworkHelper.shared.performDataTask(with: request) { (result) in
      switch result {
      case .failure(let appError):
        completion(.failure(appError))
      case .success(let data):
        do {
          // JSONDecoder() - used to convert web data to swift models
          // JSONEncoder() - used to convert Swift model to data
          let question = try JSONDecoder().decode([Questions].self, from: data)
          completion(.success(question))
        } catch {
          completion(.failure(.decodingError(error)))
        }
      }
    }
  }
  
  static func postQuestion(question: PostedQuestion, completion: @escaping (Result<Bool,AppError>) -> ()) {
    
    let endpointURLString = "https://5df04c1302b2d90014e1bd66.mockapi.io/questions"
    
    guard let url = URL(string: endpointURLString) else {
      completion(.failure(.badURL(endpointURLString)))
      return
    }
    
    // need to convert PostedQuestion to Data
    do {
      let data = try JSONEncoder().encode(question)
      
      // configure our URLRequest
      // url
      var request = URLRequest(url: url)
      // type of http Method
      request.httpMethod = "POST"
      // type of data
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      
      // data being sent to web api
      request.httpBody = data
      
      // exwecute POST request
      
      NetworkHelper.shared.performDataTask(with: request) { (result) in
        switch result {
        case .failure(let appError):
          completion(.failure(.networkClientError(appError)))
        case .success:
          completion(.success(true))
        }
      }
    } catch {
      completion(.failure(.encodingError(error)))
    }
    
  }
  
  
}
