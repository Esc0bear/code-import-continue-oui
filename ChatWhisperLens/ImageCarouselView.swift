
import SwiftUI

struct ImageCarouselView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Captures d'écran (\(appViewModel.capturedImages.count))")
                    .font(.headline)
                
                Spacer()
                
                Text("Organisez vos captures dans l'ordre chronologique")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(appViewModel.capturedImages) { image in
                        ImageItem(image: image)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        )
    }
}

struct ImageItem: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    let image: CapturedImage
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .topLeading) {
                    if let uiImage = UIImage(data: image.imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 150)
                            .cornerRadius(8)
                    } else {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 250, height: 150)
                            .cornerRadius(8)
                    }
                    
                    Text("#\(image.order + 1)")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemBackground).opacity(0.8))
                        .cornerRadius(8, corners: [.topLeft, .bottomRight])
                }
                
                Button {
                    appViewModel.removeCapturedImage(id: image.id)
                } label: {
                    Image(systemName: "xmark")
                        .padding(6)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding(4)
            }
            
            HStack {
                Button {
                    if image.order > 0 {
                        appViewModel.updateImageOrder(id: image.id, newIndex: image.order - 1)
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .padding(8)
                        .background(Color(.systemGray5))
                        .clipShape(Circle())
                        .foregroundColor(.primary)
                }
                .disabled(image.order == 0)
                
                Spacer()
                
                Button {
                    if image.order < appViewModel.capturedImages.count - 1 {
                        appViewModel.updateImageOrder(id: image.id, newIndex: image.order + 1)
                    }
                } label: {
                    Image(systemName: "arrow.right")
                        .padding(8)
                        .background(Color(.systemGray5))
                        .clipShape(Circle())
                        .foregroundColor(.primary)
                }
                .disabled(image.order == appViewModel.capturedImages.count - 1)
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 250)
    }
}

// Extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ImageCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AppViewModel()
        
        // Add sample images
        if let image = UIImage(named: "sample_chat") {
            if let data = image.jpegData(compressionQuality: 0.85) {
                viewModel.addCapturedImage(data)
                viewModel.addCapturedImage(data)
            }
        }
        
        return ImageCarouselView()
            .environmentObject(viewModel)
            .previewLayout(.sizeThatFits)
    }
}
