//
//  ViewController.swift
//  Meme 1.0
//
//  Created by DANIEL DICKINSON on 8/7/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
   

    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var TopTextField: UITextField!
    @IBOutlet weak var BottomTextField: UITextField!
    
    let memeTextAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    
    
    
    //MARK: Lifestyle
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldProperites()
    }
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
    //MARK: Actions
    @IBAction func PickImageAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func PickImageCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK: IPC
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage
        ] as? UIImage {
                    ImagePickerView.image = image
                    dismiss(animated: true, completion: nil)
            }
        }
   
    //MARK: Text field edits
    func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == TopTextField && TopTextField.text == "TOP"{
                TopTextField.text = " "
            }
            if textField == BottomTextField && BottomTextField.text == "BOTTOM"{
                BottomTextField.text = " "
            }
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
    
        
    }
    

