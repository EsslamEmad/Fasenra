//
//  ACTQTableViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 30/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import RZTransitions

class ACTQTableViewController: UITableViewController, AnswersDelegate {

    var actq: ACTQ!
    var answersRequest = AnswersRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getQuestions(patientID: Default.def.user!.id))
            }.done {
                self.actq = try! JSONDecoder().decode(ACTQ.self, from: $0)
                self.tableView.reloadData()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    func didChooseAnswer(questionID: Int, answerID: Int) {
        if let questionIndex = actq.questions.index(where: {$0.id == questionID}){
        for index in 0...actq.questions[questionIndex].answers.count - 1{
            actq.questions[questionIndex].answers[index].choosen = actq.questions[questionIndex].answers[index].id == answerID ? true : false
        }
        }
        if let foundIndex = answersRequest.answers.index(where: {$0.questionID == questionID}){
            answersRequest.answers[foundIndex].answerID = answerID
        }else {
            var answer = SampleAnswerRequest()
            answer.questionID = questionID
            answer.answerID = answerID
            answersRequest.answers.append(answer)
        }
    }
    
    @IBAction func didPressSubmit(_ gesture: UITapGestureRecognizer){
        guard answersRequest.answers.count == actq.questions.count else {
            self.showAlert(withMessage: "Please, answer all the question.")
            return
        }
        answersRequest.patient = Default.def.user!.id
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.addAnswer(answers: answersRequest))
            }.done { resp in
                self.showAlert(error: false, withMessage: "Your answers have been submitted succefully, Thank you.", completion: {(UIAlertAction) in
                    self.performMainSegue()
                })
                
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard actq != nil else {
            return 0
        }
        return actq.questions.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row != actq.questions.count else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "button cell") as! ButtonTableViewCell
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didPressSubmit(_:)))
            cell.submitButton.addGestureRecognizer(gesture)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuestionTableViewCell
        
        cell.delegate = self
        cell.question = actq.questions[indexPath.row]
        cell.fillCell()
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row != actq.questions.count else {
            return 70
        }
        let label = UILabel()
        label.numberOfLines = 0
        label.text = actq.questions[indexPath.row].title
        let neededSize = label.sizeThatFits(CGSize(width: self.view.frame.width - 64, height: CGFloat.greatestFiniteMagnitude))
        return neededSize.height + 153.5
    }

    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }

}
