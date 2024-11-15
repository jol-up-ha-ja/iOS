//ImageSelectionView.swift
import SwiftUI

struct ImageSelectionView: View {
    var title: String
    var image: UIImage?
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.5), lineWidth: 2))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 120)
                    .overlay(Text(title).foregroundColor(.gray))
            }
        }
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}
