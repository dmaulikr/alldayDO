//
//  TodayViewController.swift
//  alldayDO Widget
//
//  Created by Fábio Nogueira  on 18/12/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

import UIKit
import NotificationCenter
import WidgetKit

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
//        reloadData()
    }
    
    // MARK: Private Methods
    
    func reloadData() {
        self.viewModel.executeFetchRequestForAll()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.viewModel.todayReminders.count
        return 3;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todayCell", forIndexPath: indexPath) as ADTodayCell
        
//        self.viewModel.fetchObjectAtIndexPath(indexPath)
        
//        cell.descricaolabel.text = self.viewModel.descricao
//        cell.nextReminderLabel.text = self.viewModel.nextReminderFormated()
//        
//        cell.badgeIconImageView.image = self.viewModel.imagem
    
        cell.badgeIconImageView.image = UIImage(named: "10")?.tintedImageWithColor(UIColor.darkGrayColor())

        return cell
    }
    
    // MARK: - NCWidgetProviding
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
//        reloadData()
        self.preferredContentSize = self.tableView.contentSize;
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.NewData)
    }
}