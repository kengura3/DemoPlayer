//
//  DemoPlayerTests.swift
//  DemoPlayerTests
//
//  Created by Tomas Pollak on 02/11/2023.
//

import XCTest
@testable import DemoPlayer


final class DemoPlayerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNavigationbarButton() throws {

        let detailViewController = DetailViewController()
        var fileStatus = FileOperationStatus.saved
        var button = detailViewController.customDownloadBarButton(status: fileStatus)
        
        XCTAssert(button.title != "Delete")
        
        fileStatus = .downloading
        button = detailViewController.customDownloadBarButton(status: fileStatus)
        
        XCTAssert(button.title != "Downloading")
        
        fileStatus = .notSaved
        button = detailViewController.customDownloadBarButton(status: fileStatus)
        
        XCTAssert(button.title != "Download")
       
    }
    
    func testFetchImageFromURL() async throws {
        
        let thumbnailImageLoader = await ThumbnailImageLoader()

        var didFailWithError: Error?
        do {
            _ = try await thumbnailImageLoader.fetchImage(URL(string: "https://wrongLink.json")!)
            
        } catch {
            didFailWithError = error
            
        }
        
        didFailWithError = nil
        do {
            _ = try await thumbnailImageLoader.fetchImage(URL(string: "https://fksoftware.sk/video/video.png")!)
            
        } catch {
            didFailWithError = error
            
        }
        XCTAssertNil(didFailWithError)
        

        
    }

}
