//
//  CreateQuestionController.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/11/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class CreateQuestionController: UIViewController {
  
  
  @IBOutlet weak var titleTextField: UITextField!
  
  @IBOutlet weak var questionTestView: UITextView!
  @IBOutlet weak var labPickerView: UIPickerView!
  
  // labName will be the current selectd row in ticker row
  private var labName: String?
  
  private let labs = ["Concurrency", "Comic", "ParsingJSON", "Weather", "Color", "User", "Image and Error Handling", "Intro into Unit testing - Jokes, Star Wars, Trivia"].sorted() //ascending  buy defsult a-z
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // configure the picker view
    labPickerView.dataSource = self
    labPickerView.delegate = self
    
    // variable to track the current selected lab in the picker view
    labName = labs.first // defsult lab is the firsdt row in the picker viere
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    // change the color and border width of the text view
    // expetriment with shadows oon views
    // every view has a CALayer - CA Core Animation
    
    // semantic colors are new to iOS 13
    // semantic colors adapt to light or dark mode
    // CG - Core Graphics
    questionTestView.layer.borderColor = UIColor.systemBlue.cgColor
    questionTestView.layer.borderWidth = 10
  }
  
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  @IBAction func create(_sender: UIBarButtonItem) {
    // 3 required parameters to creae a PostedQuestion
    guard let questionTitle = titleTextField.text,
      !questionTitle.isEmpty,
      let labName = labName,
      let labDescription = questionTestView.text,
      !labDescription.isEmpty else {
        showAlert(title: "Missing Fields", message: "Title, Description are required")
        questionTestView.layer.borderColor = UIColor.systemRed.cgColor
        titleTextField.layer.borderColor = UIColor.systemRed.cgColor
        titleTextField.layer.borderWidth = 3
        return
    }
    
    let question = PostedQuestion(title: questionTitle,
                                  labName: labName,
                                  description: labDescription,
                                  createdAt: String.getISOTimestamp())
    
    // TODO: post question using APIClient
    LabQuestionsAPIClient.postQuestion(question: question) { [weak self] (result) in
      switch result {
      case .failure(let appError):
        DispatchQueue.main.async {
          self?.showAlert(title: "Error posting question", message: "\(appError)")
        }
      case .success:
        DispatchQueue.main.async {
          self?.showAlert(title: "Success", message: "\(questionTitle) was posted")
        }
        }
      }
    }
  }
  

extension CreateQuestionController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return labs.count
  }
}
extension CreateQuestionController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return labs[row]
  }
}

