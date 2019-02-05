//
//  QuestionTableViewCell.swift
//  Fasenra
//
//  Created by Esslam Emad on 30/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var outer1: UIImageView!
    @IBOutlet weak var inner1: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var outer2: UIImageView!
    @IBOutlet weak var inner2: UIImageView!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var outer3: UIImageView!
    @IBOutlet weak var inner3: UIImageView!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var outer4: UIImageView!
    @IBOutlet weak var inner4: UIImageView!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var outer5: UIImageView!
    @IBOutlet weak var inner5: UIImageView!
    @IBOutlet weak var label5: UILabel!
    
    var delegate: AnswersDelegate!
    var question: Question!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 10.0
        containerView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    func fillCell(){
        QuestionLabel.text = question.title
        label1.text = question.answers[0].details
        inner1.alpha = question.answers[0].choosen ? 1 : 0
        label2.text = question.answers[1].details
        inner2.alpha = question.answers[1].choosen ? 1 : 0
        label3.text = question.answers[2].details
        inner3.alpha = question.answers[2].choosen ? 1 : 0
        label4.text = question.answers[3].details
        inner4.alpha = question.answers[3].choosen ? 1 : 0
        label5.text = question.answers[4].details
        inner5.alpha = question.answers[4].choosen ? 1 : 0
        outer1.tag = 0
        outer2.tag = 1
        outer3.tag = 2
        outer4.tag = 3
        outer5.tag = 4
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(Answer1Clicked(_:)))
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(Answer2Clicked(_:)))
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(Answer3Clicked(_:)))
        let gesture4 = UITapGestureRecognizer(target: self, action: #selector(Answer4Clicked(_:)))
        let gesture5 = UITapGestureRecognizer(target: self, action: #selector(Answer5Clicked(_:)))
        outer4.addGestureRecognizer(gesture1)
        outer3.addGestureRecognizer(gesture2)
        outer2.addGestureRecognizer(gesture3)
        outer1.addGestureRecognizer(gesture4)
        outer5.addGestureRecognizer(gesture5)
    }
    
    @IBAction func Answer1Clicked(_ gesture: UITapGestureRecognizer){
        self.delegate.didChooseAnswer(questionID: question.id, answerID: question.answers[gesture.view!.tag].id)
        inner1.alpha = gesture.view!.tag == 0 ? 1 : 0
        inner2.alpha = gesture.view!.tag == 1 ? 1 : 0
        inner3.alpha = gesture.view!.tag == 2 ? 1 : 0
        inner4.alpha = gesture.view!.tag == 3 ? 1 : 0
        inner5.alpha = gesture.view!.tag == 4 ? 1 : 0
    }
    @IBAction func Answer2Clicked(_ gesture: UITapGestureRecognizer){
        self.delegate.didChooseAnswer(questionID: question.id, answerID: question.answers[gesture.view!.tag].id)
        inner1.alpha = gesture.view!.tag == 0 ? 1 : 0
        inner2.alpha = gesture.view!.tag == 1 ? 1 : 0
        inner3.alpha = gesture.view!.tag == 2 ? 1 : 0
        inner4.alpha = gesture.view!.tag == 3 ? 1 : 0
        inner5.alpha = gesture.view!.tag == 4 ? 1 : 0
    }
    @IBAction func Answer3Clicked(_ gesture: UITapGestureRecognizer){
        self.delegate.didChooseAnswer(questionID: question.id, answerID: question.answers[gesture.view!.tag].id)
        inner1.alpha = gesture.view!.tag == 0 ? 1 : 0
        inner2.alpha = gesture.view!.tag == 1 ? 1 : 0
        inner3.alpha = gesture.view!.tag == 2 ? 1 : 0
        inner4.alpha = gesture.view!.tag == 3 ? 1 : 0
        inner5.alpha = gesture.view!.tag == 4 ? 1 : 0
    }
    @IBAction func Answer4Clicked(_ gesture: UITapGestureRecognizer){
        self.delegate.didChooseAnswer(questionID: question.id, answerID: question.answers[gesture.view!.tag].id)
        inner1.alpha = gesture.view!.tag == 0 ? 1 : 0
        inner2.alpha = gesture.view!.tag == 1 ? 1 : 0
        inner3.alpha = gesture.view!.tag == 2 ? 1 : 0
        inner4.alpha = gesture.view!.tag == 3 ? 1 : 0
        inner5.alpha = gesture.view!.tag == 4 ? 1 : 0
    }
    @IBAction func Answer5Clicked(_ gesture: UITapGestureRecognizer){
        self.delegate.didChooseAnswer(questionID: question.id, answerID: question.answers[gesture.view!.tag].id)
        inner1.alpha = gesture.view!.tag == 0 ? 1 : 0
        inner2.alpha = gesture.view!.tag == 1 ? 1 : 0
        inner3.alpha = gesture.view!.tag == 2 ? 1 : 0
        inner4.alpha = gesture.view!.tag == 3 ? 1 : 0
        inner5.alpha = gesture.view!.tag == 4 ? 1 : 0
    }

}

protocol AnswersDelegate{
    func didChooseAnswer(questionID: Int, answerID: Int)
}
