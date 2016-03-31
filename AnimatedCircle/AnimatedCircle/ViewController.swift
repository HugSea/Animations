//
//  ViewController.swift
//  AnimatedCircle
//
//  Created by 张庆杰 on 16/3/30.
//  Copyright © 2016年 ZhangQingjie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var progressLabel: UILabel!
    
    var circleView: CircleView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let size = UIScreen.mainScreen().bounds.size.width - 50
        circleView = CircleView(frame: CGRectMake(self.view.center.x - size / 2.0, self.view.center.y - size / 2.0 - 100, size, size))
        self.view.addSubview(circleView)
        circleView.circleLayer.progress = CGFloat(slider.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Event Response
    
    @IBAction func slideSlider(sender: UISlider) {
        progressLabel.text = "Current Progress: " + "\(sender.value)"
        circleView.circleLayer.progress = CGFloat(sender.value)
    }

}

