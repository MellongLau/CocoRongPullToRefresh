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
    var loadingViewsType: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CRPullToRefresh"
        
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        var loadingView: LoadingView
        
        guard let loadingViewsType = loadingViewsType else {
            return
        }
        switch loadingViewsType {
        case "Circlet":
            loadingView = LoadingCircletView()
        case "Rectangle":
            loadingView = LoadingRectangleView()
        default:
            loadingView = LoadingCircleView()
        }
        
        // Enable pull to refresh.
        tableView.cr.enablePullRefresh(loadingView: loadingView) { [weak self] in
            print("Start requesting data from the remote server...")
            guard let self else { return }
            var dataList: [String] = []
            let max = arc4random() % 10 + 20
            for i in 1...max {
                dataList.append("Title for \(i)")
            }
            // Network request simulation
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.datasource = dataList
                self.tableView.reloadData()
                self.loadingFinish()
            }
            
        }
        
        tableView.cr.tintColor = UIColor.white

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
        return datasource?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    deinit {
        tableView.cr.remove()
        debugPrint("ViewController deinit")
    }
}


