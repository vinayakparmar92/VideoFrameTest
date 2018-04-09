//
//  AVPlayerLayerView.swift
//  VideoTest
//
//  Created by Vinayak Parmar on 08/04/18.
//  Copyright © 2018 VMP. All rights reserved.
//

import UIKit
import AVKit

class AVPlayerLayerView: UIView {

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
