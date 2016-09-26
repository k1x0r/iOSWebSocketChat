//
//  WebSocketChatTests.swift
//  WebSocketChatTests
//
//  Created by k1x on 26/09/16.
//  Copyright © 2016 k1x. All rights reserved.
//

import XCTest
import Gloss

class WebSocketChatTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMessage() {
        let dictionary = [
            "author" : "Test Author",
            "message" : "Test Message"
        ]
        let command = Command(json: dictionary);
        
        var commandCompare = Command();
        commandCompare.author = "Test Author";
        commandCompare.commandData = CommandData.Message(message: "Test Message");
        XCTAssert(command! == commandCompare);
        
        commandCompare.author = "Other";
        XCTAssert(command! != commandCompare);
        commandCompare.author = "Test Author";
        XCTAssert(command! == commandCompare);
        commandCompare.commandData = CommandData.Message(message: "Other Message");
        XCTAssert(command! != commandCompare);

    }
    
    func testLatLng() {
        let dictionary = [
            "author" : "Test Author",
            "command" : [
                "type" : "map",
                "data" : [
                    "lat" : Float32(12.33),
                    "lng" : Float32(23.22)
                ]
            ]
        ] as [String : Any]
        
        let command = Command(json: dictionary);
        
        var commandCompare = Command();
        
        commandCompare.author = "Test Author";
        commandCompare.commandData = CommandData.LatLng(lat: 12.33, lng: 23.22);

        XCTAssert(command! == commandCompare);
        commandCompare.author = "Other";
        XCTAssert(command! != commandCompare);
        commandCompare.author = "Test Author";
        XCTAssert(command! == commandCompare);
        commandCompare.commandData =  CommandData.LatLng(lat: 12.33, lng: 23.25);
        XCTAssert(command! != commandCompare);
        
    }
    
    func testRate() {
        let dictionary = [
            "author" : "Test Author",
            "command" : [
                "type" : "rate",
                "data" : [
                    1, 5
                ]
            ]
            ] as [String : Any]
        
        let command = Command(json: dictionary);
        
        var commandCompare = Command();
        
        commandCompare.author = "Test Author";
        commandCompare.commandData = CommandData.Rate(minMax: [1, 5]);
        
        XCTAssert(command! == commandCompare);
        commandCompare.author = "Other";
        XCTAssert(command! != commandCompare);
        commandCompare.author = "Test Author";
        XCTAssert(command! == commandCompare);
        commandCompare.commandData =  CommandData.Rate(minMax: [1, 4]);
        XCTAssert(command! != commandCompare);
        
    }
    
    func testComplete() {
        let dictionary = [
            "author" : "Test Author",
            "command" : [
                "type" : "complete",
                "data" : [
                    "Yes",
                    "No"
                ]
            ]
            ] as [String : Any]
        
        let command = Command(json: dictionary);
        
        var commandCompare = Command();
        
        commandCompare.author = "Test Author";
        commandCompare.commandData = CommandData.Complete(variants: ["Yes", "No"]);
        
        XCTAssert(command! == commandCompare);
        commandCompare.author = "Other";
        XCTAssert(command! != commandCompare);
        commandCompare.author = "Test Author";
        XCTAssert(command! == commandCompare);
        commandCompare.commandData =  CommandData.Complete(variants: ["Yes", "Yes"]);
        XCTAssert(command! != commandCompare);
        
    }
    
    func testDate() {
        let dateString = "2016-09-23T09:54:07.249Z";
        let dictionary = [
            "author" : "Test Author",
            "command" : [
                "type" : "date",
                "data" : dateString
            ]
            ] as [String : Any]
        
        let command = Command(json: dictionary);
        
        var commandCompare = Command();
        
        commandCompare.author = "Test Author";
        commandCompare.commandData = CommandData.Date(date: dateFormatter.date(from: dateString)!);
        
        XCTAssert(command! == commandCompare);
        commandCompare.author = "Other";
        XCTAssert(command! != commandCompare);
        commandCompare.author = "Test Author";
        XCTAssert(command! == commandCompare);
        commandCompare.commandData =  CommandData.Date(date: Date());
        XCTAssert(command! != commandCompare);
        
    }

    
}
