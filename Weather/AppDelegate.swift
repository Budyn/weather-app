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
        let weatherService = WeatherServiceImpl()
        let weatherRepository = WeatherRepositoryImpl(weatherService: weatherService)
        let viewModel = HomeViewModel(weatherRepository: weatherRepository)
        let viewController = HomeViewController(
            state: viewModel.state.map(HomePresenter().makeViewState(from:)),
            viewModel: viewModel
        )

        return UINavigationController(rootViewController: viewController)
    }
}
