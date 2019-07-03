//
//  EEFileManager.swift
//  FileManager
//
//  Created by aosue on 2019/6/20.
//  Copyright © 2019 aosue. All rights reserved.
//

import UIKit


class EEFileManager: NSObject {
    
    func QuickLookAllFiles(_ path : String) -> [FileModel] {
        var files = [FileModel]()
        var paths = [String]()
        do {
            paths = try FileManager.default.contentsOfDirectory(atPath: path)
            
            for filePath in paths {
                let model = FileModel(path+"/"+filePath)
                files.append(model)
                if model.type == .folder {
                    files += self.QuickLookAllFiles(model.url.path!)
                }
            }
            
        }catch{
            
        }
        
        return files;
    }

}

// the same as file icon names
enum FileType :String {
    case unknown = "eeunknown"
    case image = "eeimage"
    case txt = "eetxt"
    case pdf = "eepdf"
    case word = "eeword"
    case excel = "eeexcel"
    case ppt = "eeppt"
    case audio = "eeaudio"
    case video = "eevideo"
    case folder = "eefolder"
    case package = "eepackage"
}

@objc class FileModel: NSObject {
    @objc var name = ""
    
    @objc lazy var length : NSInteger = {
        return NSData(contentsOf: url as URL)?.length ?? 0
    }()
    @objc lazy var size : String = {
        return getFileSizeString()
    }()
    @objc var url = NSURL()
    @objc var fileExtension = "" // 文件后缀名
    var type :FileType = FileType.unknown
    @objc var creatDate = NSDate()
    @objc var editDate = NSDate()
    
    @objc convenience init(_ path: String) {
        self.init()
        self.url = NSURL(fileURLWithPath: path) as NSURL
        self.name = url.lastPathComponent!
        self.fileExtension = self.name.components(separatedBy: ".").last!
        self.type = getFileType()
        
        do {
            let dic : NSDictionary = try FileManager.default.attributesOfItem(atPath: self.url.path!) as NSDictionary
            self.editDate = dic.value(forKey: "NSFileModificationDate") as! NSDate
            self.creatDate = dic.value(forKey: "NSFileCreationDate") as! NSDate
        } catch {
            
        }
        
    }
    
    @objc func getFileSizeString() -> String {
        if self.length > Int(pow(1000.0, 3)) {
            return String(format: "%.2f", Double(self.length) / pow(1000.0, 3)) + " GB"
        }
        if self.length > Int(pow(1000.0, 2)) {
            return String(format: "%.2f", Double(self.length) / pow(1000.0, 2)) + " MB"
        }
        if self.length > 1000 {
            return String(format: "%.2f", Double(self.length) / 1000.0) + " KB"
        }
        return String(self.length) + " B";
    }
    
    func getFileType() -> FileType {
        if ["jpg","jpeg","png","gif","bmp","tiff","svg","raw","webp","heif"].contains(self.fileExtension.lowercased()) {
            return .image
        }
        if ["txt","json"].contains(self.fileExtension.lowercased()) {
            return .txt
        }
        if ["pdf"].contains(self.fileExtension.lowercased()) {
            return .pdf
        }
        if ["doc","docx","rtf","pages","dot","dotx","docm","dotm"].contains(self.fileExtension.lowercased()) {
            return .word
        }
        if ["xls","xlsx","numbers","xlt","xltx","csv","xlsb","xlsm","xlam","xla"].contains(self.fileExtension.lowercased()) {
            return .excel
        }
        if ["ppt","pptx","pot","potx","odp","pps","ppsx","pptm","potm","ppsm"].contains(self.fileExtension.lowercased()) {
            return .ppt
        }
        if ["mp3","flac","acc","ape","alac","wavpack","wav","midi","cd","ogg","vaf","amr"].contains(self.fileExtension.lowercased()) {
            return .audio
        }
        if ["wmv","asf","asx","rm","rmvb","pm4","3gp","mov","m4v","avi","dat","mkv","flv","vob"].contains(self.fileExtension.lowercased()) {
            return .video
        }
        if ["zip","rar","7z","xar","tar"].contains(self.fileExtension.lowercased()) {
            return .package
        }
        if self.isFolder(self.url) {
            return .folder
        }
        return .unknown
    }
    
    @objc func isFolder(_ url:NSURL) -> Bool {
        var isfolder = ObjCBool.init(false)
        FileManager.default.fileExists(atPath: url.path!, isDirectory: &isfolder)
        return isfolder.boolValue
    }
    
    @objc func getFileSlip(_ typeStr:String) -> Bool {
        if typeStr == "doc" && type == .word {
            return true
        }
        if typeStr == "jpg" && type == .image {
            return true
        }
        return false
    }
}
