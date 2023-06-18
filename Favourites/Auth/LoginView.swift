import SwiftUI
import FirebaseAnalyticsSwift
private enum FocusableField: Hashable {
    case email
    case password
}

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: FocusableField?
    var body: some View {
        VStack {
            Image("Login")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 300, maxHeight: 400)
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Image(systemName: "at")
                TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .password
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 4)
            
            HStack {
                Image(systemName: "lock")
                SecureField("Password", text: $viewModel.password)
                    .focused($focus, equals: .password)
                    .submitLabel(.go)
                    .onSubmit(signInWithEmailPassword)
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            
            Button(action: signInWithEmailPassword) {
                Group {
                    if viewModel.authenticationState != .authenticating {
                        Text("Login")
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
            }
            .disabled(!viewModel.isValid)
            .buttonStyle(.borderedProminent)
            
            HStack {
                Text("Don't have an account yet?")
                Button(action: {viewModel.switchFlow()}) {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                }
            }
            .padding(.vertical, 50)
        }
        .padding()
        .analyticsScreen(name: "\(Self.self)")
    }
    
    private func signInWithEmailPassword() {
        Task {
            if await viewModel.signInWithEmailPassword() == true {
                dismiss()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationViewModel())
    }
}
