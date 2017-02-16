//
//  KeiAnimatedPath.swift
//
//  Created by keisyrzk on 16.02.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit
import QuartzCore
import CoreText
import CoreGraphics



class KeiAnimatedPath
{
    ////////////////////////
    // CREATE A SINGLETON //
    
    class var shared: KeiAnimatedPath
    {
        struct Singleton
        {
            static let instance = KeiAnimatedPath()
        }
        return Singleton.instance
    }
    
    // CREATE A SINGLETON //
    ////////////////////////
    
    
    
    var animationLayer: CALayer?
    var pathLayer: CAShapeLayer?
    
    private var inputPath: CGPath!
    private var inputDuration: CFTimeInterval = 10
    private var inputLineWidth: CGFloat = 10
    private var inputLineColor = UIColor.black
    
    private var inputRotationAngle: CGFloat = 0
    private var inputPolygonSidesNumber: Int = 6
    private var inputCornerRadius: Float = 8

    private var inputText = ""
    private var inputFontSize: CGFloat = 20
    private var inputFontName = "PingFangSC-Bold"
    
    
    func drawAnimatedCustomPath(in view: UIView, path: CGPath, duration: CFTimeInterval, lineWidth: CGFloat, lineColor: UIColor)
    {
        self.inputDuration = duration
        self.inputLineWidth = lineWidth
        self.inputLineColor = lineColor
        self.inputPath = path
        
        animationLayer = CALayer()
        
        animationLayer?.frame = CGRect(x: 0, y: 0, width: view.layer.bounds.width, height: view.layer.bounds.height)
        view.layer.addSublayer(animationLayer!)
        view.clipsToBounds = true
        
        setupDrawingLayer()
        startAnimation()
    }
    
    func drawAnimatedRectanglePath(in view: UIView, duration: CFTimeInterval, lineWidth: CGFloat, lineColor: UIColor)
    {
        self.inputDuration = duration
        self.inputLineWidth = lineWidth
        self.inputLineColor = lineColor
        
        self.inputPath = rectanglePath(view: view)
        
        animationLayer = CALayer()
        
        animationLayer?.frame = CGRect(x: 0, y: 0, width: view.layer.bounds.width, height: view.layer.bounds.height)
        view.layer.addSublayer(animationLayer!)
        view.clipsToBounds = true
        
        setupDrawingLayer()
        startAnimation()
    }
    
    func drawAnimatedPolygonPath(in view: UIView, numberOfSides polygonSidesNumber: Int?, rotationAngle: CGFloat?, polygonCornerRadius: Float?, duration: CFTimeInterval, lineWidth: CGFloat, lineColor: UIColor)
    {
        self.inputDuration = duration
        self.inputLineWidth = lineWidth
        self.inputLineColor = lineColor
        if let _rotationAngle = rotationAngle
        {
            self.inputRotationAngle = _rotationAngle
        }
        if let _polygonSidesNumber = polygonSidesNumber
        {
            self.inputPolygonSidesNumber = _polygonSidesNumber
        }
        if let _polygonCornerRadius = polygonCornerRadius
        {
            self.inputCornerRadius = _polygonCornerRadius
        }
        
        self.inputPath = polygonPath(view: view)

        
        animationLayer = CALayer()
        animationLayer?.frame = CGRect(x: 0, y: 0, width: view.layer.bounds.width, height: view.layer.bounds.height)
        view.layer.addSublayer(animationLayer!)
        
        setupDrawingLayer()
        startAnimation()
    }
    
    func drawAnimatedText(in view: UIView, with text: String, duration: CFTimeInterval, lineWidth: CGFloat, textColor: UIColor, fontName: String?, fontSize: CGFloat?)
    {
        self.inputText = text
        self.inputDuration = duration
        self.inputLineWidth = lineWidth
        self.inputLineColor = textColor
        if let _fontSize = fontSize
        {
            self.inputFontSize = _fontSize
        }
        if let _fontName = fontName
        {
            self.inputFontName = _fontName
        }
        
        animationLayer = CALayer()
        animationLayer?.frame = CGRect(x: 0, y: 0, width: view.layer.bounds.width, height: view.layer.bounds.height)
        view.layer.addSublayer(animationLayer!)

        setupTextLayer(in: view)
        startAnimation()
    }
    
    
    func clearLayer()
    {
        if let _ = pathLayer
        {
            pathLayer?.removeFromSuperlayer()
            pathLayer = nil
        }
    }

    
    func setupDrawingLayer()
    {
        clearLayer()
        
        if let _ = animationLayer
        {
            let pathRect: CGRect = animationLayer!.bounds
            
            
            let pathShapeLayer = CAShapeLayer()
            pathShapeLayer.frame = animationLayer!.bounds
            pathShapeLayer.bounds = pathRect
            pathShapeLayer.isGeometryFlipped = true
            pathShapeLayer.path = inputPath
            pathShapeLayer.strokeColor = inputLineColor.cgColor
            pathShapeLayer.fillColor = nil
            pathShapeLayer.lineWidth = inputLineWidth
            pathShapeLayer.lineJoin = kCALineJoinBevel
            
            animationLayer!.addSublayer(pathShapeLayer)
        
            pathLayer = pathShapeLayer
        }
    }
    
