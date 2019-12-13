//
//  PostedQuestion.swift
//  LabQuestions
//
//  Created by Eric Davenport on 12/13/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct PostedQuestion: Encodable {
  
  let title: String
  let labName: String
  let description: String
  let createdAt: String   // timestamp of the date of the created Question
  
  
}
