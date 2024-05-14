struct HomeViewState {
    let title: String
}

struct HomePresenter {
    func makeViewState(from state: HomeState) -> HomeViewState {
        HomeViewState(title: state.title)
    }
}
