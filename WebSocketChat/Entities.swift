//
//  Entities.swift
//  WebSocketChat
//
//  Created by k1x on 24/09/16.
//  Copyright © 2016 k1x. All rights reserved.
//

import Foundation
import Gloss

var dateFormatterVar : DateFormatter {
    let dateFormatter = DateFormatter();
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC");
    return dateFormatter;
};
var dateFormatter = dateFormatterVar;

enum CommandData {
    case Date(date : Date);
    case LatLng(lat : Float, lng : Float);
    case Complete(variants : [String]);
    case Rate(minMax : [Int32]);
    case Message(message : String);
}



struct Command : Decodable {
    
    var author : String?;
    var commandData : CommandData?;
    var selectedIndex : Int32?;
    var boolValue : Bool?;

    init() {
    }
    
    init?(json: JSON) {
        author = "author" <~~ json;
        if let message : String = "message" <~~ json {
            commandData = .Message(message : message);
        } else if let command : JSON = "command" <~~ json {
            let commandType : String! = "type" <~~ command;
            switch commandType  {
                case "complete":
                    if let variants : [String] = "data" <~~ command {
                        commandData = .Complete(variants: variants);
                    }
                    break;
                case "date":
                    if let date : String = "data" <~~ command {
                        if let nsdate = dateFormatter.date(from: date) {
                            commandData = .Date(date: nsdate);
                        }
                    }
                    break;
                case "map":
                    if let variants : JSON = "data" <~~ command {
                        let lat : Float32! = "lat" <~~ variants;
                        let lng : Float32! = "lng" <~~ variants;
                        if lat != nil && lng != nil {
                            commandData = .LatLng(lat : lat!, lng : lng!);
                        }
                    }
                    break;
                case "rate":
                    if let variants : [Int32] = "data" <~~ command {
                        commandData = .Rate(minMax: variants);
                    }
                    break;
                default:
                    break;
            }
            
        }
    }
}
