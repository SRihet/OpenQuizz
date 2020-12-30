//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Stéphane Rihet on 29/12/2020.
//

import UIKit

class QuestionView: UIView {

   @IBOutlet private var label: UILabel!
   @IBOutlet private var icon: UIImageView!
    
    var title:String = "" {
        didSet {
            label.text = title
        }
    }
    
    var style:Style = .standard {
        didSet {
            setStyle(style)
        }
    }
    
    private func setStyle (_ style:Style) {
        switch style {
        case .correct:
            backgroundColor = UIColor(red: 200/255.0, green: 236/255.0, blue: 160/255.0, alpha: 1)
            icon.image = UIImage(named: "Icon Correct")
            icon.isHidden = false
        case .incorrect:
            backgroundColor = #colorLiteral(red: 0.9554345012, green: 0.5312162042, blue: 0.5838454962, alpha: 1)
            icon.image = UIImage(named: "Icon Error")
            icon.isHidden = false
        case .standard:
            backgroundColor = #colorLiteral(red: 0.7479906678, green: 0.7722136378, blue: 0.7931336164, alpha: 1)
            icon.isHidden = true
        }
    }
    
    enum Style {
        case correct, incorrect, standard
    }

}
