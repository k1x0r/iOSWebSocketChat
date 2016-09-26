//
//  MasterViewController.swift
//  WebSocketChat
//
//  Created by k1x on 21/09/16.
//  Copyright © 2016 k1x. All rights reserved.
//

import UIKit
import SocketIO
import MapKit

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var objects = [Command]()
    
    var socket : SocketIOClient!;
    @IBOutlet var tableView : UITableView!;
    @IBOutlet var textField : UITextField!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(-56, 0, 0, 0);

        textField.delegate = self;
        tableView.delegate = self;
        tableView.dataSource = self;
        
        func parseCommand(data : [Any]) {
            let string = String(describing: data);
            print("Got command: \(string)")
            let command = Command(json : data[0] as! [String : Any]);
            print("\(command)");
            
            let index = self.objects.count;
            self.objects.append(command!);
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: index, section: 0);
                self.tableView.insertRows(at: [indexPath], with: .automatic);
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true);
            }
            
        }
        
        socket = SocketIOClient(socketURL: URL(string: "http://demo-chat.ottonova.de/")!, config: [.log(true), .forcePolling(true)])
        
        socket.on("connect") {data, ack in
            print("socket connected")
        }
        
        socket.on("message") {data, ack in
            parseCommand(data: data);
        }
        
        
        socket.on("command") {data, ack in
            parseCommand(data: data);
        }
        socket.connect()

    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateTextView(up: true);
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateTextView(up: false);
    }

    func animateTextView(up : Bool)
    {
        var movementDistance = 0;
        if UIScreen.main.scale == 3.0 {
            movementDistance = 225
        } else {
            movementDistance = 215;
        }
        let movement = (up ? -movementDistance : movementDistance);
        NSLog("%d",movement);
        UIView.beginAnimations("anim", context: nil);
        UIView.setAnimationBeginsFromCurrentState(true);
        UIView.setAnimationDuration(0.35);
        var newOffset = self.tableView.contentOffset;
        newOffset.y += CGFloat(movement);
        self.tableView.contentOffset = newOffset;
        var newFrame = self.view.frame;
        newFrame.size.height += CGFloat(movement);
        self.view.frame = newFrame;
        UIView.commitAnimations();
    }

    
    @IBAction func editingEnded(sender : UIView) {
        sender.resignFirstResponder();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true);
        sendMessage();
        return false;
    }
    
    @IBAction func sendButtonDidPressed(_ sender: Any) {
        sendMessage();
    }
    
    func sendMessage() {
        var dictionary = [String : String]();
        dictionary["author"] = "Android Test";
        dictionary["message"] = textField.text!;
        
        socket.emit("message", with: [dictionary]);
        textField.text = "";
        textField.endEditing(true);
    }
    
    @IBAction func cmdButtonDidPressed(_ sender: Any) {
        socket.emit("command", with: []);
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let object = objects[indexPath.row];
        
        switch object.commandData! {
            case .Date(let date):
//                object.commandDataSelected!.
                let cell = tableView.dequeueReusableCell(withIdentifier: "DayOfWeekCell", for: indexPath) as! DayOfWeekCell
                cell.setNewState(date: date, selectedValueW: object.selectedIndex);
                cell.delegate = dayOfWeekDidPressed;
                return cell
            case .Complete(let variants):
                let cell = tableView.dequeueReusableCell(withIdentifier: "YesNoCell", for: indexPath) as! YesNoCell
                cell.state = object.boolValue;
                cell.delegate = yesNoCellDidPressed;
                return cell
            case .Rate(let minMax):
                let cell = tableView.dequeueReusableCell(withIdentifier: "RateViewCell", for: indexPath) as! RateViewCell
                cell.delegate = rateViewCellDidPressed;
                cell.cosmosView.settings.updateOnTouch = object.selectedIndex == nil;
                cell.cosmosView.rating = object.selectedIndex != nil ? Double(object.selectedIndex!) : 0.0;
                cell.cosmosView.setNeedsDisplay();
                return cell
            case .Message(let message):
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel!.text = "\(object.author!): \(message)";
                return cell
            case .LatLng(let lat, let lng):
                let cell = tableView.dequeueReusableCell(withIdentifier: "MapViewCell", for: indexPath) as! MapViewCell
                cell.mapView.removeAnnotations(cell.mapView.annotations);
                let annotation = MKPointAnnotation();
                annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lng));
                cell.mapView.addAnnotation(annotation);
                cell.mapView.setCenter(annotation.coordinate, animated: false);
                return cell
        }
    }
    
    func dayOfWeekDidPressed(dayOfWeekCell: DayOfWeekCell, value : Int)  {
        let indexPath = tableView.indexPath(for: dayOfWeekCell)!;
        if objects[indexPath.row].selectedIndex != nil {
            return;
        }
        objects[indexPath.row].selectedIndex = Int32(value);
    }

    func yesNoCellDidPressed(rateCell : YesNoCell, state : Bool)  {
        let indexPath = tableView.indexPath(for: rateCell)!;
        if objects[indexPath.row].boolValue != nil {
            return;
        }
        objects[indexPath.row].boolValue = state;
        rateCell.state = state;
    }
    
    
    func rateViewCellDidPressed(rateCell : RateViewCell, stars : Int32)  {
        let indexPath = tableView.indexPath(for: rateCell)!;
        if objects[indexPath.row].selectedIndex != nil {
            return;
        }
        objects[indexPath.row].selectedIndex = stars;
        rateCell.cosmosView.settings.updateOnTouch = false;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let object = objects[indexPath.row];
        
        switch object.commandData! {
            case .LatLng:
                return 185;
            default:
                return 44;
        }
    }
    

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

