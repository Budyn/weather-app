import UIKit

class HomeViewController: UIViewController {

    private let state: HomeViewState

    init(state: HomeViewState) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        view.backgroundColor = .red
    }
}
