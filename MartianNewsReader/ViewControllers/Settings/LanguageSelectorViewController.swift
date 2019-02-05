//
//  LanguageSelectorViewController.swift
//  MartianNewsReader
//
//  Created by Xin Zou on 2/5/19.
//  Copyright © 2019 NYTimes. All rights reserved.
//

import UIKit

class LanguageSelectorViewController: UITableViewController {
    
    let languageCellId = "settingsLanguageCell"
    let dataSource = AppLanguage.allCases
    var selectedIndexPath: IndexPath?
    let currentLanguage = UserDefaults.getAppLanguage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L("settings.ui.title.change-language")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: languageCellId)
        setupNavigationBarButtonItem()
        
        for i in 0..<dataSource.count {
            if currentLanguage == dataSource[i] {
                selectedIndexPath = IndexPath(item: i, section: 0)
                break
            }
        }
    }
    
    private func setupNavigationBarButtonItem() {
        let confirmButton = UIBarButtonItem(title: L("settings.change-language.confirmed"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(handleSaveButton))
        navigationItem.rightBarButtonItem = confirmButton
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: languageCellId, for: indexPath)
        let appLanguage = dataSource[indexPath.row]
        cell.textLabel?.text = appLanguage.selectorTitle()
        if (selectedIndexPath == indexPath) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    @objc func handleSaveButton(sender: UIButton) {
        guard let selectedIndexPath = selectedIndexPath,
            selectedIndexPath.row < dataSource.count,
            currentLanguage != dataSource[selectedIndexPath.row] else {
                
            navigationController?.popViewController(animated: true)
            return
        }
        let appLanguage = dataSource[selectedIndexPath.row]
        displayOkAlert(title: L("settings.change-language.change.title"), message: L("settings.change-language.change.message"), action: L("action.ok"), completion: { [weak self] in
            UserDefaults.setAppLanguage(appLanguage)
            self?.navigationController?.popViewController(animated: true)
        })
    }
}

extension LanguageSelectorViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectedIndexPath = selectedIndexPath {
            let selectedCell = tableView.cellForRow(at: selectedIndexPath)
            selectedCell?.accessoryType = .none
        }
        
        selectedIndexPath = indexPath
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
}
