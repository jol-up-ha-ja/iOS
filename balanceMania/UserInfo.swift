import Foundation

struct UserInfo: Identifiable {
    let id: Int
     let name: String
     let gender: String
     let birth: String
    
    init(id: Int = 0, name: String = "", gender: String = "", birth: String = "") {
        self.id = id
        self.name = name
        self.gender = gender
        self.birth = birth
    
    }
}
