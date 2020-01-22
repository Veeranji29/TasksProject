//
//  ViewController.swift
//  TasksProject
//
//  Created by Veera Diande on 11/12/19.
//  Copyright © 2019 Brandenburg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    let cellId = "cellId"
    var rowTableView = UITableView()
    var arrRowData = [Row]()
    var activityView = UIActivityIndicatorView()
    private let refreshControl = UIRefreshControl()
    var navigationBar = UINavigationBar()
    var resTitle: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureTableView()
    }
    override func viewWillLayoutSubviews() {
        // Adding NavigationBar
        let yPos = CGFloat(view.frame.height <= 736 ? 20 : view.frame.height >= 1024 ? 20 : 40)
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: yPos, width: self.view.frame.width, height: 44))
        self.view.addSubview(navigationBar);
        let navigationItem = UINavigationItem(title: self.resTitle ?? "")
        self.navigationBar.setItems([navigationItem], animated: false)
    }
    //MARK: - Configure TableView
    func configureTableView() {
        let yPos = CGFloat(view.frame.height <= 736 ? 70 : view.frame.height >= 1024 ? 70 : 90)
        let dummyView: UIView = UIView(frame: CGRect(x: 0, y: yPos, width: view.frame.width, height: 44))
        view.addSubview(dummyView)
        rowTableView.dataSource = self
        rowTableView.estimatedRowHeight = 100
        rowTableView.rowHeight = UITableView.automaticDimension
        rowTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellId)
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            rowTableView.refreshControl = refreshControl
        } else {
            rowTableView.addSubview(refreshControl)
        }
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data ...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)])
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        view.addSubview(rowTableView)
        rowTableView.translatesAutoresizingMaskIntoConstraints = false
        rowTableView.topAnchor.constraint(equalTo: dummyView.topAnchor).isActive = true
        rowTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        rowTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rowTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.showActivityIndicatory()
        
        self.parseJsonData()
    }
    //  Refresh Data Method
    @objc private func refreshData(_ sender: Any) {
        // Fetch Data
        self.parseJsonData()
    }
    
    //MARK: - Api calling Methods
    func parseJsonData() -> Void {
        let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            guard let mime = response.mimeType, mime == "text/plain" else {
                print("Wrong MIME type!")
                return
            }
            let jsonString = String(decoding: data!, as: UTF8.self)
            let jsonData = jsonString.data(using: .utf8)!
            
            do {
                let res = try JSONDecoder().decode(FactsData.self, from: jsonData)
                self.arrRowData = res.rows
                DispatchQueue.main.async { // Make sure you're on the main thread here
                    self.resTitle = res.title
                    let navigationItem = UINavigationItem(title: self.resTitle ?? "")// Dynamic NavigationBar title
                    self.navigationBar.setItems([navigationItem], animated: false)
                    self.rowTableView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.removeActivityIndicatory()
                    
                }
            } catch let error {
                print(error)
            }
            
        }
        
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK: - UITableView Delegate Methods
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRowData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomTableViewCell
        cell.rowValues = arrRowData[indexPath.row]
        return cell
    }
}
//MARK: -  Loader Methods
extension ViewController {
    // Loader View Open ------------------------>
    func showActivityIndicatory() {
        let container: UIView = UIView()
        container.frame = CGRect(x: 0, y: 80, width: 40, height: 40) // Set X and Y whatever you want
        container.backgroundColor = .clear
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: .large)
        } else {
            activityView = UIActivityIndicatorView(style: .gray)
        }
        activityView.center = self.view.center
        activityView.tag = 101110100
        rowTableView.addSubview(activityView)
        //        appDelegate.window?.addSubview(container)
        activityView.startAnimating()
    }
    func removeActivityIndicatory() {
        Timer.scheduledTimer(timeInterval: 0.5, target: self , selector: #selector(self.loaderRemoved), userInfo: nil, repeats: false)
    }
    @objc func loaderRemoved() {
        activityView.stopAnimating()
        appDelegate.window?.viewWithTag(101110100)?.removeFromSuperview()
    }
    
}
