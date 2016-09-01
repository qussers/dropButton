//
//  ReleaseButtonView.swift
//  Exchange_S
//
//  Created by 李志宇 on 16/9/1.
//  Copyright © 2016年 izijia. All rights reserved.
//
/**
 *  水珠按钮
 *
 *
 */


import UIKit

class DropButtonView: UIView {
    //是否在范围内
    var isAtReact:Bool?
    //圆心
    var moveArcCenter:CGPoint?
    var stayArcCenter:CGPoint?
    
    //公切点
    var moveArcPoint1:CGPoint?
    var moveArcPoint2:CGPoint?
    var stayArcPoint1:CGPoint?
    var stayArcPoint2:CGPoint?
    
    //半径
    var moveArcRadius:CGFloat?
    var stayArcRadius:CGFloat?
    
    //贝塞尔曲线参照点
    var anchPoint:CGPoint?
    
    //是否在原有位置
    var isAtCenter:Bool?
    
    //button圆形
    var oButton:UIButton?
    
    init(button:UIButton) {
        super.init(frame: button.frame)
        moveArcRadius = button.frame.size.width * 0.5
        stayArcRadius = button.frame.size.width * 0.5
        moveArcCenter = CGPointMake(button.frame.origin.x + moveArcRadius!, button.frame.origin.y + moveArcRadius!)
        stayArcCenter = moveArcCenter
        oButton = button
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.frame  = (self.superview?.bounds)!
        let p = (touches as NSSet).anyObject()?.locationInView(self)
        let rect = CGRectMake((moveArcCenter!.x) - (moveArcRadius)!, (moveArcCenter!.y) - (moveArcRadius)! , (moveArcRadius)! * 2, (moveArcRadius)! * 2)
        isAtReact = CGRectContainsPoint(rect, p!)
        setNeedsDisplay()

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let p = (touches as NSSet).anyObject()?.locationInView(self)
            if isAtReact == true {
                isAtCenter = false
                moveArcCenter = p
                //计算圆心距
                let dis = sqrt(pow((moveArcCenter!.x - stayArcCenter!.x), 2) + pow((moveArcCenter!.y - stayArcCenter!.y), 2));
                //设置不动圆的半径
                stayArcRadius = moveArcRadius! - dis / 15
                //太长超出范围，移动到圆中心
                if stayArcRadius < 3{
                    isAtCenter = true
                }
                //计算
                calcuation()
                //重绘
                setNeedsDisplay()
            }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {

        self.frame.size = (oButton?.frame.size)!
        self.frame.origin = CGPointMake(moveArcCenter!.x - moveArcRadius!, moveArcCenter!.y - moveArcRadius!)
        stayArcCenter = moveArcCenter
        calcuation()
        isAtCenter = true
        setNeedsDisplay()
    }
    
    //计算
    func calcuation(){
        anchPoint = CGPointMake(fabs(moveArcCenter!.x + stayArcCenter!.x)/2, fabs(moveArcCenter!.y + stayArcCenter!.y)/2);
        let sin = (moveArcCenter!.x - stayArcCenter!.x)/sqrt(pow((moveArcCenter!.x - stayArcCenter!.x), 2) + pow((moveArcCenter!.y - stayArcCenter!.y), 2));
        let cos = (moveArcCenter!.y - stayArcCenter!.y)/sqrt(pow((moveArcCenter!.x - stayArcCenter!.x), 2) + pow((moveArcCenter!.y - stayArcCenter!.y), 2));
        moveArcPoint1 = CGPointMake(moveArcRadius! * cos + moveArcCenter!.x, -moveArcRadius! * sin + moveArcCenter!.y);
        moveArcPoint2 = CGPointMake(-moveArcRadius! * cos + moveArcCenter!.x, moveArcRadius! * sin + moveArcCenter!.y);
        stayArcPoint1 = CGPointMake(stayArcRadius! * cos + stayArcCenter!.x, -stayArcRadius! * sin + stayArcCenter!.y);
        stayArcPoint2 = CGPointMake(-stayArcRadius! * cos + stayArcCenter!.x, stayArcRadius! * sin + stayArcCenter!.y);
    }
    //绘制？
    override func drawRect(rect: CGRect) {
        // Drawing code
        let ref = UIGraphicsGetCurrentContext()
        //循环绘制
            //设置背景颜色
            oButton?.backgroundColor?.set()
            if oButton?.frame.size == self.frame.size {
                CGContextAddArc(ref,moveArcRadius!,moveArcRadius!, moveArcRadius!, 0, CGFloat(M_PI) * 2, 0)
            }else{
            CGContextAddArc(ref, (moveArcCenter?.x)!, (moveArcCenter?.y)!, moveArcRadius!, 0, CGFloat(M_PI) * 2, 0)
            }
            CGContextFillPath(ref)
            if isAtCenter == false {
                //不动的圆
                CGContextAddArc(ref, (stayArcCenter?.x)!, (stayArcCenter?.y)!, stayArcRadius!, 0, CGFloat(M_PI) * 2, 0)
                CGContextFillPath(ref)
                //填充曲面矩形
                CGContextMoveToPoint(ref, (moveArcPoint1?.x)!, (moveArcPoint1!.y))
                CGContextAddQuadCurveToPoint(ref, (anchPoint?.x)!, (anchPoint?.y)!, (stayArcPoint1?.x)!, (stayArcPoint1?.y)!)
                CGContextAddLineToPoint(ref, (stayArcPoint2?.x)!, (stayArcPoint2!.y))
                CGContextAddQuadCurveToPoint(ref, (anchPoint?.x)!, (anchPoint?.y)!, (moveArcPoint2?.x)!, (moveArcPoint2?.y)!)
                CGContextFillPath(ref)
            }
            if ((oButton?.imageView?.image) != nil) {
                let image = oButton?.imageView?.image
                if oButton?.frame.size == self.frame.size {
                    image?.drawInRect(CGRectMake(0, 0, moveArcRadius! * 2, moveArcRadius! * 2))
                    CGContextDrawImage(ref, CGRectMake(0, 0, 0, 0), image?.CGImage)
                }else{
                    image?.drawInRect(CGRectMake((moveArcCenter?.x)! - moveArcRadius!, (moveArcCenter?.y)! - moveArcRadius!, moveArcRadius! * 2, moveArcRadius! * 2))
                    CGContextDrawImage(ref, CGRectMake(0, 0, 0, 0), image?.CGImage)
                }
            }

        
    }
 

}
