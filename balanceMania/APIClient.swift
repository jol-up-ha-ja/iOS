// ApiClient.swift
import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
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
    private static var refreshInProgress = false
    private static var pendingRequests: [() -> Void] = []

    // MARK: - Upload Image
    static func uploadImage(data: Data, to presignedURL: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uploadURL = URL(string: presignedURL) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: uploadURL)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")

        URLSession.shared.uploadTask(with: request, from: data) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.noData))
                return
            }

            if httpResponse.statusCode == 200 {
                completion(.success(()))
            } else {
                completion(.failure(APIError.serverError(statusCode: httpResponse.statusCode)))
            }
        }.resume()
    }

    // MARK: - General API Request
    static func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable? = nil,
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        performRequest(endpoint: endpoint, method: method, body: body, headers: headers) { (result: Result<T, Error>) in
            switch result {
            case .failure(let error as APIError):
                if case .serverError(let statusCode) = error, statusCode == 401 {
                    print("❌ Unauthorized request (401). Attempting to refresh token.")
                    refreshAccessToken {
                        self.performRequest(endpoint: endpoint, method: method, body: body, headers: headers, completion: completion)
                    }
                } else {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                completion(.success(data))
            }
        }
    }

    // MARK: - Internal Request Execution
    private static func performRequest<T: Decodable>(
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

        // Add Headers
        var allHeaders = headers ?? [:]
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            allHeaders["Authorization"] = "Bearer \(accessToken)"
        }
        allHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        // Encode Body if Provided
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

    // MARK: - Access Token Refresh
    private static func refreshAccessToken(completion: @escaping () -> Void) {
        guard !refreshInProgress else {
            pendingRequests.append(completion)
            return
        }

        refreshInProgress = true

        AuthManager.shared.refreshToken { success in
            refreshInProgress = false

            if success {
                print("✅ Token refresh successful. Resuming pending requests.")
                pendingRequests.forEach { $0() }
            } else {
                print("❌ Token refresh failed. Please log in again.")
                UserDefaults.standard.removeObject(forKey: "accessToken")
                UserDefaults.standard.removeObject(forKey: "refreshToken")
            }
            pendingRequests.removeAll()
        }
    }
}
