import Foundation
import FirebaseAuth

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

enum AuthenticationFlow {
  case login
  case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email: String = "motiw@icloud.com"
    @Published var password: String = "123456"
    @Published var confirmPassword: String = ""

    @Published var flow: AuthenticationFlow = .login

    @Published var isValid: Bool  = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    @Published var user: User?
    @Published var errorMessage: String = ""
    @Published var displayName: String = ""
    static var shared = AuthenticationViewModel()
    private init() {
        registerAuthStateHandler()

        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .assign(to: &$isValid)
    }
    func registerAuthStateHandler() {
        if authStateHandle == nil {
            authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? ("unknown")
            }
        }
    }
    
    func switchFlow() {
        switch flow {
        case .login: flow = .signUp
        case .signUp: flow = .login
        }
    }
    
    private func wait() async {
      do {
        print("Wait")
        try await Task.sleep(nanoseconds: 1_000_000_000)
        print("Done")
      }
      catch { }
    }
    
    func reset() {
//        flow = .login
//        email = ""
//        password = ""
//        confirmPassword = ""
    }
}

extension AuthenticationViewModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            return true
        } catch {
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            return true
        } catch {
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signOut() {
//        authenticationState = .unauthenticated
    }
    
    func deleteAccount() async -> Bool {
//        authenticationState = .unauthenticated
        return true
    }
}
