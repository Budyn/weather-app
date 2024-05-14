struct DetailViewState {
    let title: String
}

struct DetailPresenter {
    func makeViewState(from state: DetailState) -> DetailViewState {
        DetailViewState(title: state.title)
    }
}
