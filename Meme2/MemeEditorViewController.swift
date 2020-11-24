//
//  ViewController.swift
//  Meme2
//
//  Created by Tommy Lam on 11/23/20.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!

    var preloadMeme: Meme?

    override func viewDidLoad() {
        super.viewDidLoad()
        // top textfield
        setUpTextfield(topTextfield, text: "TOP")

        // bottom textfield
        setUpTextfield(bottomTextfield, text: "BOTTOM")
        // Do any additional setup after loading the view.

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:))))
    }

    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        subscribeToKeyboardNotificationShowAndHide()
        shareButton.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotificationShowAndHide()
    }


    // IBACtions

    @IBAction func pickImageUsingCamera(_ sender: Any) {
        present(imagePicker(pickerSourceType: UIImagePickerController.SourceType.camera), animated: true, completion: nil)

    }

    @IBAction func pickImageUsingAlbum(_ sender: Any) {
        present(imagePicker(pickerSourceType: UIImagePickerController.SourceType.photoLibrary), animated: true, completion: nil)
    }

    @IBAction func shareAction(_ sender: Any) {
        let generatedMemeImage = generateMemedImage()
        let shareViewController = UIActivityViewController(activityItems: [generatedMemeImage], applicationActivities: nil)
        present(shareViewController, animated: true, completion: nil)
        shareViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                print("Not Saved")
            } else {
                self.save()
                print("Saved.")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cancelMeme(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }





    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // TODO: Show toolbar and navbar
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false

        return memedImage
    }

    func save() {
        let meme = Meme(topText: topTextfield.text, bottomText: bottomTextfield.text, originalImage: memeImage.image, memeImage: generateMemedImage())
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        print("size of memes: \(appDelegate.memes.count)")
        //appDelegate.memes.append(meme)
    }





    // Helper Functions
    func imagePicker(pickerSourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate =  self
        imagePicker.sourceType = pickerSourceType
        return imagePicker
    }

    func setUpTextfield(_ textField: UITextField, text: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(string: text, attributes: memeTextAttributes)
    }

    // Text attriubutes
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -2.0
    ]


    // Keyboard notifications
    // Shifting view  up when keyboard appears
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize =  userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    // adding shift up and back down when keyboard appear and disappear
    func subscribeToKeyboardNotificationShowAndHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // Shifting view back when keyboard is gone
    func unsubscribeToKeyboardNotificationShowAndHide() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    // Tapping in the view dismisses keyboard
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        topTextfield.resignFirstResponder()
        bottomTextfield.resignFirstResponder()
    }


    // DELEGATES
    // UIImagePickerControllerDelegate functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.memeImage.image = selectedImage
        }
        dismiss(animated: true, completion: {
            if self.memeImage.image != nil {
                self.shareButton.isEnabled = true
            }
        })
    }
}



