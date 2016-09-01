//
//  ViewController.swift
//  DropButton
//
//  Created by 李志宇 on 16/9/1.
//  Copyright © 2016年 izijia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for index in 0...5   {
            let btn = UIButton.init(frame: CGRectMake(CGFloat(index) * 70, CGFloat(index) * 70, 60, 60))
            btn.backgroundColor = UIColor.init(colorLiteralRed: Float((arc4random() % 255)) / 255.0, green: Float((arc4random() % 255)) / 255.0, blue: Float((arc4random() % 255)) / 255.0, alpha: 1)
            let dropBtn = DropButtonView.init(button: btn)
            dropBtn.backgroundColor = UIColor.clearColor()
            view.addSubview(dropBtn)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

