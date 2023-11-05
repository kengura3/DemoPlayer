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

class FileOperationManager : NSObject, URLSessionDelegate, URLSessionDataDelegate
{
    private var session: URLSession!
    private var dataTask: URLSessionDataTask!
    private var fileUrl: URL!
    
    static let shared = FileOperationManager()

    func download(url: URL, fileName: String)
    {
        guard let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return
        }
        fileUrl = directory.appendingPathComponent(fileName)
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        dataTask = session.dataTask(with: request)
        dataTask.resume()
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
    {
        print("Data received")
        writeToFile(data: data)
        
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                    completionHandler: (URLSession.ResponseDisposition) -> Void)
    {
        completionHandler(URLSession.ResponseDisposition.allow)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        if error == nil {
            let fileName = fileUrl.lastPathComponent
            NotificationCenter.default.post(name: Notification.Name.fileStatus, object: fileName, userInfo: ["status" : FileOperationStatus.saved])
            
        }
    }
    
    func writeToFile(data: Data)
    {
        // if file exists then write data
        if FileManager.default.fileExists(atPath: fileUrl.path)
        {
            if let fileHandle = FileHandle(forWritingAtPath: fileUrl.path)
            {
                // seekToEndOfFile, writes data at the last of file(appends not override)
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
            // if file does not exist write data for the first time
            do
            {
                print("Writing")
                let fileName = fileUrl.lastPathComponent
                NotificationCenter.default.post(name: Notification.Name.fileStatus, object: fileName, userInfo: ["status" : FileOperationStatus.downloading])
                try data.write(to: fileUrl, options: .atomic)
            }
            catch
            {
                print("Unable to write in new file")
            }
        }
    }
    
    func stopDownloading() {
        dataTask.cancel()
        let fileName = fileUrl.lastPathComponent
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

extension Notification.Name {
    static let fileStatus = Notification.Name("FileStatus")
    
}
