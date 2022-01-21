import UIKit
import MBProgressHUD

class ViewController: UIViewController {
    
    //MARK: - variables
    private let viewImage = UIImageView()
    private let changePhotoButton = UIButton()
    private var color = [UIColor]()
    private var longPressRecognizer = UILongPressGestureRecognizer()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setMainScreen()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setButton()
    }
    
    //MARK: - Settings
    private func setMainScreen() {
        view.backgroundColor = .systemPink
        setViewImage()
        setNavigationController()
        setColor()
        getRandomPhoto()
        setLongPressGesture()
    }
    
    private func setNavigationController() {
        title = "Random Photo"
        navigationController?.navigationBar.prefersLargeTitles = true
        let navigationLargeFont = UIFont(name: "Chalkboard SE", size: 50)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: navigationLargeFont ?? ""]
    }
    
    private func setViewImage() {
        viewImage.contentMode = .scaleAspectFill
        viewImage.backgroundColor = .white
        viewImage.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        viewImage.center = view.center
        viewImage.clipsToBounds = true
        viewImage.layer.cornerRadius = 20
        viewImage.layer.borderWidth = 2
        viewImage.layer.borderColor = UIColor.black.cgColor
        viewImage.isUserInteractionEnabled = true
        view.addSubview(viewImage)
    }
    
    private func setButton() {
        changePhotoButton.setTitle("TAP", for: .normal)
        changePhotoButton.setTitleColor(.black, for: .normal)
        changePhotoButton.backgroundColor = .secondarySystemGroupedBackground
        changePhotoButton.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 40)
        changePhotoButton.frame = CGRect(x: 20,
                                         y: view.frame.size.height-150-view.safeAreaInsets.bottom,
                                         width: view.frame.size.width-42,
                                         height: 55)
        changePhotoButton.layer.cornerRadius = 20
        changePhotoButton.clipsToBounds = true
        changePhotoButton.layer.borderWidth = 2
        changePhotoButton.layer.borderColor = UIColor.black.cgColor
        view.addSubview(changePhotoButton)
        changePhotoButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    private func setColor() {
        color = [.systemYellow,
                 .systemOrange,
                 .systemPink,
                 .systemGreen,
                 .systemPurple]
    }
    
    //MARK: - Get Random Photo
    private func getRandomPhoto() {
        let urlString = "https://picsum.photos/600/600"
        guard let url = URL(string: urlString) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        let seconds = 0.1
        showLoadingHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.viewImage.image = UIImage(data: data)
        }
        hideLoadingHud()
    }
    
    //MARK: - create Gesture
    private func setLongPressGesture() {
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        longPressRecognizer.minimumPressDuration = 0.5
        // add gesture to imageView
        viewImage.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        let alert = UIAlertController(title: "Save", message: "Do you want to save the photo?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            self.saveImage()
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
    
    //MARK: - Save Image
    private func saveImage() {
        guard  let selectedImage = viewImage.image else { return }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Success")
        }
    }
    
    //MARK: - MBProgressHUD
    private func showLoadingHUD() {
        _ = MBProgressHUD.showAdded(to: viewImage, animated: true)
    }
    
    private func hideLoadingHud() {
        MBProgressHUD.hide(for: viewImage, animated: true)
    }
    
    //MARK: - Actions
    @objc func didTapButton() {
        getRandomPhoto()
        view.backgroundColor = color.randomElement()
    }
    
    
}

