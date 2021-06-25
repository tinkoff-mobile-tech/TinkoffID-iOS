//
//  DebugViewController.swift
//  TinkoffID Debug
//
//  Created by Dmitry Overchuk on 24.06.2021.
//

import UIKit

final class DebugViewController: UITableViewController {
    
    private let output: DebugViewOutput
    
    init(output: DebugViewOutput) {
        self.output = output
        
        if #available(iOS 13.0, *) {
            super.init(style: .insetGrouped)
        } else {
            super.init(style: .grouped)
        }
        
        title = "Tinkoff ID Debug"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: .cellIdentifier)
    }
}

// MARK: - UITableViewDataSource

extension DebugViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Выберите действие"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DebugViewResult.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: .cellIdentifier,
            for: indexPath
        )
        
        switch DebugViewResult(rawValue: indexPath.row) {
        case .success:
            cell.textLabel?.text = "Вернуться и успешно завершить вход"
        case .failure:
            cell.textLabel?.text = "Вернуться и не завершить вход"
        case .cancelled:
            cell.textLabel?.text = "Отменить вход"
        case .unavailable:
            cell.textLabel?.text = "Симуляция недоступности входа"
        default:
            break
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DebugViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            navigationController?.dismiss(animated: true, completion: nil)
        }
        
        guard let result = DebugViewResult(rawValue: indexPath.row) else { return }
        
        output.handleDebugViewResult(result)
    }
}

// MARK: - Private

private extension String {
    static let cellIdentifier = "Cell"
}
 
