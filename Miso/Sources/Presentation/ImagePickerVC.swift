import UIKit


class ImagePickerVC: UIImagePickerController {
    weak var delegate: ImagePickerDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.sourceType = .camera
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.delegate = self
        self.allowsEditing = true
        self.cameraFlashMode = .auto
        self.cameraDevice = .rear
    }
}

extension ImagePickerVC: ImagePickerDelegate {
    func didPickImageWithData(_ imageData: Data) {
        // Implementation of the delegate method
    }
    
    // You can also implement other UIImagePickerControllerDelegate and UINavigationControllerDelegate methods here if needed.
}

extension ImagePickerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
           let imageData = pickedImage.jpegData(compressionQuality: 0.8) {
            delegate?.didPickImageWithData(imageData)
            print("Image picked successfully.")
        } else {
            print("Failed to convert the image to data.")
        }
        
        picker.dismiss(animated: true) {
            print("Picker dismissed.")
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            print("Picker canceled.")
        }
    }
}
