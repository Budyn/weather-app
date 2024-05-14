import UIKit

class DetailViewController: UIViewController {

    private let state: DetailViewState

    init(state: DetailViewState) {
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
