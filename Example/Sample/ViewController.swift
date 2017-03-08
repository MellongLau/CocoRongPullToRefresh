//
// Copyright (c) 2017 Mellong Lau
// https://github.com/MellongLau/CocoRongPullToRefresh
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit


class ViewController: UITableViewController {
    var datasource: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
        title = "CRPullToRefresh"
        
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        var dataList: [String] = []
        for i in 1...30 {
            dataList.append("Title for \(i)")
        }
        
        // Enable pull to refresh.
        tableView.cr.enablePullRefresh(loadingView: LoadingCircletView()) { [unowned self] in
            print("Start requesting data from the remote server...")
            
            // Network request simulation
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                self.datasource = dataList
                self.tableView.reloadData()
                self.loadingFinish()
            }
            
        }
        
        tableView.cr.tintColor = UIColor.brown

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start pull refresh manually.
        tableView.cr.startRefresh()
    }

    
    func loadingFinish() {
        print("Finish load data from the remote server!\n==========")
        tableView.cr.stopRefresh()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        cell.textLabel?.text = datasource?[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    deinit {
        tableView.cr.remove()
    }
}


