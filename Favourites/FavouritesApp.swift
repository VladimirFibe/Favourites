import SwiftUI
import FirebaseCore

@main
struct FavouritesApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            content
        }
    }
    var content: some View {
        AuthenticatedView {
            Image(systemName: "number.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.pink)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
            Text("Welcome to Favourites!")
                .font(.title)
            Text("You need to be logged in to use this app.")
        } content: {
            FavouriteNumberView()
            Spacer()
        }
    }
}
