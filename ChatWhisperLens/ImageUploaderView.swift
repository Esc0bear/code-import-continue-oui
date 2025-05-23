
import SwiftUI
import PhotosUI

struct ImageUploaderView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @State private var isShowingImagePicker = false
    @State private var userComment = "Ex : cela fait 2j que l'on se parle 24h/24..."
    @State private var isProcessingImage = false
    
    var body: some View {
        VStack(spacing: 24) {
            if !appViewModel.capturedImages.isEmpty {
                ImageCarouselView()
            }
            
            imagePickerButton
            
            commentField
            
            startAnalysisButton
        }
        .animation(.easeInOut, value: appViewModel.capturedImages.count)
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(onImagesPicked: { images in
                for image in images {
                    if let data = image.jpegData(compressionQuality: 0.85) {
                        isProcessingImage = true
                        // Simulate optimization process
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            appViewModel.addCapturedImage(data)
                            isProcessingImage = false
                        }
                    }
                }
            })
        }
        .overlay(
            isProcessingImage ?
            ProgressView("Traitement de l'image...")
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 4)
                )
            : nil
        )
    }
    
    private var imagePickerButton: some View {
        Button {
            isShowingImagePicker = true
        } label: {
            VStack(spacing: 12) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 32))
                
                Text(appViewModel.capturedImages.isEmpty ? "Déposez votre capture d'écran ici" : "Ajouter d'autres captures d'écran")
                    .fontWeight(.medium)
                
                Text("ou cliquez pour parcourir vos fichiers")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .foregroundColor(Color.secondary.opacity(0.3))
            )
        }
    }
    
    private var commentField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Contexte (optionnel)")
                .font(.headline)
                .foregroundColor(.secondary)
            
            TextEditor(text: $userComment)
                .padding(12)
                .frame(minHeight: 80)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onTapGesture {
                    if userComment == "Ex : cela fait 2j que l'on se parle 24h/24..." {
                        userComment = ""
                    }
                }
        }
    }
    
    private var startAnalysisButton: some View {
        Button {
            if !appViewModel.capturedImages.isEmpty {
                appViewModel.setUserComment(userComment)
                appViewModel.setCurrentView(.analyze)
            } else {
                // Show an alert or message that images are required
            }
        } label: {
            HStack {
                Text("Lancer l'analyse")
                Image(systemName: "arrow.right")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(appViewModel.capturedImages.isEmpty ? Color.gray : Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(30)
        }
        .disabled(appViewModel.capturedImages.isEmpty)
    }
}

// Helper view for image picking
struct ImagePicker: UIViewControllerRepresentable {
    let onImagesPicked: ([UIImage]) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 10
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            var images: [UIImage] = []
            let dispatchGroup = DispatchGroup()
            
            for result in results {
                dispatchGroup.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    defer { dispatchGroup.leave() }
                    if let image = object as? UIImage {
                        images.append(image)
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.parent.onImagesPicked(images)
            }
        }
    }
}

struct ImageUploaderView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUploaderView()
            .environmentObject(AppViewModel())
    }
}
