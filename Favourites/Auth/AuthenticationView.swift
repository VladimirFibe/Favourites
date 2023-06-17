import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var body: some View {
        VStack {
            switch viewModel.flow {
            case .login:
                LoginView()
            case .signUp:
                SignUpView()
            }
        }
    }
}
//
//struct AuthenticationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthenticationView()
//            .environmentObject(AuthenticationViewModel())
//    }
//}
