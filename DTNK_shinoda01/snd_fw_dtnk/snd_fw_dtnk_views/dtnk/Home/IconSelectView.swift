/**
 IconSelect
 */

import SwiftUI
import FirebaseStorage
import FirebaseAuth


struct IconSelectView: View {
    
    @State private var hsSpacing: CGFloat = 50
    @State private var iconSize: CGFloat = 70
    @State private var iconURL = appState.account.loginUser.iconURL
    
    @State private var userImage: Image?
    
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var uploadInProgress = false
    @State private var uploadSuccess = false

    
    var body: some View {
        GeometryReader { geo in
            // 裏
            ZStack{
                // 表
                ZStack{
                    VStack(spacing: 40) {
                        
                        // NowIcon
                        IconView(iconURL: iconURL, size: 70)

                        // 上段
                        HStack(spacing: hsSpacing) {
                            Button(action: {
                                iconURL = ImageName.Icon.bot1.rawValue
                            }) {
                                Image(ImageName.Icon.bot1.rawValue)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: iconSize, height: iconSize)
                                    .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                            }

                            Button(action: {
                                iconURL = ImageName.Icon.bot2.rawValue
                            }) {
                                Image(ImageName.Icon.bot2.rawValue)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: iconSize, height: iconSize)
                                    .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                            }

                            Button(action: {
                                iconURL = ImageName.Icon.bot3.rawValue
                            }) {
                                Image(ImageName.Icon.bot3.rawValue)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: iconSize, height: iconSize)
                                    .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                            }
                        }
                        
                        // 下段
                        HStack(spacing: hsSpacing) {
                            Button(action: {
                                iconURL = ImageName.Icon.bot4.rawValue
                            }) {
                                Image(ImageName.Icon.bot4.rawValue)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: iconSize, height: iconSize)
                                    .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                            }

                            Button(action: {
                                iconURL = ImageName.Icon.bot5.rawValue
                            }) {
                                Image(ImageName.Icon.bot5.rawValue)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: iconSize, height: iconSize)
                                    .shadow(color: Color.casinoShadow, radius: 1, x: 0, y: 10)
                            }

                            Button(action: {
                                showingImagePicker = true
                            }) {
                                Image(ImageName.Option.camera.rawValue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 70, height: 70)

//                                Btnaction(btnText: "?", btnTextSize: 15, btnWidth:  70, btnHeight: 70, btnColor: Color.dtnkLightBlue)
                            }
                            .sheet(isPresented: $showingImagePicker, onDismiss: uploadImageToFirebase) {
                                ImagePicker(image: $selectedImage)
                            }
                        }
                                                
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.90, height: geo.size.height * 0.40)
                    .background(
                        Color.black.opacity(0.90)
                    )
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)


                    HStack(spacing: 40) {
                        Button(action: {
                            HomeController().onTapBackMode()
                            HomeController().updateIcon(iconURL: iconURL)
                        }) {
                            Btnwb(btnText: "戻る", btnTextSize: 20, btnWidth: 120, btnHeight: 50)
                        }

//                        Button(action: {
//                            HomeController().updateIcon(iconURL: iconURL)
//                            SoundMng.shared.playSound(soundName: SoundName.SE.btn_positive.rawValue)
//                        }) {
//                            Btnwb(btnText: "更新", btnTextSize: 20, btnWidth: 120, btnHeight: 50)
//
//                        }
                    }
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.80)
                }
                .background(
                    Color.black.opacity(0.50)
                        .onTapGesture {
                            RoomController().onCloseMenu()
                        }
                )
            }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func getUserStorageRef() -> StorageReference {
        let uid = Auth.auth().currentUser?.uid ?? "unknownUser"
        return Storage.storage().reference().child("userImages/\(uid)")
    }

    
    func deleteUserImageFromFirebase(completion: @escaping (Error?) -> Void) {
        let storageRef = getUserStorageRef()
        
        storageRef.delete { error in
            completion(error)
        }
    }

    func uploadImageToFirebase() {
        guard let image = selectedImage, let data = image.jpegData(compressionQuality: 0.75) else { return }

        uploadInProgress = true

        // まず前の画像を削除
        deleteUserImageFromFirebase { error in
            // オブジェクトが存在しないエラー以外のエラーをチェック
            if let error = error, (error as NSError).code != StorageErrorCode.objectNotFound.rawValue {
                print("Failed to delete previous image: \(error.localizedDescription)")
                uploadInProgress = false
                return
            }
            
            // 前の画像の削除が成功した、または前の画像が存在しなかった場合、新しい画像をアップロード
            let storageRef = self.getUserStorageRef()

            storageRef.putData(data, metadata: nil) { (metadata, error) in
                self.uploadInProgress = false
                if error != nil {
                    print("Failed to upload to Firebase Storage")
                    return
                }

//                storageRef.downloadURL { (url, error) in
//                    if let downloadURL = url {
//                        self.iconURL = downloadURL.absoluteString
//                        self.downloadImage(url: self.iconURL)
//                        print("Successfully uploaded to Firebase Storage. URL: \(self.iconURL)")
//                        updateAppStateIconURL(with: self.iconURL) // これを追加
//
//                    } else {
//                        print("Failed to get download URL")
//                    }
//                }
                storageRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        self.iconURL = downloadURL.absoluteString
                        ImageCache.shared.removeImage(forKey: self.iconURL) // キャッシュを削除
                        self.downloadImage(url: self.iconURL)
                        print("Successfully uploaded to Firebase Storage. URL: \(self.iconURL)")
                        updateAppStateIconURL(with: self.iconURL)
                    } else {
                        print("Failed to get download URL")
                    }
                }

            }
        }
    }

    // この新しいメソッドで appState の iconURL を更新します。
    func updateAppStateIconURL(with url: String) {
        appState.account.loginUser.iconURL = url
        iconURL = url
        print("\(iconURL)")
    }

    
    func downloadImage(url: String) {
        guard let imageURL = URL(string: url) else {
            print("Invalid URL.")
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.userImage = Image(uiImage: uiImage)
                    appState.account.loginUser.iconURL = iconURL
                }
            } else {
                print("Failed to download image.")
            }
        }.resume()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

