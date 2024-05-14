import UIKit

class HomeViewController: UIViewController {

    private let state: HomeViewState
    private let viewModel: HomeViewModel

    init(state: HomeViewState, viewModel: HomeViewModel) {
        self.state = state
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.requestWeatherForecast()
    }

    private func setup() {
        view.backgroundColor = .red
    }
}
