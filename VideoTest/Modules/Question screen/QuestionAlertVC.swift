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
let kInitialStateRadius = CGFloat(1)

class QuestionAlertVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var lblQuestionText:UILabel!
    @IBOutlet weak var btnActionA:UIButton!
    @IBOutlet weak var btnActionB:UIButton!
    @IBOutlet weak var btnActionC:UIButton!
    @IBOutlet weak var viewUpperBubble: UIView!
    @IBOutlet weak var viewLowerSubviewsContainer: UIView!
    @IBOutlet weak var imgViewExpandingCircle: UIImageView!
    
    // MARK: Variables
    var questionText : String?
    var optionAText : String?
    var optionBText : String?
    var optionCText : String?
    var presentationCompleteCallBack : ((CGRect)->())?
    var viewControllerDismissCallback : (()->())?
    var viewdidLayoutCalledFirstTime = true
    
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
        viewUpperBubble.layer.cornerRadius = viewUpperBubble.bounds.size.width / 2
        viewLowerSubviewsContainer.layer.cornerRadius = kLowerSubviewsCornerRadius

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: kAnimationDuration, animations: { [weak self] in
            if let weakSelf = self {
                // TODO: Consider other screen sizes for this scaling
                weakSelf.imgViewExpandingCircle.transform = CGAffineTransform.init(scaleX: 1000, y: 1000)
            }
        }) { [weak self] (isComplete) in
            if let weakSelf = self {
                if isComplete {
                    weakSelf.imgViewExpandingCircle.isHidden = true
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Creating holes
        putCraterInUpperBody()
        putCraterInLowerBody()
        putCraterInMainContainerView()
        putCraterInExpandingCircularImage()
        
        presentationCompleteCallBack?(viewUpperBubble.frameForIdentityTransform)
    }
    
    // MARK: Button click events
    @IBAction func tappedAction(_ sender: UIButton) {
        dismiss(animated: true,
                completion: nil)
    }
    
    // MARK: Helper methods
    // Create a crater in the upper bubble view
    func putCraterInUpperBody() {
        let radius = viewUpperBubble.bounds.size.width / 2 - kBorderWidth

        viewUpperBubble.putCraterOf(radius: radius, circleCenter: viewUpperBubble.center)
    }
    
    // Create a crater in the Lower body
    func putCraterInLowerBody() {
        let radius = viewUpperBubble.bounds.size.width / 2 - kBorderWidth
        let center = CGPoint(x: viewLowerSubviewsContainer.bounds.size.width / 2, y: 0)
        
        viewLowerSubviewsContainer.putCraterOf(radius: radius,
                                               circleCenter: center)
    }
    
    func putCraterInMainContainerView() {
        let center = viewUpperBubble.superview?.convert(viewUpperBubble.center,
                                                        to: view)
        let radius = viewUpperBubble.frameForIdentityTransform.size.width / 2 - kBorderWidth
        
        if let center = center {
            view.putCraterOf(radius: radius,
                             circleCenter: center)
        }
    }
    
    func putCraterInExpandingCircularImage() {
        imgViewExpandingCircle.putCraterOf(radius: kInitialStateRadius,
                                           circleCenter: imgViewExpandingCircle.center)
    }
}
