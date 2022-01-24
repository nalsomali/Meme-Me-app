//
//  TabBarController.swift
//  meme me v1.0
//
//  Created by Nada  on 01/08/2021.
//

import Foundation
import UIKit

class TabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Meme", style: .plain, target: self, action: #selector(newMeme))
    }
    
    @objc func newMeme(){
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let newMemecontroller = storyboard.instantiateViewController(withIdentifier: "newMeme") as! MemeEditorViewController
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = [newMemecontroller]
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
}
