//
//  ViewController.swift
//  Meme 1.0
//
//  Created by DANIEL DICKINSON on 8/7/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIFontPickerViewControllerDelegate{
    
    //MARK: Outlets
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var TopTextField: UITextField!
    @IBOutlet weak var BottomTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField(textField: TopTextField, text: "TOP")
        setupTextField(textField: BottomTextField, text: "BOTTOM")
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        //disable camera button during simulation
        #if targetEnvironment(simulator)
            cameraButton.isEnabled = false
        #else
            cameraButton.isEnabled = true
        #endif
    
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromkeyboardNotifications()
    }
    
    //MARK: Text Attributes
    //Text formatting, All caps set in settings
    let memeTextAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    
    //Text Field parameters for UITextField inputs
    func setupTextField(textField: UITextField, text: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.text = text
    }
    
    //When text box is clicked, placehoulder disapears
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == TopTextField && TopTextField.text == "TOP"{
            TopTextField.text = " "
        }
        if textField == BottomTextField && BottomTextField.text == "BOTTOM"{
            BottomTextField.text = " "
        }
    }
    
    //When return is pressed, keyboard will disapear
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Keyboard shift
    func getkeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo! [UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    //When bottom text is edited, imageView is shifted up using notifications
    @objc func keyboardWillShow(_ notification:Notification){
        if BottomTextField.isEditing {
            view.frame.origin.y = -getkeyboardHeight(notification)
        }
    }
    
    //When return is pressed, keyboard will hide and imageView will return using notifications
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    //Subscrition set in viewWillAppear
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Subscrition set in viewWillDisapear
    func unsubscribeFromkeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //MARK: Meme Creation
    //Defines Meme object
    

    func generateMemedImage() -> UIImage {
        //hide toolbar
        self.navigationBar.isHidden = true
        self.toolBar.isHidden = true
        
        //Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //show toolbar
        self.navigationBar.isHidden = false
        self.toolBar.isHidden = false
        
        return memedImage
    }
    
    func save() {
        //generate the meme
        let memedImage = generateMemedImage()
        //create the meme
        let meme = Meme(topText: TopTextField.text!, bottomText: BottomTextField.text!, originalImage: ImagePickerView.image!, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    //MARK: imagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage
        ] as? UIImage {
            ImagePickerView.image = image
            dismiss(animated: true, completion: nil)
            shareButton.isEnabled = true
        }
    }
    
    //pickImage func to reduce Album/Camera redundency
    func pickImage(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func PickImageAlbum(_ sender: Any) {
        pickImage(source: .photoLibrary)
    }
    
    @IBAction func PickImageCamera(_ sender: Any) {
        pickImage(source: .camera)
    }
    
    @IBAction func shareItem(_ sender: Any) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        //removed activity and item params since they are not being used and declared with _.
        controller.completionWithItemsHandler = {_, completed, _, _ in
            self.save()
            self.dismiss(animated: true, completion: nil)
        }
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        TopTextField.text = "TOP"
        BottomTextField.text = "BOTTOM"
        self.ImagePickerView.image = nil
    }
    
    // Change font, have to push cancel instead of return to execute font
    @IBAction func fontPicker(_ sender: Any) {
        let config = UIFontPickerViewController.Configuration()
        config.includeFaces = false
        let vc = UIFontPickerViewController(configuration: config)
        vc.delegate = self
        
        present(vc, animated: true)
    }
    
    func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        guard let descripter = viewController.selectedFontDescriptor else {return}
        TopTextField.font = UIFont(
            descriptor: descripter,
            size: 40)
        BottomTextField.font = UIFont(
            descriptor: descripter,
            size: 40)
    }
}
