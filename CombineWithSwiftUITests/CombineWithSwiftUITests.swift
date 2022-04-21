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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewModel = UserViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.subscriptions = []
        viewModel = nil
    }
    
    func testFilterText() {
        let expected = ""
        var result = ""
        viewModel.$usernameMessage
            .sink { result = $0 }
            .store(in: &subscriptions)
        // When
        viewModel.username = "username"
        viewModel.password = "123"
        viewModel.passwordAgain = "123"
        
        // Then
        XCTAssert(
            result == expected,
            "Wrong login. Expected: \(expected), result: \(result)")
    }
    
}
