import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State var presentingConfirmationDialog = false
    var body: some View {
        Form {
            Section {
                VStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .padding(4)
                        .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
                        .frame(maxWidth: .infinity)
                    Button(action: {}) {
                        Text("Edit")
                    }
                }
            }
            .listRowBackground(Color.clear)
            
            Section("Email") {
                Text(viewModel.displayName)
            }
            
            Section {
                Button(role: .cancel, action: signOut) {
                    Text("Sign out")
                        .frame(maxWidth: .infinity)
                }
            }
            
            Section {
                Button(role: .destructive, action: { presentingConfirmationDialog.toggle() }) {
                    Text("Delete Account")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .analyticsScreen(name: "\(Self.self)")
        .confirmationDialog(
            "Deleting you account is permanent. Do you want to delete your account?",
            isPresented: $presentingConfirmationDialog,
            titleVisibility: .visible) {
            Button("Delete Account", role: .destructive, action: deleteAccount)
            Button("Cancel", role: .cancel, action: {})
        }
    }
    
    private func deleteAccount() {
        Task {
            if await viewModel.deleteAccount() == true {
                dismiss()
            }
        }
    }
    
    private func signOut() {
        viewModel.signOut()
    }
}
//
//struct UserProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            UserProfileView()
//        }
//        .environmentObject(AuthenticationViewModel())
//
//    }
//}
