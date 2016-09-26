//
//  Views.swift
//  WebSocketChat
//
//  Created by k1x on 25/09/16.
//  Copyright © 2016 k1x. All rights reserved.
//

import Foundation
import MapKit
import Cosmos

class MapViewCell : UITableViewCell {
    @IBOutlet var mapView : MKMapView!;
}

class RateViewCell : UITableViewCell {
    @IBOutlet var cosmosView : CosmosView!;
    
    var isInit = false;
    
    var delegate : ((RateViewCell, Int32) -> ())?;
    
    override func layoutSubviews() {
        super.layoutSubviews();
        if !isInit {
            cosmosView.didTouchCosmos = { value in
                print("Touch finished... \(value)");
                self.delegate?(self, Int32(value));
            }
        }
    }
    
}



class YesNoCell : UITableViewCell {
    @IBOutlet var yesNoContainer : UIView!;
    @IBOutlet var myTextLabel : UILabel!;

    private var _state : Bool?;

    var state : Bool? {
        get {
            return _state;
        }
        set (newState) {
            if let newStateUnw = newState {
                self.myTextLabel.text = newStateUnw ? "Yes" : "No";
                yesNoContainer.isHidden = true;
            } else {
                self.myTextLabel.text = "Complete the current action:"
                yesNoContainer.isHidden = false;
            }
            yesNoContainer.setNeedsDisplay();
        }
    }
    
    var delegate : ((YesNoCell, Bool) -> ())?;
    
    @IBAction func yesBtnPressed(sender : AnyObject?) {
        delegate?(self, true);
    }

    @IBAction func noBtnPressed(sender : AnyObject?) {
        delegate?(self, false);
    }

}

let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

class DayOfWeekCell : UITableViewCell {
    @IBOutlet var segmentedControl : UISegmentedControl!;
    
    
    var delegate : ((DayOfWeekCell, Int) -> ())?;

    @IBAction func didSegmentedControlChangedValue(sender : UISegmentedControl?) {
        delegate?(self, sender!.selectedSegmentIndex);
        segmentedControl.isUserInteractionEnabled = false;
    }
    
    func setNewState(date : Date, selectedValueW : Int32?)  {
        // 6 Friday
        let shift = -(date.getDayOfWeek()! - 2);
        let newArray = daysOfWeek.shiftRight(amount: shift);
        
        for (index, dayOfWeek) in newArray.enumerated() {
            segmentedControl.setTitle(dayOfWeek, forSegmentAt: index);
        }
        if let selectedValue = selectedValueW {
            segmentedControl.selectedSegmentIndex = Int(selectedValue);
            segmentedControl.isUserInteractionEnabled = false;
        } else {
            segmentedControl.selectedSegmentIndex = 0;
            segmentedControl.isUserInteractionEnabled = true;
        }
    }
    
}
