//
//  CombineWithSwiftUITests.swift
//  CombineWithSwiftUITests
//
//  Created by Дмитрий Дуденин on 18.04.2022.
//

import XCTest
import Combine
@testable import CombineWithSwiftUI

class CombineWithSwiftUITests: XCTestCase {
    
    var viewModel: UserViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        do {
            try super.setUpWithError()
        } catch let error {
            throw error
        }
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewModel = UserViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.subscriptions = []
        viewModel = nil
        
        do {
            try super.tearDownWithError()
        } catch let error {
            throw error
        }
    }
    
    func testEmptyUsername() {
        let expected = "User name must at least have 3 characters"
        var result = ""
        
        // Given
        viewModel.$usernameMessage
            .sink { result = $0 }
            .store(in: &subscriptions)
        
        // When
        viewModel.username = ""
        viewModel.password = "123"
        viewModel.passwordAgain = "123"
        
        _ = XCTWaiter.wait(for: [.init(description: "Subscription")], timeout: 1)
        
        // Then
        XCTAssert(
            result == expected,
            "Wrong username. Expected: \(expected), result: \(result)")
    }

    func testEmptyPassword() {
        let expected = "Password must not be empty"
        var result = ""
        
        // Given
        viewModel.$passwordMessage
            .sink { result = $0 }
            .store(in: &subscriptions)
        
        // When
        viewModel.username = "username"
        viewModel.password = ""
        viewModel.passwordAgain = "123"
        
        _ = XCTWaiter.wait(for: [.init(description: "Subscription")], timeout: 1)
        
        // Then
        XCTAssert(
            result == expected,
            "Wrong password. Expected: \(expected), result: \(result)")
    }
    
    func testDifferentPassword() {
        let expected = "Passwords don't match"
        var result = ""
        
        // Given
        viewModel.$passwordMessage
            .sink { result = $0 }
            .store(in: &subscriptions)
        
        // When
        viewModel.username = "username"
        viewModel.password = "1234"
        viewModel.passwordAgain = "123"
        
        _ = XCTWaiter.wait(for: [.init(description: "Subscription")], timeout: 1)
        
        // Then
        XCTAssert(
            result == expected,
            "Wrong password. Expected: \(expected), result: \(result)")
    }
    
    
    func testSuccessRegistration() {
        var resultUsername = ""
        var resultPassword = ""
        
        // Given
        viewModel.$usernameMessage
            .sink { resultUsername = $0 }
            .store(in: &subscriptions)
        viewModel.$passwordMessage
            .sink { resultPassword = $0 }
            .store(in: &subscriptions)
        
        // When
        viewModel.username = "username"
        viewModel.password = "123"
        viewModel.passwordAgain = "123"
        
        _ = XCTWaiter.wait(for: [.init(description: "Subscription")], timeout: 1)
        
        // Then
        XCTAssert(
            resultUsername.isEmpty,
            "Wrong username: \(resultUsername)")
        XCTAssert(
            resultPassword.isEmpty,
            "Wrong password: \(resultPassword)")
    }
}

