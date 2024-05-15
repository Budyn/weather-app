import RxCocoa
import RxSwift
import UIKit

class DetailViewController: UIViewController {

    private let tableView = UITableView()
    private let state: Driver<DetailViewState>
    private let disposeBag = DisposeBag()

    init(state: Driver<DetailViewState>) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setup()

        state
            .asObservable()
            .do(onNext: { [weak self] in self?.update(state: $0) })
            .map { $0.rows }
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: WeatherRowView.self)) {
                $2.update(state: $1)
            }
            .disposed(by: disposeBag)
    }

    private func setup() {
        view.backgroundColor = .systemBackground
        tableView.allowsSelection = false
        tableView.register(WeatherRowView.self, forCellReuseIdentifier: "Cell")
    }

    private func layout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        tableView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor
        ).isActive = true
        tableView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor
        ).isActive = true
        tableView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor
        ).isActive = true
        tableView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor
        ).isActive = true
    }

    private func update(state: DetailViewState) {
        title = state.title
    }
}
