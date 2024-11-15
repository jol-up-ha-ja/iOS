// APIClient+S3.swift
import Foundation

extension APIClient {
    // MARK: - 상태 추적 변수
    fileprivate static var refreshInProgress = false
    fileprivate static var pendingRequests: [(Result<S3PresignedUrlResponse, Error>) -> Void] = []

    // MARK: - Presigned URL 요청 메서드
    static func getPresignedURL(imgType: String = "JPG", completion: @escaping (Result<S3PresignedUrlResponse, Error>) -> Void) {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            print("❌ Access Token이 없습니다. 로그인이 필요합니다.")
            completion(.failure(APIError.custom(message: "Access Token이 없습니다.")))
            return
        }

        // imgType 검증
        let supportedImgTypes = ["JPG", "JPEG", "PNG"]
        let formattedImgType = imgType.uppercased()
        guard supportedImgTypes.contains(formattedImgType) else {
            completion(.failure(APIError.custom(message: "지원되지 않는 이미지 형식: \(imgType)")))
            return
        }

        let endpoint = "http://13.125.96.48/api/v1/s3/presigned-url?imgType=\(formattedImgType)"
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

            switch httpResponse.statusCode {
            case 200:
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
            case 401, 400:
                print("❌ Presigned URL 요청 실패 - 상태 코드: \(httpResponse.statusCode)")
                refreshTokenAndRetry(imgType: formattedImgType, completion: completion)
            default:
                print("❌ 서버 에러 - 상태 코드: \(httpResponse.statusCode)")
                completion(.failure(APIError.serverError(statusCode: httpResponse.statusCode)))
            }
        }.resume()
    }

    // MARK: - 토큰 갱신 후 재시도
    static func refreshTokenAndRetry(imgType: String, completion: @escaping (Result<S3PresignedUrlResponse, Error>) -> Void) {
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
                print("✅ 토큰 갱신 성공, 보류된 요청 재시도")
                let queuedRequests = pendingRequests
                pendingRequests.removeAll()
                queuedRequests.forEach { getPresignedURL(imgType: imgType, completion: $0) }
            case .failure(let error):
                print("❌ 토큰 갱신 실패: \(error.localizedDescription)")
                let queuedRequests = pendingRequests
                pendingRequests.removeAll()
                queuedRequests.forEach { $0(.failure(APIError.custom(message: "토큰 갱신 실패"))) }
            }
        }
    }

    // MARK: - 토큰 갱신
    static func refreshToken(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"), !refreshToken.isEmpty else {
            print("❌ Refresh Token이 없습니다. 로그인이 필요합니다.")
            completion(.failure(APIError.custom(message: "Refresh Token이 없습니다.")))
            return
        }

        let endpoint = "https://kauth.kakao.com/oauth/token"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let parameters = [
            "grant_type": "refresh_token",
            "client_id": "652d477714618bb9a2a50ee848dd6ae3", // Replace with your client ID
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
                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                if let newAccessToken = tokenResponse.accessToken {
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
