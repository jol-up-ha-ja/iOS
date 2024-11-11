// ExerciseGuide.swift

import Foundation

struct ExerciseGuide: Identifiable, Decodable {
    let id: Int
    let name: String
    let description: String
    let repetitions: Int
    let duration: Int
}
