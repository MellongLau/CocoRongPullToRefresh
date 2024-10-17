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

public protocol LoadingView {
    func setup()
    func setProgress(progress: CGFloat)
    func reset()
    func startLoadingAnimation()
    func stopLoadingAnimation()
}

public final class CocoRongPullToRefresh<Base> {
    fileprivate let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol CocoRongPullToRefreshCompatible {
    associatedtype CompatibleType
    var cr: CompatibleType { get }
}

public extension CocoRongPullToRefreshCompatible {
    var cr: CocoRongPullToRefresh<Self> {
        get { return CocoRongPullToRefresh(self) }
    }
}

// MARK: - Core Implementation
private var kIsPullRefreshable: Void?
private var kPullRefreshView: Void?
private var kCompletion: Void?
private var kTintColor: Void?

struct CRCongfiguration {
    public static var radius: CGFloat = 10.0
    public static var maxHeight: CGFloat = 50.0
}

/// Const string
struct CRKVOKey {
    public static var contentOffset: String = "contentOffset"
    public static var panGestureRecognizerState: String = "panGestureRecognizer.state"
}

extension CocoRongPullToRefresh where Base: UITableView {
    
    private var pullRefreshView: PullToRefreshView? {
        get {
            return objc_getAssociatedObject(base, &kPullRefreshView) as? PullToRefreshView
        }
        
        set {
            objc_setAssociatedObject(base, &kPullRefreshView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var tintColor: UIColor? {
        get {
            return objc_getAssociatedObject(base, &kTintColor) as? UIColor
        }
        
        set {
            objc_setAssociatedObject(base, &kTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            pullRefreshView?.tintColor = newValue
            pullRefreshView?.updateTintColor()
        }
        
    }
    
    /// Manual start refresh
    public func startRefresh() {
        pullRefreshView?.startRefresh()
    }
    
    /// Finish refresh
    public func stopRefresh() {
        guard let pullRefreshView = pullRefreshView else {
            return
        }
        pullRefreshView.stopLoading()
    }
    
    public func remove() {
        removeAllObservers()
    }
    
    private func removeAllObservers() {
        guard let pullRefreshView = pullRefreshView else {
            return
        }
        base.removeObserver(pullRefreshView, forKeyPath: CRKVOKey.contentOffset)
        base.removeObserver(pullRefreshView, forKeyPath: CRKVOKey.panGestureRecognizerState)
    }
    
    /// Enable pull to refresh feature.
    ///
    /// - Parameter didStartLoadClosure: the closure to be executed when pull refresh did start loading.
    public func enablePullRefresh(didStartLoadClosure: @escaping () -> Void) {
        enablePullRefresh(loadingView: LoadingCircleView(), didStartLoadClosure: didStartLoadClosure)
    }
    
    public func enablePullRefresh(loadingView: LoadingView, didStartLoadClosure: @escaping () -> Void) {
        isPullRefreshable = true
        
        let pullRefreshView = PullToRefreshView(loadingView: loadingView)
        pullRefreshView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0)
        self.base.insertSubview(pullRefreshView, at: 0)
        pullRefreshView.setup()
        pullRefreshView.startLoadClosure = didStartLoadClosure
        self.pullRefreshView = pullRefreshView
    }
    
    private var isPullRefreshable: Bool {
        get {
            return objc_getAssociatedObject(base, &kIsPullRefreshable) as? Bool ?? false
        }
        
        set {
            objc_setAssociatedObject(base, &kIsPullRefreshable, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
}

extension UIScrollView: CocoRongPullToRefreshCompatible { }

// MARK: Animation and logic
public class PullToRefreshView: UIView {
    var startLoadClosure: (() -> Void)?
    var isStartLoading: Bool = false
    var isDragging: Bool = false
    var shouldObserve: Bool = true
    var isManualRefresh: Bool = false
    var originalContentOffsetY: CGFloat?
    var originalContentInsetTop: CGFloat?
    var isFinishLoading: Bool = false
    
    var loadingCircleView: LoadingView
    
    init(loadingView: LoadingView) {
        self.loadingCircleView = loadingView
        super.init(frame: CGRect.zero)
    }
    
    private func addObservers() {
        scrollView?.addObserver(self, forKeyPath: CRKVOKey.contentOffset, options: .new, context: nil)
        scrollView?.addObserver(self, forKeyPath: CRKVOKey.panGestureRecognizerState, options: .new, context: nil)
    }
    
    fileprivate func setup() {
        guard let view = loadingCircleView as? UIView else {
            fatalError("Loading view is not a subclass of UIView")
            
        }
        addSubview(view)
        addObservers()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        updateTintColor()
        loadingCircleView.setup()
    }
    
    fileprivate func updateTintColor() {
        backgroundColor = tintColor
    }
    
    fileprivate var scrollView: UIScrollView? {
        get {
            return superview as? UIScrollView
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Manual start refresh.
    public func startRefresh() {
        if isManualRefresh {
            debugPrint("Error: pull refresh already running!")
            return
        }
        
        isManualRefresh = true
        
        scrollView?.setContentOffset(
            CGPoint(x: 0, y: scrollView?.contentOffset.y ?? 0 - CRCongfiguration.maxHeight),
            animated: true
        )
        disableAnimation {
            loadingCircleView.setProgress(progress: 1.0)
        }
        
        loadingCircleView.startLoadingAnimation()
        scrollView?.isScrollEnabled = false
        startLoadClosure?()
    }
    
    public func stopLoading() {
        shouldObserve = true
        isStartLoading = false
        loadCompletion()
        isManualRefresh = false
    }

    public func disableAnimation(closure: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        closure()
        CATransaction.commit()
    }
    
    private func handleContentOffset(change: [NSKeyValueChangeKey : Any]?) {
        if let contentOffset = change?[.newKey] {
            let y = (contentOffset as AnyObject).cgPointValue.y
            // End dragging
            if isStartLoading {
                
                // Use shouldObserve flag to call startLoadClosure() once, call the network request first.
                if let startLoadClosure = startLoadClosure, shouldObserve {
                    startLoadClosure()
                }
                
                shouldObserve = false
                
                if let _ = originalContentOffsetY {
                    let progress = getCurrentProgress()
                    let isReachMaxHeightOffsetY = progress >= 1.0
                    if let scrollView, !isDragging &&  isReachMaxHeightOffsetY && scrollView.isScrollEnabled {
                        scrollView.contentInset.top = CRCongfiguration.maxHeight // Using contentInset to avoid the contentOffset change.
                        
                        // Disable scrollable of the scroll view when contentOffset reach the pullRefreshView max height.
                        scrollView.isScrollEnabled = false
                        loadingCircleView.startLoadingAnimation()
                    }
                }
            }
            
            // Keep updating the progress status when is dragging.
            if isDragging {
                
                let progress = getCurrentProgress()
                
                disableAnimation {
                    loadingCircleView.reset()
                    loadingCircleView.setProgress(progress: progress)
                }
            } else if let top = originalContentOffsetY, y >= top - CRCongfiguration.maxHeight {
                isFinishLoading = true
                isStartLoading = false
            }
            
            // Restore back to the original state when refresh is finish
            if isFinishLoading {
                if let top = originalContentOffsetY, y == top {
                    scrollView?.contentInset.top = -top
                    scrollView?.isScrollEnabled = true
                }
            }
            
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?)
    {
        updateLayout()
        if isManualRefresh {
            return
        }
        
        if keyPath == CRKVOKey.contentOffset {
            if originalContentOffsetY == nil {
                if let contentOffset = change?[.newKey], let it = contentOffset as? CGPoint {
                    originalContentOffsetY = it.y
                }
            }
            if originalContentInsetTop == nil {
                originalContentInsetTop = scrollView?.contentInset.top
            }
            handleContentOffset(change: change)
            
        } else if keyPath == CRKVOKey.panGestureRecognizerState, let scrollView {
            let newState = scrollView.panGestureRecognizer.state
            if newState == .began {
                isDragging = true
                isFinishLoading = false
                isStartLoading = false
            }
            
            if (newState == .ended || newState == .cancelled) && isDragging {
                
                let progress = getCurrentProgress()
                
                // Ignore dragging up case.
                if scrollView.contentOffset.y > -scrollView.contentInset.top {
                    scrollView.contentInset.top = 0
                    return
                }
                
                if progress >= 1.0 && scrollView.contentOffset.y != 0 {
                    isStartLoading = true
                    isDragging = false
                    scrollView.contentOffset.y = scrollView.contentOffset.y
                    
                } else {
                    isDragging = false
                    isStartLoading = false
                    isFinishLoading = true
                    disableAnimation {
                        loadingCircleView.reset()
                    }
                    scrollView.setContentOffset(CGPoint(x: 0, y: originalContentOffsetY ?? 0), animated: true)
                    
                }
                scrollView.contentInset.top = CRCongfiguration.maxHeight
            }
            
        }
    }
    
    private func getCurrentProgress() -> CGFloat {
        let factor: CGFloat = 1.5
        return frame.size.height / (CRCongfiguration.maxHeight * factor)
    }
    
    private func loadCompletion() {
        loadingCircleView.stopLoadingAnimation()
        disableAnimation {
            loadingCircleView.reset()
        }
        
        updateLayout()
        
        isFinishLoading = true
        scrollView?.setContentOffset(CGPoint(x: 0, y: (originalContentOffsetY ?? 0)), animated: true)
    }
    
    /// Update PullToRefreshView layout.
    private func updateLayout() {
        let height = -(scrollView?.contentOffset.y ?? 0) + (originalContentOffsetY ?? 0.0)
        frame.size.height = height < 0 ? 0: height
        frame.origin.y = -frame.size.height
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
}

