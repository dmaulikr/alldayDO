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
    
    var viewModel : ADToday
    
    // MARK: Init Methods
    
    required init(coder aDecoder: NSCoder) {
        viewModel = ADToday()
        super.init(coder: aDecoder)
    }
    
    override init() {
        viewModel = ADToday()
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
        self.viewModel.executeFetchRequestForToday()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.todayReminders.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todayCell", forIndexPath: indexPath) as ADTodayCell
        
        var lembrete: AnyObject = self.viewModel.todayReminders.objectAtIndex(indexPath.row)
        
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
        
        if self.viewModel.todayReminders.count == 0 {
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