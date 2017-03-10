# CocoRongPullToRefresh

*Like this project?*  `Star us above!`

Pull to refresh is one of most frequently feature to be used in the all of apps, this component provides a easiest way to add pull to refresh feature for your table view.

![Screenshot.gif]() (TBD)

### Languages

[中文]() (TBD)

### Usage

* There is a sample to demonstrate how to use this component easily.

```swift
tableView.cr.enablePullRefresh {
	// Call data api from remote server.
        get("http://xxx.com/api/productlist") { dataList in
		// Update table view datasource
		self.tableView.datasource = dataList
		self.tableView.reloadData()
		// Finish refresh	
		self.tableView.cr.stopRefresh()
	}	
}
```

As you saw above, we can simply enable this component for our table view, we may need to configure the tint color of the pull refresh view's background by:

```swift
tableView.cr.tintColor = UIColor.brown
```

Finally, we should call the `remove()` method in the view controller's `deinit`

```swift
deinit {
        tableView.cr.remove()
}
```
### Usage Example (TBD)

Check out the Sample project in the example directory to see more.

### Installation (TBD)

#### CocoaPods (TBD)

#### Manual Install (TBD)

### Requirements

Requires Swift 3.0 and iOS 8.0 and ARC.

### Using CocoRongPullToRefresh?

If you're using CocoRongPullToRefresh in one of your own projects, let me know! I'll add a link to your profile/website/app right here on the front page. Feel free to email me at the address shown below.

### Contributing
Forks, patches and other feedback are welcome.

### Creator
I'm Mellong, you can contact me by E-Mail: <121382647@qq.com>

Website: [http://www.devlong.com](http://www.devlong.com)

### License

MIT License