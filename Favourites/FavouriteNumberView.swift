import SwiftUI
import FirebaseAnalyticsSwift

struct FavouriteNumberView: View {
    @StateObject var viewModel = FavouriteNumberViewModel()
    var body: some View {
        VStack {
            Text("What's your favourite number?")
                .font(.title)
                .multilineTextAlignment(.center)
            Stepper(value: $viewModel.favouriteNumber, in: 0...100) {
                Text("\(viewModel.favouriteNumber)")
            }
        }
        .frame(maxHeight: 150)
        .foregroundColor(.white)
        .padding()
        .background(Color.pink)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding()
        .shadow(radius: 8)
        .analyticsScreen(name: "\(FavouriteNumberView.self)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteNumberView()
    }
}
