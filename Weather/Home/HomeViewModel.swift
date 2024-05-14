import Foundation

struct HomeState {
    let title: String
}

final class HomeViewModel {
    let state = HomeState(title: "Home")
}
