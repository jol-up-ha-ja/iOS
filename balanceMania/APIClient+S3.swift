import Foundation

extension APIClient {
    
    private static var refreshInProgress = false
    private static var pendingRequests: [(Result<S3PresignedUrlResponse, Error>) -> Void] = []
    
    // MARK: - Presigned URL 요청 메서드
    static func getPresignedURL(imgType: String = "jpg", completion: @escaping (Result<S3PresignedUrlResponse, Error>) -> Void) {
        let endpoint = "http://13.125.96.48/api/v1/s3/presigned-url?imgType=\(imgType.uppercased())"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.noData))
                return
            }
            
            if httpResponse.statusCode == 400 {
                print("❌ Presigned URL 요청 실패 - 상태 코드: 400 (유효하지 않은 토큰)")
                handleTokenRefresh(imgType: imgType, completion: completion)
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let presignedUrlResponse = try JSONDecoder().decode(S3PresignedUrlResponse.self, from: data)
                completion(.success(presignedUrlResponse))
            } catch {
                completion(.failure(APIError.decodingError))
            }
        }.resume()
    }
    
    private static func handleTokenRefresh(imgType: String, completion: @escaping (Result<S3PresignedUrlResponse, Error>) -> Void) {
        if refreshInProgress {
            pendingRequests.append(completion)
            return
        }

        refreshInProgress = true
        pendingRequests.append(completion)
        
        refreshToken { result in
            refreshInProgress = false

            switch result {
            case .success:
                getPresignedURL(imgType: imgType, completion: { result in
                    pendingRequests.forEach { $0(result) }
                    pendingRequests.removeAll()
                })
            case .failure(let error):
                pendingRequests.forEach { $0(.failure(error)) }
                pendingRequests.removeAll()
            }
        }
    }

    // MARK: - Presigned URL로 이미지 업로드 메서드
    static func uploadImage(data: Data, to presignedURL: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uploadURL = URL(string: presignedURL) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        let uploadTask = URLSession.shared.uploadTask(with: request, from: data) { _, response, error in
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
        }
        
        uploadTask.resume()
    }
    
    // MARK: - Token 갱신 메서드
    static func refreshToken(completion: @escaping (Result<Void, Error>) -> Void) {
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
        let endpoint = "https://kauth.kakao.com/oauth/token"

        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters = [
            "grant_type": "refresh_token",
            "client_id": "652d477714618bb9a2a50ee848dd6ae3", // REST API 키
            "refresh_token": refreshToken
        ]
        request.httpBody = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            do {
                let responseJSON = try JSONDecoder().decode([String: String].self, from: data)
                if let newAccessToken = responseJSON["access_token"] {
                    UserDefaults.standard.set(newAccessToken, forKey: "accessToken")
                    completion(.success(()))
                } else {
                    completion(.failure(APIError.custom(message: "토큰 갱신 실패")))
                }
            } catch {
                completion(.failure(APIError.decodingError))
            }
        }.resume()
    }
}

