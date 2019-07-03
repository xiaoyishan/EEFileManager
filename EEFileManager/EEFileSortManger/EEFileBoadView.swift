//
//  EEFileBoadView.swift
//  FileManager
//
//  Created by aosue on 2019/6/20.
//  Copyright © 2019 aosue. All rights reserved.
//

import UIKit

enum EEFileSortType {
    case sizeMin
    case sizeMax
    case createdateMin
    case createMax
    case editdateMin
    case editMax
    case firstNameOrder
}

class EEFileBoadView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    static let customPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    let files = EEFileManager().QuickLookAllFiles(customPath + "/附件")
    var slipFiles = [FileModel]()
    let eeTintColor = UIColor.orange
    
    
    let menus = ["文档","图片","视频","音乐","压缩包","其它"]
    var menuViews = [UIButton]()
    var subMenuViews = [UIButton]()
    lazy var activeLine : UILabel = {
        let lablel = UILabel()
        lablel.frame = CGRect (x: 0, y: 50-10, width: 20, height: 3)
        lablel.backgroundColor = eeTintColor
        lablel.layer.cornerRadius = 1.5;
        lablel.layer.masksToBounds = true
        return lablel
    }()
    
    
    @objc func addViewsAndCount() {
        self.backgroundColor = .white
        self.addMenu()
        self.addSubview(self.activeLine)
        self.addSubMenu()
        self.addTableView()
        
        slipFiles = files
        //print("文件个数:",self.files.count)
        self.tableView.reloadData()
        
    }
    
    func addMenu() {
        for k in 0..<menus.count {
            let button = UIButton()
            button.frame = CGRect (x: self.frame.width/CGFloat(menus.count)*CGFloat(k), y: 0, width: self.frame.width/CGFloat(menus.count), height: 50);
            button.setTitle(menus[k], for: .normal)
            button.backgroundColor = .white
            button.setTitleColor(.darkGray, for: .normal)
            button.setTitleColor(eeTintColor, for: .highlighted)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            self.addSubview(button)
            button.addTarget(self, action: #selector(sliderClick(_:)), for: .touchUpInside)
            menuViews.append(button)
        }
        DispatchQueue.main.async {
            self.sliderClick((self.menuViews.first ?? nil)!)
        }
    
    }
    func addSubMenu() {
        var subitems = ["doc","pdf","excel","ppt","txt"]
        for k in 0...subitems.count-1 {
            let lastButton = self.viewWithTag(10000 + k - 1)
            let button = UIButton()
            button.frame = CGRect (x: (lastButton?.frame.maxX ?? 0) + 7, y: 60, width: 55, height: 25);
            button.setTitle(subitems[k], for: .normal)
            button.backgroundColor = .white
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(eeTintColor, for: .highlighted)
            button.layer.cornerRadius = button.frame.height/2.0
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.borderWidth = 0.5
            button.clipsToBounds = true
            button.tag = 10000 + k
            self.addSubview(button)
            button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
            subMenuViews.append(button)
        }
    }
    
    @objc func sliderClick(_ button : UIButton) {
        slipFiles = files
        slipFiles.removeAll { (FileModel) -> Bool in
            if button.currentTitle == menus[0] {
                if FileModel.type == .word || FileModel.type == .excel || FileModel.type == .ppt || FileModel.type == .pdf || FileModel.type == .txt {
                    return false
                }
            }
            if button.currentTitle == menus[1] {
                return FileModel.type != .image
            }
            if button.currentTitle == menus[2] {
                return FileModel.type != .video
            }
            if button.currentTitle == menus[3] {
                return FileModel.type != .audio
            }
            if button.currentTitle == menus[4] {
                return FileModel.type != .package
            }
            if button.currentTitle == menus[5] {
                return FileModel.type != .unknown
            }
            return true
        }
        tableView.reloadData()
        self.tableView.showNoneData(slipFiles.count==0)
        for btn in menuViews {
            btn.setTitleColor(.darkGray, for: .normal)
        }
        button.setTitleColor(eeTintColor, for: .normal)
        for btn in subMenuViews { // 还原子菜单选择
            btn.setTitleColor(.lightGray, for: .normal)
            btn.layer.borderColor = UIColor.lightGray.cgColor
        }
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            self.activeLine.frame.origin.x = button.frame.minX + (button.frame.width - self.activeLine.frame.width)/2.0
        }
    }
    @objc func buttonClick(_ button : UIButton) {
        slipFiles = files
        var isAllDocument = false
        
        for btn in subMenuViews {
            if btn == button {
                if button.layer.borderColor == eeTintColor.cgColor {
                    btn.setTitleColor(.lightGray, for: .normal)
                    btn.layer.borderColor = UIColor.lightGray.cgColor
                    isAllDocument = true
                }else{
                    button.setTitleColor(eeTintColor, for: .normal)
                    button.layer.borderColor = eeTintColor.cgColor
                }
            }else{
                btn.setTitleColor(.lightGray, for: .normal)
                btn.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    
        slipFiles.removeAll { (FileModel) -> Bool in
            if isAllDocument {
                if FileModel.type == .word || FileModel.type == .excel || FileModel.type == .ppt || FileModel.type == .pdf || FileModel.type == .txt {
                    return false
                }
            }
            if button.currentTitle == "doc" {
                return FileModel.type != .word
            }
            if button.currentTitle == "pdf" {
                return FileModel.type != .pdf
            }
            if button.currentTitle == "excel" {
                return FileModel.type != .excel
            }
            if button.currentTitle == "ppt" {
                return FileModel.type != .ppt
            }
            if button.currentTitle == "txt" {
                return FileModel.type != .txt
            }
            return true
        }
        tableView.reloadData()
        self.tableView.showNoneData(slipFiles.count==0)
    }
    
    
    
    let tableView = EETableView()
    
    func addTableView() {
        self.tableView.frame = CGRect (x: 0, y: 95, width: self.frame.width, height: self.frame.height-95)
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 60
        self.addSubview(self.tableView)
        tableView.register(EEFileCell.classForCoder(), forCellReuseIdentifier: "EEFileCell")
    }
    override func layoutIfNeeded() {
        super.layoutSubviews()
        let yy = CGFloat( menuViews.first?.currentTitleColor==eeTintColor ? 95.0 : 50.0 )
        self.tableView.frame = CGRect (x: 0, y: yy, width: self.frame.width, height: self.frame.height-yy)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slipFiles.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EEFileCell = tableView.dequeueReusableCell(withIdentifier: "EEFileCell", for: indexPath) as! EEFileCell
        cell.fileModel = slipFiles[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.clickFileItem(slipFiles[indexPath.row])
        if let _ = getFile {
            getFile(slipFiles[indexPath.row])
        }
    }
    
    
//    func clickFileItem(_ fileModel : FileModel) {
//
//    }
    
    
    typealias fileBlock = (FileModel) ->()
    @objc var getFile:fileBlock!

    
}








