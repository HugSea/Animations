//
//  CircleView.swift
//  AnimatedCircle
//
//  Created by 张庆杰 on 16/3/30.
//  Copyright © 2016年 ZhangQingjie. All rights reserved.
//

import UIKit

class CircleView: UIView {

    var circleLayer: CircleLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        circleLayer = CircleLayer()
        circleLayer.frame = self.bounds
        // 图层比例
        circleLayer.contentsScale = UIScreen.mainScreen().scale
        circleLayer.backgroundColor = UIColor.lightGrayColor().CGColor
        self.layer.addSublayer(circleLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
