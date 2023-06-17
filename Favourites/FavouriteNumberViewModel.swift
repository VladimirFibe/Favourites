import Foundation
import Combine
import FirebaseAnalytics
import FirebaseAnalyticsSwift

final class FavouriteNumberViewModel: ObservableObject {
    @Published var favouriteNumber = 42
    private var defaults = UserDefaults.standard
    private let favouriteNumberKey = "favouriteNumber"
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        if let number = defaults.object(forKey: favouriteNumberKey) as? Int {
            favouriteNumber = number
        }
        $favouriteNumber
            .sink { number in
                self.defaults.set(number, forKey: self.favouriteNumberKey)
                Analytics.logEvent("stepper", parameters: ["value": number])
            }
            .store(in: &cancellables)
    }
}
