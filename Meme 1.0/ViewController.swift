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
        textFieldProperites()
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
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
    
    //Top and Bottom text box with placeholders and assigns attributes
    func textFieldProperites(){
        TopTextField.text = "TOP"
        TopTextField.delegate = self
        TopTextField.defaultTextAttributes = memeTextAttributes
        TopTextField.textAlignment = .center
        
        BottomTextField.text = "BOTTOM"
        BottomTextField.delegate = self
        BottomTextField.defaultTextAttributes = memeTextAttributes
        BottomTextField.textAlignment = .center
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
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
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
        _ = Meme(topText: TopTextField.text!, bottomText: BottomTextField.text!, originalImage: ImagePickerView.image!, memedImage: memedImage)
        
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

    
    //MARK: Actions
    @IBAction func PickImageAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func PickImageCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func shareItem(_ sender: Any) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {activity, completed, items, error in
            self.save()
            self.dismiss(animated: true, completion: nil)
            }
        present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        textFieldProperites()
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