    func setupTextLayer(in view: UIView)
    {
        clearLayer()
        
        if let _ = animationLayer
        {
            let font = CTFontCreateWithName(inputFontName as CFString?, inputFontSize, nil)
            let attrStr = NSAttributedString(string: inputText, attributes: [kCTFontAttributeName as String: font])
            let line = CTLineCreateWithAttributedString(attrStr)
            let runArray = CTLineGetGlyphRuns(line)
            
            let letters = CGMutablePath()
            
            for runIndex in 0..<CFArrayGetCount(runArray) {
                let runUnsafe: UnsafeRawPointer = CFArrayGetValueAtIndex(runArray, runIndex)
                let run = unsafeBitCast(runUnsafe, to: CTRun.self)
                
                for runGlyphIndex in 0..<CTRunGetGlyphCount(run) {
                    let thisGlyphRange = CFRangeMake(runGlyphIndex, 1)
                    var glyph: CGGlyph = CGGlyph()
                    var position: CGPoint = CGPoint()
                    CTRunGetGlyphs(run, thisGlyphRange, &glyph)
                    CTRunGetPositions(run, thisGlyphRange, &position)
                    
                    let letter = CTFontCreatePathForGlyph(font, glyph, nil)
                    let t = CGAffineTransform(translationX: position.x, y: position.y);
                    
                    if letter == nil {
                        continue
                    }
                    
                    letters.addPath(letter!, transform:t)
                }
            }
            
            let path = UIBezierPath()
            path.move(to: CGPoint.zero)
            path.append(UIBezierPath(cgPath: letters))
            
            
            let layer = CAShapeLayer()
            layer.frame = CGRect(x: 0, y: 0, width: view.layer.bounds.width, height: view.layer.bounds.height)
            layer.isGeometryFlipped = true
            layer.path = path.cgPath
            layer.strokeColor = inputLineColor.cgColor
            layer.fillColor = nil
            layer.lineWidth = inputLineWidth
            layer.lineJoin = kCALineJoinBevel
            
            animationLayer!.addSublayer(layer)
            
            pathLayer = layer
        }
        
    }
    
    func startAnimation()
    {
        pathLayer?.removeAllAnimations()
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = inputDuration
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathLayer?.add(pathAnimation, forKey: "strokeEnd")
    }
    
    
    
    
    /// CREATE PATH ///
    
    func rectanglePath(view: UIView) -> CGPath
    {
        let pathRect = view.frame
        let bottomLeft = CGPoint(x: pathRect.minX - view.frame.origin.x, y: pathRect.minY - view.frame.origin.y)
        let topLeft = CGPoint(x: pathRect.minX - view.frame.origin.x, y: pathRect.maxY - view.frame.origin.y)
        let bottomRight = CGPoint(x: pathRect.maxX - view.frame.origin.x, y: pathRect.minY - view.frame.origin.y)
        let topRight = CGPoint(x: pathRect.maxX - view.frame.origin.x, y: pathRect.maxY - view.frame.origin.y)
        
        let path = UIBezierPath()
        path.move(to: bottomLeft)
        path.addLine(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        
        return path.cgPath
    }

    func polygonPath(view: UIView) -> CGPath
    {
        let path = UIBezierPath()
        
        let theta = Float(2.0 * M_PI) / Float(inputPolygonSidesNumber)
        let offset = inputCornerRadius * tanf(theta / 2.0)
        let squareWidth = Float(min(view.frame.size.width, view.frame.size.height))
        
        var length = squareWidth - Float(inputLineWidth)
        
        if inputPolygonSidesNumber % 4 != 0
        {
            length = length * cosf(theta / 2.0) + offset / 2.0
        }
        
        let sideLength = length * tanf(theta / 2.0)
        
        var point = CGPoint(x: CGFloat((squareWidth / 2.0) + (sideLength / 2.0) - offset), y: CGFloat(squareWidth - (squareWidth - length) / 2.0))
        var angle = Float(M_PI)
        path.move(to: point)
        
        for _ in 0 ..< inputPolygonSidesNumber
        {
            
            let x = Float(point.x) + (sideLength - offset * 2.0) * cosf(angle)
            let y = Float(point.y) + (sideLength - offset * 2.0) * sinf(angle)
            
            point = CGPoint(x: CGFloat(x), y: CGFloat(y))
            path.addLine(to: point)
            
            let centerX = Float(point.x) + inputCornerRadius * cosf(angle + Float(M_PI_2))
            let centerY = Float(point.y) + inputCornerRadius * sinf(angle + Float(M_PI_2))
            
            let center = CGPoint(x: CGFloat(centerX), y: CGFloat(centerY))
            
            let startAngle = CGFloat(angle) - CGFloat(M_PI_2)
            let endAngle = CGFloat(angle) + CGFloat(theta) - CGFloat(M_PI_2)
            
            path.addArc(withCenter: center, radius: CGFloat(inputCornerRadius), startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            point = path.currentPoint
            angle += theta
        }
        
        path.close()
        
        
        // ROTATE
        //get the center and transform the path so it's centered at the origin
        let bounds = path.cgPath.boundingBox
        let center = CGPoint(x:bounds.midX, y:bounds.midY)
        
        let toOrigin = CGAffineTransform(translationX: -center.x, y: -center.y)
        path.apply(toOrigin)
        
        //rotate around the origin
        let rotAngle = inputRotationAngle * CGFloat(M_PI) / 180
        let rotation = CGAffineTransform(rotationAngle: CGFloat(rotAngle))
        path.apply(rotation)
        
        //translate back to the origin
        let fromOrigin = CGAffineTransform(translationX: center.x, y: center.y)
        path.apply(fromOrigin)
        
        return path.cgPath
    }
    
}//end of class
