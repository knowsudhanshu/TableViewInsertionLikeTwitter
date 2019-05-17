//
//  ViewController.swift
//  TableViewInsertionLikeTwitter
//
//  Created by Sudhanshu Sudhanshu on 16/05/19.
//  Copyright © 2019 Sudhanshu Sudhanshu. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {
    static let identifier: String = String(describing: type(of:self))
    
}
class ViewController: UIViewController {
    
    let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(pullToRefreshAction), for: .valueChanged)
        return rc
    }()
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.delegate = self
        tbv.dataSource = self
        return tbv
    }()
    
    var dataArr:[String] = ["hello", "here", "can you see me", "hello", "here", "can you see me", "hello", "here", "can you see me", "hello", "here", "can you see me", "hello", "here", "can you see me", "hello", "here", "can you see me", "hello", "here", "can you see me", "hello", "here", "can you see me", "hello", "here", "can you see me", "hello", "here", "can you see me"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableView.register(MyCell.self, forCellReuseIdentifier: MyCell.identifier)
        
        tableView.refreshControl = refreshControl
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        tableView.reloadData()
    }
    
    
    @objc private func pullToRefreshAction() {
        tableView.refreshControl?.beginRefreshing()
        perform(#selector(insertCell), with: nil, afterDelay: 2)
    }
    
    @objc func insertCell() {
        tableView.refreshControl?.endRefreshing()

        let seeMoreView = NotificationBannerView(autoDismiss: false)
        seeMoreView.tapAction = {
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        seeMoreView.show()
        
        var indexPathArr: [IndexPath] = []
        
        for i in 0..<5 {
            let indexPath = IndexPath(item: i, section: 0)
            indexPathArr.append(indexPath)
            
            dataArr.insert("new cell \(i)", at: 0)
        }
        
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.insertRows(at: indexPathArr, with: .none)
            tableView.endUpdates()
            
            tableView.scrollToRow(at: IndexPath(row: indexPathArr.count, section: 0), at: .top, animated: false)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCell.identifier, for: indexPath)
        cell.textLabel?.text = dataArr[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {}

