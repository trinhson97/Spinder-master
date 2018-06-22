//
//  ViewController.swift
//  Spinder
//
//  Created by NgocAnh on 4/26/18.
//  Copyright © 2018 NgocAnh. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var downloadTaskItem: DispatchWorkItem?
    
    let urlImage = "http://thuthuatphanmem.vn/uploads/2017/11/05/hinh-nen-4k-dep-9_124944.jpg"
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBAction func actionImage(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.isEnabled = false
            activityIndicator.isHidden = false
            activityIndicator.transform = CGAffineTransform(scaleX: 5, y: 5)
            activityIndicator.startAnimating()
            downLoadImage(from: urlImage) {[unowned self] image in
                // stop spinner
                sender.isEnabled = true
                self.activityIndicator.stopAnimating()
                self.imageView.image = image
            }
        } else {
            imageView.image = nil
                 // xoá bộ nhớ khi tràn dữ liệu
            CacheImage.images.removeObject(forKey: urlImage as NSString)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // nếu bộ nhớ đầy thì dừng việc down load lại
        downloadTaskItem?.cancel()
    }
}


// MARK: - Download and cache image

extension ViewController {
    func downLoadImage(from urlString: String, complete: @escaping (UIImage?) -> Void ) {
        if let url = URL(string: urlString) {
            var image: UIImage?
            
            downloadTaskItem = DispatchWorkItem(block: {
                // Kiểm tra xem theo url nay đã được cache hay chưa
                if let cache = CacheImage.images.object(forKey: url.absoluteString as NSString) {
                    // Nếu có thì gán cho image
                    image = cache as? UIImage
                } else {
                    // Nếu chưa thì bắt đầu download về
                    if let data = try? Data(contentsOf: url) {
                        image = UIImage(data: data)
                        if image != nil {
                            // nếu dữ liệu down về là image thì tiến hành cache theo key là url
                            CacheImage.images.setObject(image!, forKey: url.absoluteString as NSString, cost: data.count)
                        }
                    }
                }
            })
            DispatchQueue.global().async {
                self.downloadTaskItem?.perform()
                DispatchQueue.main.async {
                    complete(image)
                }
            }
        }
    }
}
