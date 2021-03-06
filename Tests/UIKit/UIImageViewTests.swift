//
//  UIImageViewTests.swift
//  Rex
//
//  Created by Andy Jacobs on 21/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import UIKit
import XCTest
import enum Result.NoError

class UIImageViewTests: XCTestCase {
    
    weak var _imageView: UIImageView?
    
    override func tearDown() {
        XCTAssert(_imageView == nil, "Retain cycle detected in UIImageView properties")
        super.tearDown()
    }
    
    func testImagePropertyDoesntCreateRetainCycle() {
        let imageView = UIImageView(frame: .zero)
        _imageView = imageView
        
        let image = UIImage()
        
        imageView.reactive.image <~ SignalProducer(value: image)
        XCTAssert(_imageView?.image == image)
    }
    
    func testHighlightedImagePropertyDoesntCreateRetainCycle() {
        let imageView = UIImageView(frame: .zero)
        _imageView = imageView
        
        let image = UIImage()
        
        imageView.reactive.highlightedImage <~ SignalProducer(value: image)
        XCTAssert(_imageView?.highlightedImage == image)
    }
    
    func testImageProperty() {
        let imageView = UIImageView(frame: .zero)
        
        let firstChange = UIImage()
        let secondChange = UIImage()
        
        let (pipeSignal, observer) = Signal<UIImage?, NoError>.pipe()
        imageView.reactive.image <~ SignalProducer(signal: pipeSignal)
        
        observer.send(value: firstChange)
        XCTAssertEqual(imageView.image, firstChange)
        observer.send(value: secondChange)
        XCTAssertEqual(imageView.image, secondChange)
    }
    
    func testHighlightedImageProperty() {
        let imageView = UIImageView(frame: .zero)
        
        let firstChange = UIImage()
        let secondChange = UIImage()
        
        let (pipeSignal, observer) = Signal<UIImage?, NoError>.pipe()
        imageView.reactive.highlightedImage <~ SignalProducer(signal: pipeSignal)
        
        observer.send(value: firstChange)
        XCTAssertEqual(imageView.highlightedImage, firstChange)
        observer.send(value: secondChange)
        XCTAssertEqual(imageView.highlightedImage, secondChange)
    }
}
