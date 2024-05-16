import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.window = buildAppWindow()
        return true
    }

    private func buildAppWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)

        window.rootViewController = buildHome()
        window.makeKeyAndVisible()

        return window
    }

    private func buildHome() -> UIViewController {
        let dataFetcher = DataFetcher(urlSession: .shared)
        let weatherService = WeatherServiceImpl(dataFetcher: dataFetcher)
        let weatherRepository = WeatherRepositoryImpl(weatherService: weatherService)
        let navigationController = UINavigationController()
        let viewModel = HomeViewModelImpl(
            router: HomeRouter(navigationController: navigationController),
            weatherRepository: weatherRepository
        )
        let viewController = HomeViewController(
            state: viewModel.state.map(HomePresenter().makeViewState(from:)),
            viewModel: viewModel
        )

        navigationController.setViewControllers([viewController], animated: false)

        return navigationController
    }
}
