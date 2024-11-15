//UserInfo.swift

import Foundation

struct UserInfo: Identifiable, Decodable {
    let id: Int
    var name: String // `let`을 `var`로 변경
    var gender: String // `let`을 `var`로 변경
    var birth: String // `let`을 `var`로 변경
    
    init(id: Int = 0, name: String = "", gender: String = "", birth: String = "") {
        self.id = id
        self.name = name
        self.gender = gender
        self.birth = birth
    }
}
