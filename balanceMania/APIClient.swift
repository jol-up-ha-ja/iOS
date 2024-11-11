import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum APIError: Error, LocalizedError {
    case invalidURL, noData, decodingError, serverError(statusCode: Int), custom(message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The URL is invalid."
        case .noData: return "No data received from the server."
        case .decodingError: return "Failed to decode the response."
        case .serverError(let statusCode): return "Server error with status code: \(statusCode)."
        case .custom(let message): return message
        }
    }
}

class APIClient {
    
    // MARK: - General Request 메서드
    static func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable? = nil,
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        var allHeaders = headers ?? [:]
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            allHeaders["Authorization"] = "Bearer \(accessToken)"
        }
        allHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(APIError.custom(message: "Failed to encode request body.")))
                return
            }
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.custom(message: "Invalid server response.")))
                return
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(APIError.serverError(statusCode: httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(APIError.decodingError))
            }
        }.resume()
    }
}
