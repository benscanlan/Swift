import SwiftUI

struct CameraView: View {
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
            
            Button("Take Picture") {
                self.isShowPhotoLibrary.toggle()
            }
            .padding()
            .sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(sourceType: .camera) { capturedImage in
                    self.image = capturedImage
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    let sourceType: UIImagePickerController.SourceType
    let completionHandler: (UIImage) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(completionHandler: completionHandler)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let completionHandler: (UIImage) -> Void

        init(completionHandler: @escaping (UIImage) -> Void) {
            self.completionHandler = completionHandler
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                completionHandler(image)
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

@main
struct CameraApp: App {
    var body: some Scene {
        WindowGroup {
            CameraView()
        }
    }
}

