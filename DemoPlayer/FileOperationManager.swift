//
//  Downloader.swift
//  DemoPlayer
//
//  Created by Tomas Pollak on 03/11/2023.
//

import Foundation

enum FileOperationStatus  {
    case saved
    case downloading
    case notSaved
}

class FileOperationManager : NSObject, URLSessionDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate
{
    private var session: URLSession!
    private var fileUrl: URL!
    
    private let byteFormatter: ByteCountFormatter = {
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = [.useKB, .useMB]
            return formatter
        }()
    
    static let shared = FileOperationManager()

    func download(url: URL, fileName: String)
    {
        guard let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return
        }
        fileUrl = directory.appendingPathComponent(fileName)
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        session.downloadTask(with: url).resume()
        let fileName = fileUrl.lastPathComponent
        NotificationCenter.default.post(name: Notification.Name.fileStatus, object: fileName, userInfo: ["status" : FileOperationStatus.downloading])
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let data = try? Data(contentsOf: location) {
            writeToFile(data: data)
            let fileName = fileUrl.lastPathComponent
            NotificationCenter.default.post(name: Notification.Name.fileStatus, object: fileName, userInfo: ["status" : FileOperationStatus.saved])
        } else {
            fatalError("Cannot load the image")
        }
        
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        let fileName = fileUrl.lastPathComponent
        NotificationCenter.default.post(name: Notification.Name.fileStatus, object: fileName, userInfo: ["status" : FileOperationStatus.downloading,"progress" : progress])
    }

    
    func writeToFile(data: Data)
    {
        if FileManager.default.fileExists(atPath: fileUrl.path)
        {
            if let fileHandle = FileHandle(forWritingAtPath: fileUrl.path)
            {
                
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
                print("Path: \(fileUrl.absoluteString)")
            }
            else
            {
                print("Can't open file to write")
            }
        }
        else
        {
            
            do
            {
                
                try data.write(to: fileUrl, options: .atomic)
                
                
            }
            catch
            {
                print("Unable to write in new file")
            }
        }
    }
    
    func stopDownloading() {
        session.invalidateAndCancel()
        let fileName = fileUrl.lastPathComponent
        deleteFile(url: fileUrl)
        NotificationCenter.default.post(name: Notification.Name.fileStatus, object: fileName, userInfo: ["status" : FileOperationStatus.notSaved])
    }
    
    func deleteFile(url: URL) {
        let fileName = url.lastPathComponent
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let directory = paths[0]
        let localURL = directory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: localURL.path) {
            do {
                try FileManager.default.removeItem(at: localURL)
                NotificationCenter.default.post(name: Notification.Name.fileStatus, object: fileName, userInfo: ["status" : FileOperationStatus.notSaved])

            } catch {
                print(error)
            }
        }
        
    }
    
    func getDocumentsDirectory(fileName: String) -> URL? {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let directory = paths[0]
        let localURL = directory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: localURL.path) {
            return localURL
        } else {
            return nil
        }
        
    }
    
}


