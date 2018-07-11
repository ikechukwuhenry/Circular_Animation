//
//  ViewController.swift
//  Circule_Animation
//
//  Created by Ikechukwu Michael on 10/07/2018.
//  Copyright © 2018 Anyskills.co.uk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {

    
    var shapeLayer = CAShapeLayer()
    var trackLayer = CAShapeLayer()
    var pulsatingLayer = CAShapeLayer()
    
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    private func setUpNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground , object: nil)
    }
    
    @objc private func handleEnterForeground(){
        animatePulsatingLayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.backgroundColor
        setUpNotificationObserver()
        
        setUpLayers()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        setupPercentageLabel()
    }
    
    
    
    private func setupPercentageLabel() {
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
    }
    
    private func setUpLayers(){
        trackLayer = self.genericLayer(fillColor: UIColor.backgroundColor, strokeColor: UIColor.trackStrokeColor)
        shapeLayer = self.genericLayer(fillColor: UIColor.clear, strokeColor: UIColor.outlineStrokeColor)
        shapeLayer.strokeEnd = 0
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        pulsatingLayer = genericLayer(fillColor: UIColor.pulsatingFillColor, strokeColor: UIColor.clear)
        
        animatePulsatingLayer()
        
        view.layer.addSublayer(pulsatingLayer)
        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(shapeLayer)
    }
    
    fileprivate func animateCiricle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basic animation")
    }
    
    fileprivate func animatePulsatingLayer(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsating")
        
    }
    
//      let urlString = "https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c"
    // let urlString = "https://www.youtube.com/watch?v=ZqBtsSGrh1g"
    let urlString = "https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c"
    
        // let   urlString = "https://www.youtube.com/watch?v=ma_TmLmBdQU"
    
    private func beginDownloadingFile(){
        print("download is ongoing")
        shapeLayer.strokeEnd = 0
        
        let configuration = URLSessionConfiguration.default
        let opQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: opQueue)
        guard let url = URL(string: urlString) else { return  }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        
      
    }
    
    @objc private func handleTap(gesture: UITapGestureRecognizer){
        beginDownloadingFile()
        // animateCiricle()
        
    }

    func genericLayer(fillColor: UIColor, strokeColor: UIColor) -> CAShapeLayer {
        let genericLayer = CAShapeLayer()
        //  start position at 0 is 3 o clock position
    
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        genericLayer.path = circularPath.cgPath
        genericLayer.strokeColor = strokeColor.cgColor
        genericLayer.fillColor = fillColor.cgColor
        genericLayer.lineWidth = 20
        // genericLayer.fillColor = UIColor.clear.cgColor
        genericLayer.position = view.center
        return genericLayer
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("download finish")
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        print(totalBytesWritten, totalBytesExpectedToWrite)
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite )
        DispatchQueue.main.async {
            print(percentage)
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
        }
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

