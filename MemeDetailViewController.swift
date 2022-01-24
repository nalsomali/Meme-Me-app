//
//  MemeDetailViewController.swift
//  meme me v1.0
//
//  Created by Nada  on 01/08/2021.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var meme : Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memedImage
    }
}
