//
//  TodayViewController.swift
//  alldayDO Widget
//
//  Created by Fábio Nogueira  on 18/12/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

import UIKit
import NotificationCenter
import alldayDOKit

class ADTodayViewController: UITableViewController, NCWidgetProviding {
    
    // MARK: Properties
    
    var viewModel : ADRemindersViewModel
    
    // MARK: Init Methods
    
    required init(coder aDecoder: NSCoder) {
        viewModel = ADRemindersViewModel()
        super.init(coder: aDecoder)
    }
    
    override init() {
        viewModel = ADRemindersViewModel()
        super.init()
    }
    
    // MARK: Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = self.tableView.contentSize;
        reloadData()
    }
    
    // MARK: UIViewController Methods
    
    override func viewWillAppear(animated: Bool) {
        reloadData()
    }
    
    // MARK: Private Methods
    
    func reloadData() {
        self.viewModel.executeFetchRequestForAll()
        self.tableView.reloadData()
    }
    
    func nextReminderFormatedForLembrete(lembrete: ADLembrete) -> String {
        let dateAsString = dateAsStringFromDate(lembrete.nextFireDate())
        
        let message = "Lembrete em \(dateAsString)"
        
        return message
    }
    
    func dateAsStringFromDate(date: NSDate) -> String {
        var componentsFlag = NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitSecond
        
        var currentCalendar : NSCalendar =  NSCalendar.currentCalendar()
        
        var components = NSCalendar.currentCalendar() .components(componentsFlag, fromDate: NSDate(), toDate: date, options: NSCalendarOptions.allZeros)
        
        return dateAsStringFromComponents(components)

    }
    
    func dateAsStringFromComponents(comp : NSDateComponents) -> String {
        var date = ""
        
        var yearLabel = ""
        if comp.year != 0 {
            if comp.year == 1 {
                yearLabel = "ano"
            } else {
                yearLabel = "anos"
            }
            date = "\(comp.year) \(yearLabel)"
        }
        
        if comp.month != 0 {
            if !date.isEmpty {
                date = date.stringByAppendingString(", ")
            }
            
            var monthLabel = ""
            if comp.month == 1 {
                monthLabel = "mês"
            } else {
                monthLabel = "meses"
            }
            date = date.stringByAppendingString("\(comp.month) \(monthLabel)")
        }
        
        if comp.day != 0 {
            if !date.isEmpty {
                date = date.stringByAppendingString(", ")
            }
            
            var dayLabel = ""
            if comp.day == 1 {
                dayLabel = "dia"
            } else {
                dayLabel = "dias"
            }
            date = date.stringByAppendingString("\(comp.day) \(dayLabel)")
        }
        
        if comp.hour != 0 {
            if !date.isEmpty {
                date = date.stringByAppendingString(", ")
            }
            
            var hourLabel = ""
            if comp.hour == 1 {
                hourLabel = "hora"
            } else {
                hourLabel = "horas"
            }
            date = date.stringByAppendingString("\(comp.hour) \(hourLabel)")
        }
        
        if comp.minute != 0 {
            if !date.isEmpty {
                date = date.stringByAppendingString(", ")
            }
            
            var minuteLabel = ""
            if comp.minute == 1 {
                minuteLabel = "minuto"
            } else {
                minuteLabel = "minutos"
            }
            date = date.stringByAppendingString("\(comp.minute) \(minuteLabel)")
        }
        
        return date
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.undoneReminders.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todayCell", forIndexPath: indexPath) as ADTodayCell
        
        var lembrete = self.viewModel.undoneReminders.objectAtIndex(indexPath.row)

        cell.descricaolabel.text = lembrete.descricao
        cell.badgeIconImageView.image = UIImage(data: lembrete.imagem)?.tintedImageWithColor(UIColor.blackColor())
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var label = UILabel()
        label.textColor = UIColor.lightGrayColor()
        
        if self.viewModel.undoneReminders.count == 0 {
            label.text = NSLocalizedString("undone_reminder_widget", value: "undone_reminder_widget", comment: "")
        } else {
            label.text = NSLocalizedString("atividades_restantes", value: "atividades_restantes", comment: "")
        }
        
        return label
    }
    
    // MARK: - NCWidgetProviding
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        reloadData()
        self.preferredContentSize = self.tableView.contentSize;
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.NewData)
    }
}