//
//  SportTableViewCell.swift
//  Sports
//
//  Created by administrator on 26/12/2021.
//

import UIKit

class SportTableViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var sportImage: UIImageView!
    
    var imagesDelegates: ImagesDelegates?
    var index: Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func imageButtonPressed(_ sender: UIButton) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        
        self.window?.rootViewController?.present(imagePickerVC, animated: true, completion: nil)
    }
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            
            if let image = info[.originalImage] as? UIImage {
                imagesDelegates?.addImage(image: image, at: index!)
                
            }
        }
    
}
