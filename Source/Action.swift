//
//  Action.swift
//  Rex
//
//  Created by Neil Pankey on 6/19/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import enum Result.NoError

extension Action {
    /// Creates an always disabled action.
    public static var rex_disabled: Action<Input, Output, Error> {
        return Action(enabledIf: Property(value: false)) { _ in .empty }
    }
    
    /// Whether the action execution was started.
    public var rex_started: Signal<Void, NoError> {
        return self.isExecuting.signal
            .filterMap { $0 ? () : nil }
    }

    /// Whether the action execution was completed successfully.
    public var rex_completed: Signal<Void, NoError> {
        return events
            .filterMap { event -> Void? in
                if case .completed = event {
                    return ()
                } else {
                    return nil
                }
            }
    }
}

extension CocoaAction {
    /// Creates an always disabled action that can be used as a default for
    /// things like `rac_pressed`.
    public static var rex_disabled: CocoaAction {
        return CocoaAction(Action<Any?, (), NoError>.rex_disabled, input: nil)
    }
}
