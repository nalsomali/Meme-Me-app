//
//  ViewController.swift
//  meme me v1.0
//
//  Created by Nada  on 06/07/2021.
//

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var sharingButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var Imagecontroller: UIImageView!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor:UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4.0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // so it doesnt change sizes when we rotate the phone
        Imagecontroller.contentMode = .scaleAspectFit

        // Do any additional setup after loading the view.
        // for delegates
        prepareTextField(textField: topTextField, default:"TOP")
        prepareTextField(textField: bottomTextField, default:"BOTTOM")
        
        sharingButton.isEnabled = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    func imagePickerController(_ ImagePicker: UIImagePickerController, didFinishPickingMediaWithInfo i: [UIImagePickerController.InfoKey : Any]){
        if let Image = i[.originalImage] as? UIImage {
            Imagecontroller.image  = Image
        }
        //After adding the photo you can now share
        sharingButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    //cancel image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            Imagecontroller.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    func ImagePickerSourceType(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func pickAnImage(_ sender: Any) {
        ImagePickerSourceType(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        ImagePickerSourceType(sourceType: .camera)

       }
    
    @IBAction func share(_ sender: UIBarButtonItem) { let generatedMemeImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems:[generatedMemeImage],applicationActivities:nil)
        controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
               self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(controller, animated:true, completion: nil)
    }
    @IBAction func cancel(_ sender: Any) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        self.Imagecontroller.image = nil
        sharingButton.isEnabled = false
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
  
    func   subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        }
   
    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
   
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        // tool bar
        toolBar.isHidden = true
// navigation bar
        navigationBar.isHidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
      
        return memedImage
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topTextField: topTextField.text!, bottomTextField: bottomTextField.text!, originalImage: Imagecontroller.image! ,memedImage: generateMemedImage() )

        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func prepareTextField(textField: UITextField, default: String){
        textField.defaultTextAttributes = memeTextAttributes as [NSObject: AnyObject] as! [NSAttributedString.Key : Any]
        textField.textAlignment = NSTextAlignment.center
        textField.autocapitalizationType = .allCharacters
        textField.delegate = self
    }

        
        func imagePickerControllerDidCancel(_: UIImagePickerController) {
            Imagecontroller.image = nil;
            dismiss(animated: true, completion: nil)
        }

}
    
        

