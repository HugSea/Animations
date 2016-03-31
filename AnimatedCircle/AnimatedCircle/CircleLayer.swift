//
//  CircleLayer.swift
//  AnimatedCircle
//
//  Created by 张庆杰 on 16/3/30.
//  Copyright © 2016年 ZhangQingjie. All rights reserved.
//

import UIKit

// 移动方向枚举值
enum MoveDir {
    case Move_B
    case Move_D
}

let kOutsideRectSize: CGFloat = 100

class CircleLayer: CALayer {
    // 外接矩形Frame
    var outsideRect: CGRect!
    // 移动方向
    var moveDir: MoveDir!
    // 当前进度
    var progress: CGFloat = 0.0 {
        didSet {
            if progress <= 0.5 {
                // B点移动
                self.moveDir = MoveDir.Move_B
            } else {
                // D点移动
                self.moveDir = MoveDir.Move_D
            }
            // 计算矩形位置
            let buff = (progress - 0.5) * (frame.size.width - kOutsideRectSize)
            let origin_x = position.x - kOutsideRectSize / 2.0 + buff
            let origin_y = position.y - kOutsideRectSize / 2.0
            outsideRect = CGRectMake(origin_x, origin_y, kOutsideRectSize, kOutsideRectSize)
            
            setNeedsDisplay()
        }
    }
    
    override init() {
        super.init()
    }
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
        if let layer = layer as? CircleLayer {
            progress = layer.progress
            outsideRect = layer.outsideRect
            moveDir = layer.moveDir
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawInContext(ctx: CGContext) {
        //A-C1、B-C2... 的距离，当设置为正方形边长的1/3.6倍时，画出来的圆弧完美贴合圆形
        // 详见: http://blog.csdn.net/nibiewuxuanze/article/details/48103059
        let offset = kOutsideRectSize / 3.6
        //A.B.C.D实际需要移动的距离.系数为滑块偏离中点0.5的绝对值再乘以2.当滑到两端的时候，movedDistance为最大值：「外接矩形宽度的1/5」.
        let movedDistance = (kOutsideRectSize / 5.0) * fabs(progress - 0.5) * 2
        // 计算矩形中心点的位置，方便计算各点的位置
        let rectCenter = CGPointMake(outsideRect.origin.x + kOutsideRectSize / 2.0, outsideRect.origin.y + kOutsideRectSize / 2.0)
        
        // 计算A、B、C、D四个点的坐标
        let point_A = CGPointMake(rectCenter.x, outsideRect.origin.y + movedDistance)
        let point_B = CGPointMake(moveDir == MoveDir.Move_B ? rectCenter.x + kOutsideRectSize / 2.0 + movedDistance * 2 : rectCenter.x + kOutsideRectSize / 2.0, rectCenter.y)
        let point_C = CGPointMake(rectCenter.x, rectCenter.y + kOutsideRectSize / 2.0 - movedDistance)
        let point_D = CGPointMake(moveDir == MoveDir.Move_D ? outsideRect.origin.x - movedDistance * 2 : outsideRect.origin.x, rectCenter.y)
        
        // 计算c1、c2...c8的坐标
        let c1 = CGPointMake(point_A.x + offset, point_A.y)
        let c2 = CGPointMake(point_B.x, moveDir == MoveDir.Move_B ? point_B.y - offset + movedDistance : point_B.y - offset)
        let c3 = CGPointMake(point_B.x, moveDir == MoveDir.Move_B ? point_B.y + offset - movedDistance : point_B.y + offset)
        let c4 = CGPointMake(point_C.x + offset, point_C.y)
        let c5 = CGPointMake(point_C.x - offset, point_C.y)
        let c6 = CGPointMake(point_D.x, moveDir == MoveDir.Move_D ? point_D.y + offset - movedDistance : point_D.y + offset)
        let c7 = CGPointMake(point_D.x, moveDir == MoveDir.Move_D ? point_D.y - offset + movedDistance : point_D.y - offset)
        let c8 = CGPointMake(point_A.x - offset, point_A.y)
        
        // 绘制
        // 椭圆
        let circlePath = UIBezierPath()
        circlePath.moveToPoint(point_A)
        circlePath.addCurveToPoint(point_B, controlPoint1: c1, controlPoint2: c2)
        circlePath.addCurveToPoint(point_C, controlPoint1: c3, controlPoint2: c4)
        circlePath.addCurveToPoint(point_D, controlPoint1: c5, controlPoint2: c6)
        circlePath.addCurveToPoint(point_A, controlPoint1: c7, controlPoint2: c8)
        circlePath.closePath()
        
        CGContextAddPath(ctx, circlePath.CGPath)
        CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
        CGContextSetFillColorWithColor(ctx, UIColor.greenColor().CGColor)
        // 同时给线条和内部区域添加颜色
        CGContextDrawPath(ctx, CGPathDrawingMode.FillStroke)
        
        // 虚线外接矩形
        let rectPath = UIBezierPath(rect: outsideRect)
        
        CGContextAddPath(ctx, rectPath.CGPath)
        CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
        CGContextSetLineDash(ctx, 0, [5, 5], 2)
        // 给线条添加颜色
        CGContextStrokePath(ctx)
        
        // c1..c8辅助线
        let assistPath: UIBezierPath = UIBezierPath()
        assistPath.moveToPoint(c1)
        assistPath.addLineToPoint(c2)
        assistPath.addLineToPoint(c3)
        assistPath.addLineToPoint(c4)
        assistPath.addLineToPoint(c5)
        assistPath.addLineToPoint(c6)
        assistPath.addLineToPoint(c7)
        assistPath.addLineToPoint(c8)
        assistPath.closePath()
        
        CGContextAddPath(ctx, assistPath.CGPath)
        CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
        CGContextSetLineDash(ctx, 0, [2, 2], 2)
        CGContextStrokePath(ctx)
    }
}
