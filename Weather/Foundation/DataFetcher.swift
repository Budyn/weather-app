import Foundation
import RxSwift

protocol DataFetching {
    func data<T: Decodable>(for request: URLRequest) -> Single<T>
}

enum DataFetchingError: Error {
    case deallocated
    case statusCode(Int)
    case missingData
    case decoding
}

final class DataFetcher: DataFetching {
    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func data<T: Decodable>(for request: URLRequest) -> Single<T> {
        Single.create { single in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }

                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 200 {
                    single(.failure(DataFetchingError.statusCode(statusCode)))
                    return
                }

                guard let data = data else {
                    single(.failure(DataFetchingError.missingData))
                    return
                }

                do {
                    let response = try JSONDecoder().decode(T.self, from: data)

                    single(.success(response))
                } catch {
                    single(.failure(DataFetchingError.decoding))
                    return
                }

            }

            task.resume()

            return Disposables.create { task.cancel() }
        }
    }
}
