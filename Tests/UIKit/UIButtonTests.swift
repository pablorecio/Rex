//
//  UIButtonTests.swift
//  Rex
//
//  Created by Andy Jacobs on 21/08/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import UIKit
import XCTest
import enum Result.NoError

class UIButtonTests: XCTestCase {
    weak var _button: UIButton?
    
    override func tearDown() {
        XCTAssert(_button == nil, "Retain cycle detected in UIButton properties")
        super.tearDown()
    }
    
    func testEnabledPropertyDoesntCreateRetainCycle() {
        let button = UIButton(frame: .zero)
        _button = button
        
        button.reactive.isEnabled <~ SignalProducer(value: false)
        XCTAssert(_button?.isEnabled == false)
    }

    func testPressedPropertyDoesntCreateRetainCycle() {
        let button = UIButton(frame: .zero)
        _button = button

        let action = Action<(),(),NoError> {
            SignalProducer(value: ())
        }
        button.reactive.pressed = CocoaAction(action, input: ())
    }

    func testTitlePropertyDoesntCreateRetainCycle() {
        let button = UIButton(frame: .zero)
        _button = button

        button.reactive.title <~ SignalProducer(value: "button")
        XCTAssert(_button?.title(for: UIControlState()) == "button")
    }
    
    func testTitleProperty() {
        let firstTitle = "First title"
        let secondTitle = "Second title"
        let button = UIButton(frame: .zero)
        let (pipeSignal, observer) = Signal<String, NoError>.pipe()
        button.reactive.title <~ SignalProducer(signal: pipeSignal)
        button.setTitle("", for: .selected)
        button.setTitle("", for: .highlighted)
        
        observer.send(value: firstTitle)
        XCTAssertEqual(button.title(for: .normal), firstTitle)
        XCTAssertEqual(button.title(for: .highlighted), "")
        XCTAssertEqual(button.title(for: .selected), "")
        
        observer.send(value: secondTitle)
        XCTAssertEqual(button.title(for: .normal), secondTitle)
        XCTAssertEqual(button.title(for: .highlighted), "")
        XCTAssertEqual(button.title(for: .selected), "")
    }
    
    func testPressedProperty() {
        let button = UIButton(frame: .zero)
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        
        let pressed = MutableProperty(false)
        let action = Action<(), Bool, NoError> { _ in
            SignalProducer(value: true)
        }
        
        pressed <~ SignalProducer(signal: action.values)
        
        button.reactive.pressed = CocoaAction(action)
        XCTAssertFalse(pressed.value)
        
        button.sendActions(for: .touchUpInside)
        XCTAssertTrue(pressed.value)
    }
}
