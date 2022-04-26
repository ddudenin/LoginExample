//
//  ContentView.swift
//  CombineWithSwiftUI
//
//  Created by Дмитрий Дуденин on 16.04.2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var userViewModel = UserViewModel()
    @State var presentAlert = false
    
    var body: some View {
        Form {
            Section(footer: Text(self.userViewModel.usernameMessage).foregroundColor(.red)) {
                TextField("Username", text: self.$userViewModel.username)
                    .autocapitalization(.none)
            }
            Section(footer: Text(self.userViewModel.passwordMessage).foregroundColor(.red)) {
                SecureField("Password", text: self.$userViewModel.password)
                SecureField("Password again", text: self.$userViewModel.passwordAgain)
            }
            Section {
                Button(action: { self.signUp() }) {
                    Text("Sign up")
                }.disabled(!self.userViewModel.isValid)
            }
        }
        .sheet(isPresented: self.$presentAlert) {
            SuccessLoginView()
        }
    }
    
    func signUp() {
        self.presentAlert = true
    }
}

struct SuccessLoginView: View {
    var body: some View {
        Text("Welcome!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
