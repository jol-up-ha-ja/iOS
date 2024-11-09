import Foundation

struct RegisterRequest: Codable {
    let name: String
    let gender: String
    let birth: Int
}
