//
// Copyright (c) 2017 Mellong Lau
// https://github.com/MellongLau/CocoRongPullToRefresh
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

class LoadingCircletView: UIView, LoadingView {

    public func stopLoadingAnimation() {
        shapeLayer.removeAllAnimations()
    }
    
    public func reset() {
        shapeLayer.strokeEnd = 0
    }
    
    public func setProgress(progress: CGFloat) {
        shapeLayer.strokeEnd = progress
        
    }
    
    public func startLoadingAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.repeatCount = Float.infinity
        animation.toValue = .pi * 2.0
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isAdditive = true
        animation.duration = 1.0
        shapeLayer.add(animation, forKey: "RotationAnimation")
    }
    
    private var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 8.0
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.strokeEnd = 0
        return layer
    }()
    
    private func drawPath(center: CGPoint, radius: Double) -> CGPath {
        let path = UIBezierPath()
        path.addArc(withCenter: center,
                    radius: CGFloat(radius),
                    startAngle: CGFloat(-Double.pi / 2.0),
                    endAngle: CGFloat(Double.pi * 2.0 - Double.pi / 2.0),
                    clockwise: true)
        return path.cgPath
    }
    
    public func setup() {
        
        shapeLayer.path = drawPath(center: CGPoint.zero, radius: Double(CRCongfiguration.radius))
        layer.addSublayer(shapeLayer)
        backgroundColor = UIColor.clear
        
        let getCenterPosition = { (radius: CGFloat, degree: CGFloat) -> CGPoint in
            let calculatedDegree = degree
            return CGPoint(x: cos(calculatedDegree)*radius, y: sin(calculatedDegree)*radius)
        }
        
        let drawCircle = { (center: CGPoint, radius: CGFloat) -> CALayer in
            let layer = CAShapeLayer()
            layer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(-Double.pi / 2.0), endAngle: CGFloat(.pi * 2.0 - Double.pi / 2.0), clockwise: true).cgPath
            
            return layer
            
        }
        
        let getDegreeDelta = { (preRadius: CGFloat, radius: CGFloat, distanceDelta: CGFloat, radiusDelta: CGFloat) -> CGFloat in
            return asin((preRadius + distanceDelta + preRadius + radiusDelta) / 2.0 / radius) * 2.0
        }
        
        // Draw circlet mask
        let radiusDelta: CGFloat = 0.2
        let distanceDelta:CGFloat = 4.0
        
        var degree: CGFloat = CGFloat(-Double.pi / 2.0 + 0.1)
        let radius: CGFloat = CRCongfiguration.radius
        var currentRadius: CGFloat = 1.0
        var layerList:[CALayer] = []
        while degree <= CGFloat(.pi * 2.0 - Double.pi / 2.0 + 0.1) {
            
            currentRadius += radiusDelta
            
            let center = getCenterPosition(radius, degree)
            let circleLayer = drawCircle(center, currentRadius)
            layerList.append(circleLayer)
            
            degree += getDegreeDelta(currentRadius, radius, distanceDelta, radiusDelta)
            
        }
        // Avoid overlap
        layerList.removeLast()
        
        // Apply mask
        let maskLayer = CALayer()
        for item in layerList {
            maskLayer.addSublayer(item)
        }
        shapeLayer.mask = maskLayer
    }
}

class LoadingRectangleView: UIView, LoadingView {
    
    public func stopLoadingAnimation() {
        shapeLayer.removeAllAnimations()
    }

    public func reset() {
        shapeLayer.strokeEnd = 0
    }

    public func setProgress(progress: CGFloat) {
        shapeLayer.strokeEnd = progress
    }

    public func startLoadingAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.repeatCount = Float.infinity
        animation.toValue = .pi * 2.0
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isAdditive = true
        animation.duration = 1.0
        shapeLayer.add(animation, forKey: "RotationAnimation")
    }

    public func setup() {
        let path = UIBezierPath(roundedRect: CGRect(x:-10, y:-10, width: 20, height: 20), cornerRadius: 2)
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
        backgroundColor = UIColor.clear
    }

    private var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 2.0
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.strokeEnd = 0
        return layer
    }()
}

class LoadingCircleView: UIView, LoadingView {
    
    private var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 2.0
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.strokeEnd = 0
        return layer
    }()

    public func setup() {
        shapeLayer.path = drawPath(center: CGPoint.zero, radius: Double(CRCongfiguration.radius))
        layer.addSublayer(shapeLayer)
        backgroundColor = UIColor.clear
    }
    
    public func setProgress(progress: CGFloat) {
        shapeLayer.strokeEnd = progress
    }
    
    public func reset() {
        
        shapeLayer.strokeEnd = 0
        
    }
    
    public func startLoadingAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.repeatCount = Float.infinity
        animation.toValue = .pi * 2.0
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isAdditive = true
        animation.duration = 1.0
        shapeLayer.add(animation, forKey: "RotationAnimation")
    }
    
    public func stopLoadingAnimation() {
        shapeLayer.removeAllAnimations()
    }
    
    private func drawPath(center: CGPoint, radius: Double) -> CGPath {
        let path = UIBezierPath()
        path.addArc(withCenter: center,
                    radius: CGFloat(radius),
                    startAngle: CGFloat(-Double.pi / 2.0),
                    endAngle: CGFloat(.pi * 1.8 - Double.pi / 2.0),
                    clockwise: true)
        return path.cgPath
    }
}

