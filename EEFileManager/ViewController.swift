//
//  ViewController.swift
//  FileManager
//
//  Created by aosue on 2019/6/20.
//  Copyright © 2019 aosue. All rights reserved.
//

import UIKit



class ViewController: UIViewController,UIDocumentPickerDelegate {

    
    var documentVC = UIDocumentInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        print("将文件拷贝在<\n" + customPath + "/附件\n>" + "目录中")
        
        let fileView = EEFileBoadView(frame: CGRect (x: 0, y: 20, width: self.view.frame.width, height: 500))
        self.view.addSubview(fileView)
        fileView.addViewsAndCount()
        fileView.getFile = {(model) in
            print(model.name);
            
            // 打开文件
            self.documentVC = UIDocumentInteractionController(url: model.url as URL)
            self.documentVC.delegate = self
            self.documentVC.presentPreview(animated: true)
        }
        
    }
    

}


extension ViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
