//
//  TodayViewController.swift
//  alldayDO Widget
//
//  Created by Fábio Nogueira  on 18/12/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding {
    
    // MARK: - UIControllerView Methods
    
    override func viewDidLoad() {
    super.viewDidLoad()
    self.preferredContentSize = self.tableView.contentSize;
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("todayCell", forIndexPath: indexPath) as ADTodayCell
    
    cell.descricaolabel.text = "Fazer funcionar o Widget"
    cell.nextReminderLabel.text = "Próximo lembrete em 18 horas"
    return cell
    }
    
    // MARK: - NCWidgetProviding
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        self.preferredContentSize = self.tableView.contentSize;
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.NewData)
    }
}