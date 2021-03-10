//
//  ViewController.swift
//  MyToDoListApp
//
//  Created by Luis Martínez Moreno on 2/2/21.
//

import UIKit
import Photos

protocol ItemAddDelegate: class{
    func itemAdder(itemToAdd:Item)
    func itemModifyer(item:Item,path:IndexPath)
}
class ViewController: UIViewController,UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var tfDescripcion: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var item: Item?
    var ip:IndexPath?
    var delegate: ItemAddDelegate?
    
    override func viewDidLoad() {
        tfDescripcion.isEditable=true
        tfDescripcion.isUserInteractionEnabled = true
        tfDescripcion.isScrollEnabled = true
        tfDescripcion.layer.borderWidth = 1.0
        tfDescripcion.layer.borderColor = UIColor.lightGray.cgColor
        super.viewDidLoad()
        if let item = item {
            nameTextField.text = item.name
            tfDescripcion.text = item.descripcion
            datePicker.date = item.date
            imageView.image = UIImage(data: item.imagen)
        }
    }
    
    /**
     Cancela el intento de modificar o añadir un item
     */
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isInAddMode = presentingViewController is UINavigationController
        if isInAddMode {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController!.popViewController(animated: true)
        }
    }
    /**
     Prepara todo para que se pueda presentar la transición a la pantalla principal
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as AnyObject? === saveButton) {
            let name = nameTextField.text ?? ""
            let descripcion = tfDescripcion.text ?? ""
            let date = datePicker.date
            let imagen = imageView.image ?? UIImage(named: "interrogacion")
            if(item != nil){
                item!.name = name
                item!.descripcion=descripcion
                item!.date = date
                item!.imagen = imagen!.pngData()!
                delegate?.itemModifyer(item:item!, path: ip!)
            }else{
                item = Item(name: name, descripcion: descripcion, id: 0, date: date,imagen: (imagen!).pngData()!)
                delegate?.itemAdder(itemToAdd:item!)
            }
        }
    }
    /**
     Muestra el diálogo de donde sacar las imagenes
     */
    @IBAction func showUploadDialogue(_ sender: Any) {
        let alert = UIAlertController(title: "Selecciona una imagen", message: nil, preferredStyle: .actionSheet)
        let imagePicker = UIImagePickerController()
        alert.addAction(UIAlertAction(title: "Hacer una foto", style: .default, handler:{_ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Seleccionar una foto de la galería", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    /**
     Adapta las imágenes para que se puedan mostrar bien
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
