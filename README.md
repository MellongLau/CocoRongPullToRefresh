Donate
===========

* [Donate via paypal](https://paypal.me/mellonglau)

# CocoRongPullToRefresh

*Like this project?*  `Star us above!`

Pull to refresh is one of most frequently feature to be used in the all of apps, this component provides a easiest way to add pull to refresh feature for your table view.

![Screenshot](./screenshot/screenshot.gif) 

### Languages

[中文](./README_CN.md)

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
### Usage Example

Check out the Sample project in the example directory to see more.

### Installation
There are two approach to add `CocoRongPullToRefresh` to your exist project.

#### CocoaPods

[CocoaPods](http://www.cocoapods.org) is the recommended way to add CocoRongPullToRefresh to your project.

1. Add additional entry to your Podfile.

  ```ruby
  pod "CocoRongPullToRefresh", "~> 1.0"
  ```

2. Install  Pod(s) running `pod install` command.
3. Include CocoRongPullToRefresh using `import CocoRongPullToRefresh `.

#### Manual Install

Run below command in Terminal.app:

	$ git clone https://github.com/MellongLau/CocoRongPullToRefresh.git

or download directly, then copy `CocoRongPullToRefresh` folder and add reference to your project.

### Requirements

Requires Swift 3.0 and iOS 8.0 and ARC.

### Using CocoRongPullToRefresh?

If you're using CocoRongPullToRefresh in one of your own projects, let me know! I'll add a link to your profile/website/app right here on the front page. Feel free to email me at the address shown below.

### Contributing
Forks, patches and other feedback are welcome.

### Creator
I'm Mellong, you can contact me by E-Mail: <tendencystudio@gmail.com>

Website: [http://www.devlong.com](http://www.devlong.com)

## More
Learn more? Follow my `WeChat` public account `mellong`:

![WeChat QRcode](http://www.devlong.com/blogImages/qrcode_for_mellong.jpg)

### License

MIT License
