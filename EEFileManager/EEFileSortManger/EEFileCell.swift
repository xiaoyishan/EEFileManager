//
//  EEFileCell.swift
//  FileManager
//
//  Created by aosue on 2019/6/24.
//  Copyright © 2019 aosue. All rights reserved.
//

import UIKit

class EEFileCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        contentView.addSubview(fileImageView)
        contentView.addSubview(fileTitleLaebl)
        contentView.addSubview(fileDescriptionLaebl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var _fileModel: FileModel?
    var fileModel: FileModel? {
        get {
            return _fileModel
        }
        set(fileModel) {
            _fileModel = fileModel
            
            fileImageView.image = UIImage(named: _fileModel!.type.rawValue)
            if fileModel?.type == .image {
                do {
                    let imageData = NSData(contentsOf: fileModel!.url as URL)
                    self.fileImageView.image = UIImage.init(data: imageData! as Data)
                }
            }
            fileTitleLaebl.text = _fileModel?.name
            
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy-MM-dd HH:mm"
            let datestr = dformatter.string(from:_fileModel?.creatDate as! Date)
            
            fileDescriptionLaebl.text = datestr + "   " + _fileModel!.size
            
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fileImageView.frame = CGRect (x: 15, y: 5, width: contentView.frame.height-10, height: contentView.frame.height-10)
        fileTitleLaebl.frame = CGRect (x: (fileImageView.frame.maxX) + 15, y: 8, width: contentView.frame.width-fileImageView.frame.maxX-15*2, height: 26)
        fileDescriptionLaebl.frame = CGRect (x: (fileImageView.frame.maxX) + 15, y: 5 + fileTitleLaebl.frame.maxY, width: fileTitleLaebl.frame.width, height: 13)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    lazy var fileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var fileTitleLaebl : UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 2
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor.darkGray
        return lable
    }()
    lazy var fileDescriptionLaebl : UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 2
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textColor = UIColor.gray
        return lable
    }()
    
}
