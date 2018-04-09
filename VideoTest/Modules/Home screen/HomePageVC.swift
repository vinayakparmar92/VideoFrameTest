//
//  HomePageVC.swift
//  VideoTest
//
//  Created by Vinayak Parmar on 07/04/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit
import AVKit

class HomePageVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var btnAction:UIButton!
    @IBOutlet weak var viewVideoLayerContainer: AVPlayerLayerView! {
        didSet {
            videoPlayerLayer =  viewVideoLayerContainer.layer as? AVPlayerLayer
            videoPlayerLayer?.bounds  = viewVideoLayerContainer.bounds
        }
    }
    
    // MARK: Variables
    var topPadding : CGFloat {
        // To handle the safe area top padding due to safe area in iOS
        if #available(iOS 11, *) {
            return 20
        }
        else {
            return 0
        }
    }
    var videoPlayer : AVPlayer?
    var videoPlayerLayer : AVPlayerLayer?
    var isCollapsedState = false {
        didSet {
            UIView.animate(withDuration: kAnimationDuration) { [weak self] in
                if let weakSelf = self {
                    DispatchQueue.main.async {
                        // Return to normal state
                        if !weakSelf.isCollapsedState {
                            weakSelf.viewVideoLayerContainer.layer.cornerRadius = 0
                            weakSelf.viewVideoLayerContainer.frame = CGRect.init(x: 0, y: weakSelf.topPadding,
                                                                                 width: weakSelf.view.frame.size.width,
                                                                                 height: weakSelf.view.frame.size.height - weakSelf.topPadding)
                        }
                    }
                }
            }
        }
    }
    let questions = ["Can we Overload or Override static methods in java?",
                     "Why the main method is static in java?",
                     "What happens if you remove static modifier from the main method?",
                     "What is the scope of variables in Java in following cases?",
                     "What is “this” keyword in java?",
                     "What is “this” keyword in java? \n What is “this” keyword in java?",
                     "What is “this” keyword in java? \n What is “this” keyword in java? \n What is “this” keyword in java? \n What is “this” keyword in java? \n ",
                     "What is an abstract class? How abstract classes are similar or different in Java from C++?",
                     "What is an abstract class? How abstract classes are similar or different in Java from C++?",
                     "Which class is the superclass for every class ?",
                     "Why method overloading is not possible by changing the return type in java?"]

    
    // MARK: METHODS
    // MARK: View lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        playVideoWith(name: kVideoName,
                      ofFormat: kVideoType)
    }
    
    // MARK: Button click events
    @IBAction func tappedShowQuestion(_ sender: UIButton) {
        
        // Present question popup
        let randomQuestionText = questions[Int(arc4random_uniform(UInt32(questions.count)))]
        
        let questionAlertVC = QuestionAlertVC.getQuestionAlertWith(questionText: randomQuestionText)
        questionAlertVC.modalPresentationStyle = .overCurrentContext
        questionAlertVC.modalTransitionStyle = .crossDissolve
        
        // Configure callbacks 
        questionAlertVC.presentationCompleteCallBack = { [weak self] (upperBubblePosition) in
            DispatchQueue.main.async { [weak self] in
                if let weakSelf = self {
                    weakSelf.collapseVideoTo(frame: upperBubblePosition)
                }
            }
        }
        questionAlertVC.viewControllerDismissCallback = {[weak self] in
            DispatchQueue.main.async { [weak self] in
                if let weakSelf = self {
                    weakSelf.isCollapsedState = false
                }
            }
        }
        
        present(questionAlertVC,
                animated: true,
                completion: nil)
    }
    
    @IBAction func toggleVideoStatus(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        // Play video if the button is selected
        if sender.isSelected {
            videoPlayer?.play()
        } else {
            videoPlayer?.pause()
        }
    }

    // MARK: Helper methods
    func collapseVideoTo(frame: CGRect) {
        UIView.animate(withDuration: kAnimationDuration) { [weak self] in
            if let weakSelf = self {
                // Return to normal state
                if !weakSelf.isCollapsedState {
                    weakSelf.viewVideoLayerContainer.layer.cornerRadius = frame.size.width / 2
                    weakSelf.viewVideoLayerContainer.frame = CGRect.init(x: frame.origin.x, y: frame.origin.y,
                                                                         width: frame.size.width, height: frame.size.height * 2)
                }
            }
        }
    }
    
    func playVideoWith(name: String,
                       ofFormat videoFormatType: String) {
        // Check if video found
        if let videoPathString = Bundle.main.path(forResource: name, ofType: videoFormatType) {
            
            // Create video file URL
            let videoPathURL = URL.init(fileURLWithPath: videoPathString)
            
            // Load the video in player
            videoPlayer = AVPlayer.init(url: videoPathURL)
            videoPlayer?.seek(to: kCMTimeZero)
            videoPlayer?.isMuted = true

            // Configure videoplayer layer and add videoplayer to it
            videoPlayerLayer?.player = videoPlayer
            videoPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        }
    }
}

