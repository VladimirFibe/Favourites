import SwiftUI
import FirebaseAnalyticsSwift

private enum FocusableField: Hashable {
  case email
  case password
  case confirmPassword
}

struct SignUpView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: FocusableField?
    var body: some View {
        VStack {
            Image("SignUp")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 300, maxHeight: 400)
            Text("Sign Up")
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
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .confirmPassword
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            
            HStack {
                Image(systemName: "lock")
                SecureField("Confirm password", text: $viewModel.confirmPassword)
                    .focused($focus, equals: .password)
                    .submitLabel(.go)
                    .onSubmit(signUpWithEmailPassword)
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
            }
            Button(action: signUpWithEmailPassword) {
                Group {
                    if viewModel.authenticationState != .authenticating {
                        Text("Sign Up")
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
                Text("Already have an account?")
                Button(action: {viewModel.switchFlow()}) {
                    Text("Log in")
                        .fontWeight(.semibold)
                }
            }
            .padding(.vertical, 50)
        }
        .padding()
        .analyticsScreen(name: "\(Self.self)")
    }
    
    private func signUpWithEmailPassword() {
        Task {
            if await viewModel.signUpWithEmailPassword() == true {
                dismiss()
            }
        }
    }
}
//
//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//            .environmentObject(AuthenticationViewModel())
//    }
//}
