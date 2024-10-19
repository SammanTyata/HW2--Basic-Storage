//
//  MediaView.swift
//  HW2--Basic-Storage
//
//  Created by Samman Tyata on 10/18/24.
//

import Foundation
import SwiftUI

struct MediaView: View {
    @State private var images: [UIImage] = []
    @State private var imagePaths: [URL] = []
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    // Use an enum to manage alert states
    enum AlertType: Identifiable {
        case save
        case delete
        
        var id: String {
            switch self {
            case .save: return "save"
            case .delete: return "delete"
            }
        }
    }

    @State private var alertType: AlertType?
    
    var body: some View {
        VStack {
            Text("Media Storage")
                .font(.headline)
                .padding()

            // Display all stored images in a grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(images.indices, id: \.self) { index in
                        let image = images[index]
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding(5)
                    }
                }
            }
            .padding()

            HStack {
                Button("Pick Image") {
                    showingImagePicker = true
                }
                .padding()

                Button("Save Image") {
                    if let inputImage = inputImage {
                        saveImageLocally(image: inputImage)
                        loadAllImages()
                        alertType = .save // Trigger the save alert
                    }
                }
                .padding()

                Button("Delete All Images") {
                    deleteAllImages()
                    loadAllImages()
                    alertType = .delete // Trigger the delete alert
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadSelectedImage) {
            ImagePicker(image: $inputImage)
        }
        .onAppear {
            loadAllImages()
        }
        .alert(item: $alertType) { alertType in
            switch alertType {
            case .save:
                return Alert(title: Text("Image Saved"), message: Text("Your image has been saved successfully."), dismissButton: .default(Text("OK")))
            case .delete:
                return Alert(title: Text("Images Deleted"), message: Text("All images have been deleted successfully."), dismissButton: .default(Text("OK")))
            }
        }
    }

    // Save Image with a unique filename
    func saveImageLocally(image: UIImage) {
        let filename = UUID().uuidString + ".jpg" // Unique filename
        if let data = image.jpegData(compressionQuality: 1) {
            let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
            try? data.write(to: fileURL)
        }
    }

    // Load all images from the Documents directory
    func loadAllImages() {
        images.removeAll() // Clear current images
        imagePaths.removeAll()

        let fileManager = FileManager.default
        let documentDirectory = getDocumentsDirectory()

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                if let data = try? Data(contentsOf: fileURL),
                   let image = UIImage(data: data) {
                    images.append(image)
                    imagePaths.append(fileURL) // Store image file paths for deletion
                }
            }
        } catch {
            print("Error loading images: \(error.localizedDescription)")
        }
    }

    // Get Documents Directory
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // Load selected image from the image picker
    func loadSelectedImage() {
        if let inputImage = inputImage {
            images.append(inputImage)
        }
    }

    // Delete all images
    func deleteAllImages() {
        let fileManager = FileManager.default
        let documentDirectory = getDocumentsDirectory()

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("Error deleting all images: \(error.localizedDescription)")
        }
    }
}

// ImagePicker Helper
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    MediaView()
}
