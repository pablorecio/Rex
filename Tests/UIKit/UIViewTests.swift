//
//  UIViewTests.swift
//  Rex
//
//  Created by Andy Jacobs on 21/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import UIKit
import XCTest
import enum Result.NoError

class UIViewTests: XCTestCase {
    
    weak var _view: UIView?
    
    override func tearDown() {
        XCTAssert(_view == nil, "Retain cycle detected in UIView properties")
        super.tearDown()
    }
    
    func testAlphaPropertyDoesntCreateRetainCycle() {
        let view = UIView(frame: .zero)
        _view = view
        
        view.reactive.alpha <~ SignalProducer(value: 0.5)
        XCTAssertEqualWithAccuracy(_view!.alpha, 0.5, accuracy: 0.01)
    }
    
    func testHiddenPropertyDoesntCreateRetainCycle() {
        let view = UIView(frame: .zero)
        _view = view
        
        view.reactive.isHidden <~ SignalProducer(value: true)
        XCTAssert(_view?.isHidden == true)
    }
    
    func testHiddenProperty() {
        let view = UIView(frame: .zero)
        view.isHidden = true
        
        let (pipeSignal, observer) = Signal<Bool, NoError>.pipe()
        view.reactive.isHidden <~ SignalProducer(signal: pipeSignal)
        
        observer.send(value: true)
        XCTAssertTrue(view.isHidden)
        observer.send(value: false)
        XCTAssertFalse(view.isHidden)
    }
    
    func testAlphaProperty() {
        let view = UIView(frame: .zero)
        view.alpha = 0.0
        
        let firstChange = CGFloat(0.5)
        let secondChange = CGFloat(0.7)
        
        let (pipeSignal, observer) = Signal<CGFloat, NoError>.pipe()
        view.reactive.alpha <~ SignalProducer(signal: pipeSignal)
        
        observer.send(value: firstChange)
        XCTAssertEqualWithAccuracy(view.alpha, firstChange, accuracy: 0.01)
        observer.send(value: secondChange)
        XCTAssertEqualWithAccuracy(view.alpha, secondChange, accuracy: 0.01)
    }
    
    func testUserInteractionEnabledProperty() {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = true
        
        let (pipeSignal, observer) = Signal<Bool, NoError>.pipe()
        view.reactive.isUserInteractionEnabled <~ SignalProducer(signal: pipeSignal)
        
        observer.send(value: true)
        XCTAssertTrue(view.isUserInteractionEnabled)
        observer.send(value: false)
        XCTAssertFalse(view.isUserInteractionEnabled)
    }
}
