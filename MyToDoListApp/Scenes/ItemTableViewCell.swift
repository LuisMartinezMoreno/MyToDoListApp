//
//  ItemTableViewCell.swift
//  MyToDoListApp
//
//  Created by Luis Martínez Moreno on 2/2/21.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageItem: UIImageView!
    /**
     Acciones del boton "hecho", es cual marca las tareas en rojo y las desmarca al color original
     */
    @IBAction func doneButton(_ sender: UIButton) {
        let checked = UIImage(named: "CheckedBox")!
        let unChecked = UIImage(named: "unCheckedBox")!
        if nameLabel.textColor.isEqual(UIColor .black){
            doneButton.setImage(checked, for: .normal)
            doneButton.imageView?.contentMode = .scaleAspectFit
            doneButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            nameLabel.textColor=UIColor .red
            dateLabel.textColor=UIColor .red
        }else{
            doneButton.setImage(unChecked, for: .normal)
            doneButton.imageView?.contentMode = .scaleAspectFit
            doneButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            nameLabel.textColor=UIColor .black
            dateLabel.textColor=UIColor(red:172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
