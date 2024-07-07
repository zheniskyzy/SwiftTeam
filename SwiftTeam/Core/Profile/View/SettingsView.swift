//
//  SettingsView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 07.07.2024.
//

import SwiftUI
import SwiftfulRouting
import Firebase

struct SettingsView: View {
    @Environment(\.router) var router
    
    @StateObject private var viewModel = SettingsViewModel()
    @AppStorage("log_Status") private var logStatus: Bool = false
    
    @State private var showDeleteView: Bool = false
    
    var body: some View {
        VStack {
            
            HeaderView()
            
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                   
                    
                    Button(action: {
                        Task {
                            do {
                                try viewModel.signOut()
                                logStatus = false
                                router.dismissScreen()
                            } catch {
                                print(error)
                            }
                        }
                    }, label: {
                        Text("Log out")
                    })
                    
                    Button(role: .destructive) {
                        showDeleteView = true
//                        Task {
//                            do {
//                                try await viewModel.deleteAccount()
//                                logStatus = false
//                                router.dismissScreen()
//                            } catch {
//                                print(error)
//                            }
//                        }
                    } label: {
                        Text("Delete account")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal, .top])
            }
            .blur(radius: showDeleteView ? 2 : 0)
            .disabled(showDeleteView)
            .scrollIndicators(.hidden)
            .navigationBarBackButtonHidden()
        }
        .overlay {
            if showDeleteView {
                DeleteAccountView(onSubmit: {
                    Task {
                        do {
                            try await viewModel.deleteAccount()
                            logStatus = false
                            router.dismissScreen()
                        } catch {
                            print(error)
                        }
                    }
                    showDeleteView = false
                }, onClose: {
                    showDeleteView = false
                })
                .transition(.move(edge: .leading))
            }
        }
        .animation(.snappy, value: showDeleteView)
        .background {
            Color.theme.bgTabColor
                .ignoresSafeArea()
        }
    }
    
    
    // MARK: - Header
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                
                Image(systemName: "arrow.left.circle")
                    .font(.system(size: 26))
                    .fontWeight(.light)
                        .foregroundStyle(.primary.opacity(0.7))
                        .onTapGesture {
                            router.dismissScreen()
                        }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Settings")
                        .font(.system(size: 23, weight: .semibold, design: .default))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            
            Divider()
                .offset(y: 10)
        }
    }
    
}

#Preview {
    RouterView { _ in
        SettingsView()
    }
}
