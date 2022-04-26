//
//  UserViewModel.swift
//  CombineWithSwiftUI
//
//  Created by Дмитрий Дуденин on 18.04.2022.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var passwordAgain = ""
    
    @Published var usernameMessage = ""
    @Published var passwordMessage = ""
    @Published var isValid = false
    
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        self.$username
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.count >= 3
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
            }
            .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $passwordAgain)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { password, passwordAgain in
                return password == passwordAgain
            }
            .eraseToAnyPublisher()
    }
    
    enum PasswordCheck {
        case valid
        case empty
        case noMatch
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordCheck, Never> {
        Publishers.CombineLatest(self.isPasswordEmptyPublisher,
                                 self.arePasswordsEqualPublisher)
            .map { passwordIsEmpty, passwordsAreEqual in
                if (passwordIsEmpty) {
                    return .empty
                } else if (!passwordsAreEqual) {
                    return .noMatch
                } else {
                    return .valid
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(self.isUsernameValidPublisher, self.isPasswordValidPublisher)
            .map { userNameIsValid, passwordIsValid in
                return userNameIsValid && (passwordIsValid == .valid)
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        self.isUsernameValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "User name must at least have 3 characters"
            }
            .assign(to: &$usernameMessage)
        
        self.isPasswordValidPublisher
            .receive(on: RunLoop.main)
            .map { passwordCheck in
                switch passwordCheck {
                case .empty:
                    return "Password must not be empty"
                case .noMatch:
                    return "Passwords don't match"
                default:
                    return ""
                }
            }
            .assign(to: &$passwordMessage)
        
        self.isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: &$isValid)
    }
}
