// RootView.swift

import SwiftUI

struct RootView: View {
    
    @State var showApiKey = false
    
    @AppStorage("apiKey") var apiKey = ""
    
    @FocusState var focused: Bool
    
    @StateObject var viewModel = RootViewModel()
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .center, spacing: 5) {
                    ForEach(viewModel.messages) { message in
                        HStack(alignment: .center, spacing: 0) {
                            if message.isOutgoing { Spacer() }
                            
                            Text(message.text.withRenderedCode())
                                .font(.title3)
                                .padding(5)
                                .background(.white)
                                .foregroundColor(.black)
                                .cornerRadius(15)
                                .frame(maxWidth: 400, alignment: message.isOutgoing ? .trailing : .leading)
                            
                            if !message.isOutgoing { Spacer() }
                        }
                        .padding(.horizontal)
                        .transition(.move(edge: .top))
                        .flippedUpsideDown()
                    }
                }
                .animation(.default, value: viewModel.messages)
            }
            .flippedUpsideDown()
            .onChange(of: viewModel.messages) { _ in
                withAnimation {
                    proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                }
            }
        }
        .frame(width: 500, height: 500)
        .frame(maxWidth: .infinity)
        .background(.black)
        .safeAreaInset(edge: .top) {
            VStack(alignment: .center, spacing: 1) {
                navigationBar
                
                if showApiKey {
                    SecureField("API Key", text: $apiKey)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            showApiKey.toggle()
                            focused = true
                        }
                        .zIndex(-1)
                        .background(.ultraThinMaterial)
                        .transition(.move(edge: .top))
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            textField
        }
        .onAppear {
            focused = true
            if apiKey.isEmpty {
                showApiKey.toggle()
            }
        }
    }
    
    @ViewBuilder var textField: some View {
        HStack(alignment: .center, spacing: 5) {
            TextField("Prompt...", text: $viewModel.prompt)
                .focused($focused)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    Task(priority: .userInitiated) {
                        await viewModel.sendMessage()
                    }
                }
        }
        .padding()
        .background(.ultraThinMaterial)
    }
    
    @ViewBuilder var navigationBar: some View {
        HStack(alignment: .center, spacing: 10) {
            navigationBarButton("xmark.app", role: .destructive) {
                exit(0)
            }
            
            Text("AlwaysChatGPT")
                .bold()
            
            navigationBarButton("key.fill", role: .cancel) {
                showApiKey.toggle()
            }
            
            Spacer()
            
            navigationBarButton("trash.fill", role: .destructive) {
                viewModel.clearMessages()
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .frame(alignment: .top)
    }
    
    @ViewBuilder func navigationBarButton(
        _ systemName: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(role: role) {
            action()
        } label: {
            Image(systemName: systemName)
                .foregroundColor(role == .destructive ? .red : role == .cancel ? .blue : .white)
        }
        .buttonStyle(.plain)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
