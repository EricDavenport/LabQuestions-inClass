//
//  LabQuestionsTests.swift
//  LabQuestionsTests
//
//  Created by Alex Paul on 12/10/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import XCTest
@testable import LabQuestions

struct CreatedLab: Codable {
  let title: String
  let createdAt: String
}

class LabQuestionsTests: XCTestCase {
  func testPostLabQuestion() {
    // arrange
    let title = "First attempt to post a question - Eri D."
    let labName = "Image Lab"
    let description = "Hacing difficulties displaying comic strips to imaghe view. I am obtaining the information. But i can not fill in my variable."
    let createdAt = String.getISOTimestamp()  // getIDOTimestamp is an extension we created on String
    
    let lab = PostedQuestion(title: title, labName: labName, description: description, createdAt: createdAt)
    
    
    let data = try! JSONEncoder().encode(lab)
    
    
    let exp = XCTestExpectation(description: "lab posted successfully")
    
    let url = URL(string: "https://5df04c1302b2d90014e1bd66.mockapi.io/questions")!
    
    var request = URLRequest(url: url)  // 1. url
    request.httpMethod = "POST"  // "GET"  2. HTTP Method Type
    request.httpBody = data       // Data sending to web API
    
    // required to be valid JSON data being uploaded
    request.addValue("application/json", forHTTPHeaderField: "Content-Type") // type of data / multimedia sending
    
    // act
    NetworkHelper.shared.performDataTask(with: request) { (result) in
      switch result {
      case .failure(let appError):
        XCTFail("failed with error: \(appError)")
      case .success(let data):
        // assert
        let createdlab = try! JSONDecoder().decode(CreatedLab.self, from: data)
        XCTAssertEqual(title, createdlab.title)
        exp.fulfill()
      }
    }
    
    wait(for: [exp], timeout: 5.0)
  }
}
