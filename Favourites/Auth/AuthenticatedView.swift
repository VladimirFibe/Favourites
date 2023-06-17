import SwiftUI

struct AuthenticatedView<Content, Unauthenticated>: View where Content: View, Unauthenticated: View {
    
    @StateObject private var viewModel = AuthenticationViewModel.shared
    @State private var presentingLoginScreen = false
    @State private var presentingProfileScreen = false
    
    var unauthnticated: Unauthenticated?
    @ViewBuilder var content: () -> Content
    
    public init(unauthenticated: Unauthenticated?, @ViewBuilder content: @escaping () -> Content) {
        self.unauthnticated = unauthenticated
        self.content = content
    }
    
    public init(@ViewBuilder unauthenticated: @escaping () -> Unauthenticated,
                @ViewBuilder content: @escaping () -> Content) {
        self.unauthnticated = unauthenticated()
        self.content = content
    }
    
    var body: some View {
        switch viewModel.authenticationState {
        case  .unauthenticated, .authenticating:
            VStack {
                
                if let unauthnticated { unauthnticated }
                else { Text("Yor're not logged in.")}
                Button("Tap here to log in") {
                    viewModel.reset()
                    presentingLoginScreen.toggle()
                }
                .buttonStyle(.borderedProminent)
            }
            .sheet(isPresented: $presentingLoginScreen) {
                AuthenticationView()
                    .environmentObject(viewModel)
            }
        case .authenticated:
            VStack {
                content()
                Text("You're logged in as \(viewModel.displayName).")
                Button("Tap here to view your profile") {
                    presentingProfileScreen.toggle()
                }
            }
            .sheet(isPresented: $presentingProfileScreen) {
                NavigationStack {
                    UserProfileView()
                        .environmentObject(viewModel)
                }
            }
        }
            
    }
}

extension AuthenticatedView where Unauthenticated == EmptyView {
    init(@ViewBuilder content: @escaping () -> Content) {
        self.unauthnticated = nil
        self.content = content
    }
}
