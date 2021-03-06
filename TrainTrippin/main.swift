//
//  main.swift
//  TrainTrippin
//
//  Created by Maciek on 18.10.2016.
//  Copyright © 2016 Fortunity. All rights reserved.
//

import UIKit
import Foundation

final class MockAppDelegate: UIResponder, UIApplicationDelegate {}

private func appDelegateClassName() -> String {
    let isTesting = NSClassFromString("XCTestCase") != nil
    return
        NSStringFromClass(isTesting ? MockAppDelegate.self : AppDelegate.self)
}

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc)),
    NSStringFromClass(UIApplication.self), appDelegateClassName()
)
