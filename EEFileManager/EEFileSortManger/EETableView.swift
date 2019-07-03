//
//  EETableView.swift
//  FileManager
//
//  Created by aosue on 2019/6/24.
//  Copyright © 2019 aosue. All rights reserved.
//

import UIKit

class EETableView: UITableView {

    let imageView = UIImageView()
    let textLabel = UILabel()
    
    lazy var noneDataView : UIView = {
        let view = UIView()
        view.addSubview(self.imageView)
        view.addSubview(self.textLabel)
        view.isHidden = true
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.noneDataView.frame = CGRect (x: 0, y: self.frame.height/3, width: frame.width, height: self.frame.height < 200 ? 70:140)
        self.imageView.frame = CGRect (x: 0, y: 0, width: noneDataView.frame.width, height: noneDataView.frame.height)
        self.textLabel.frame = CGRect (x: 0, y: noneDataView.frame.height+15, width: noneDataView.frame.width, height: 20)
    }
    
    func showNoneData(_ isShow:Bool) {
        self.showNoneDataView(isShow, str: "暂无数据", imageName: "eenonedata")
    }
    
    func showNoneDataView(_ isShow:Bool,str:String,imageName:String) {
        
        self.addSubview(self.noneDataView)
        
        noneDataView.isHidden = !isShow
        textLabel.text = str
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        textLabel.textAlignment = .center
        textLabel.textColor = .lightGray
        
    }

}
