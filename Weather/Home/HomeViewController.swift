import RxCocoa
import RxSwift
import UIKit

class HomeViewController: UIViewController {

    private let tableView = UITableView()

    private let state: Driver<HomeViewState>
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()

    init(state: Driver<HomeViewState>, viewModel: HomeViewModel) {
        self.state = state
        self.viewModel = viewModel
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

        viewModel.requestWeatherForecast()
    }

    private func update(state: HomeViewState) {
        title = state.title
    }

    private func setup() {
        view.backgroundColor = .systemBackground

        tableView.register(WeatherRowView.self, forCellReuseIdentifier: "Cell")

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
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
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}
