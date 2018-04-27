//
//  ViewController.swift
//  Calendar
//
//  Created by Andy on 4/22/18.
//  Copyright © 2018 Andy. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {

    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarView()
    }

    func setupCalendarView() {
        //Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //Setup labels
        calendarView.visibleDates {(visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func handleCellTextColor(view: JTAppleCell, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        
        if validCell.isSelected {
            //Date that is selected is light gray
            validCell.dateLabel.textColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                //Dates that belong to the current month are black
                validCell.dateLabel.textColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
            } else {
                //Dates that do not belong to the current month are gray
                validCell.dateLabel.textColor = UIColor(red:0.44, green:0.44, blue:0.44, alpha:1.0)
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        yearLbl.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        monthLbl.text = formatter.string(from: date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK : JTAppleCalendarDelegate
extension ViewController: JTAppleCalendarViewDataSource {
    public func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
    }

    public func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2018 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    
}

extension ViewController: JTAppleCalendarViewDelegate {
    // Display the cell
    public func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell!, cellState: cellState)
        handleCellTextColor(view: cell!, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell!, cellState: cellState)
        handleCellTextColor(view: cell!, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
}

