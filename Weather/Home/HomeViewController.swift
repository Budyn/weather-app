import RxCocoa
import RxSwift
import UIKit


class HomeViewController: UIViewController {

    private let tableView = UITableView()
    private let state: Driver<[WeatherRowViewState]>
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()

    init(state: Driver<[WeatherRowViewState]>, viewModel: HomeViewModel) {
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
            .bind(
                to: tableView.rx.items(cellIdentifier: "WeatherCell", cellType: WeatherRowView.self)
            ) { index, state, cell in

            }
            .disposed(by: disposeBag)

        viewModel.requestWeatherForecast()
    }

    private func setup() {
        view.backgroundColor = .systemBackground

        tableView.register(
            WeatherRowView.self,
            forCellReuseIdentifier: "WeatherCell"
        )

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

private final class WeatherRowView: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundView?.backgroundColor = .label
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
