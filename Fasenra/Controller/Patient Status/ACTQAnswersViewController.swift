//
//  ACTQAnswersViewController.swift
//  Fasenra
//
//  Created by Esslam Emad on 30/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import RZTransitions

class ACTQAnswersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var actq: ACTQ!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        self.transitioningDelegate = RZTransitionsManager.shared()
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actq.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AnswerTableViewCell
        cell.AnswerLabel.text = actq.questions[indexPath.row].answers[0].details
        cell.questionLabel.text = actq.questions[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = actq.questions[indexPath.row].title
        let neededSize = label.sizeThatFits(CGSize(width: self.view.frame.width - 64, height: CGFloat.greatestFiniteMagnitude))
        return neededSize.height + 90
    }
    

}
