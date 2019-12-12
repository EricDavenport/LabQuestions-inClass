//
//  Question.swift
//  LabQuestions
//
//  Created by Eric Davenport on 12/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct Questions: Codable {
  let id: String
  //let createdAt: String  // creates a date stamp
  let name: String   // random user name
  let avatar: String  // random user avatar
  let title: String
  let description: String
  let labName: String
  
}
