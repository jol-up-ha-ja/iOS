import Foundation

struct RegisterCheckResponse: Decodable {
    let canRegister: Bool
    let accessToken: String? // 옵셔널로 변경하여 누락에 대비
}
