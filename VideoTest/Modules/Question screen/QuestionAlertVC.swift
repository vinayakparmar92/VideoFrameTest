//
//  QuestionAlertVC.swift
//  VideoTest
//
//  Created by Vinayak Parmar on 08/04/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit

let kBorderWidth = CGFloat(10.0)
let kLowerSubviewsCornerRadius = CGFloat(20.0)


class QuestionAlertVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var lblQuestionText:UILabel!
    @IBOutlet weak var btnActionA:UIButton!
    @IBOutlet weak var btnActionB:UIButton!
    @IBOutlet weak var btnActionC:UIButton!
    @IBOutlet weak var viewUpperBubble: UIView!
    @IBOutlet weak var viewLowerSubviewsContainer: UIView!
    
    // MARK: Variables
    var questionText : String?
    var optionAText : String?
    var optionBText : String?
    var optionCText : String?
    var presentationCompleteCallBack : ((CGRect)->())?
    var viewControllerDismissCallback : (()->())?
    
    // MARK: METHODS
    // MARK: Initialisers
    class func getQuestionAlertWith(questionText: String,
                                    optionA: String = "Option One",
                                    optionB: String = "Option Two",
                                    optionC: String = "Option Three") ->  QuestionAlertVC {
        let questionVC = QuestionAlertVC.init(nibName: "QuestionAlertVC",
                                              bundle: nil)
        questionVC.questionText = questionText
        questionVC.optionAText = optionA
        questionVC.optionBText = optionB
        questionVC.optionCText = optionC
        return questionVC
    }
    
    // MARK: View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure UI
        viewLowerSubviewsContainer.backgroundColor = kPrimaryColor
        viewUpperBubble.backgroundColor = kPrimaryColor
        
        // Assigning data to UI
        lblQuestionText.text = questionText
        btnActionA.setTitle(optionAText, for: .normal)
        btnActionB.setTitle(optionBText, for: .normal)
        btnActionC.setTitle(optionCText, for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewControllerDismissCallback?()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Creating holes
        putCraterInUpperBody()
        putCraterInLowerBody()
        
        presentationCompleteCallBack?(viewUpperBubble.frame)
    }
    
    // MARK: Button click events
    @IBAction func tappedAction(_ sender: UIButton) {
        dismiss(animated: true,
                completion: nil)
    }
    
    // MARK: Helper mthods
    // Create a crater in the upper bubble view
    func putCraterInUpperBody() {
        let widthHalf = CGFloat(viewUpperBubble.frame.size.width / 2)
        let radius = widthHalf - kBorderWidth
        
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: viewUpperBubble.frame.size.width / 2, y: viewUpperBubble.frame.size.height / 2),
                    radius: radius,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        path.addRect(viewUpperBubble.bounds)

        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = kCAFillRuleEvenOdd
        viewUpperBubble.layer.mask = maskLayer
        viewUpperBubble.clipsToBounds = true
        
        viewUpperBubble.layer.cornerRadius = widthHalf
    }
    
    // Create a crater in the Lower body
    func putCraterInLowerBody() {
        let radius = viewUpperBubble.frame.size.width / 2 - kBorderWidth
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: viewLowerSubviewsContainer.frame.size.width / 2, y: 0),
                    radius: radius,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        path.addRect(viewLowerSubviewsContainer.bounds)

        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = kCAFillRuleEvenOdd
        viewLowerSubviewsContainer.layer.mask = maskLayer
        viewLowerSubviewsContainer.clipsToBounds = true
        
        viewLowerSubviewsContainer.layer.cornerRadius = kLowerSubviewsCornerRadius
    }
}
