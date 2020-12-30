//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Stéphane Rihet on 28/12/2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        roundView()
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)
        
        startNewGame()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameController.isHidden = false
        
        questionView.title = game.currentQuestion.title
    }
    
    @IBOutlet weak var newGameController: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    
    var game = Game()
    var time :Int = 0
    var timer = Timer()
    
    @IBAction func didTapNewGameButton() {
        resetTimer()
        startNewGame()
        
    }
    
    private func startNewGame() {
        activityIndicator.isHidden = false
        newGameController.isHidden = true
        
        questionView.title = "Loading..."
        questionView.style = .standard
        scoreLabel.text = "0 / 10"
        startTimer()
        game.refresh()
        
    }
    
    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .cancelled, .ended:
                answerQuestion()
            default:
                break
            }
        }

    }
    
    private func transformQuestionViewWith (gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: questionView)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        let screenWidth = UIScreen.main.bounds.width
        let translationPercent = translation.x / (screenWidth/2)
        let rotationAngle = (CGFloat.pi / 6) * translationPercent
        
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform = translationTransform.concatenating(rotationTransform)
        questionView.transform = transform
        
        if translation.x > 0 {
            questionView.style = .correct
        }else {
            questionView.style = .incorrect
        }
    }
    
    private func answerQuestion() {
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        default:
            break
        }
        
        scoreLabel.text = "\(game.score) / 10"
        
        scoreLabel.text = "\(game.score) / 10"

        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }

        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = translationTransform
        }, completion: { (success) in
            if success {
                self.showQuestionView()
            }
        })
    }

    private func showQuestionView() {
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

        questionView.style = .standard

        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game Over"
            timer.invalidate()
        }

        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.questionView.transform = .identity
        }, completion:nil)
    }
    
    private func roundView() {
        newGameController.layer.cornerRadius = newGameController.layer.frame.height/2
        timerView.layer.cornerRadius = timerView.layer.frame.height/4
        questionView.layer.cornerRadius = questionView.layer.frame.height/4
    }
    
    private func startTimer() {
        timer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerEnded), userInfo: nil, repeats: true)
    }
    
    private func resetTimer() {
        timer.invalidate()
        time = 0
        updateTimerUI()
    }
    
    @objc private func timerEnded() {
        time += 1
        updateTimerUI()
    }
    
    private func updateTimerUI(){
        var min: Int
        var sec: Int

        min = (time/60)%60
        sec = time % 60
        
        minutesLabel.text = String(min)
        secondsLabel.text = String(sec)
        
        
    }
}

