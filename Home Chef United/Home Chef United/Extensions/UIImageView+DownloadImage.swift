//
//  UIImageView+DownloadImage.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/17/23.
//

import UIKit

// Extension to the UIImageView class utilizing URLSession to be able to download images to UIImageView
extension UIImageView {
    func downloadImage(url: URL) -> URLSessionDownloadTask {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) {
            [weak self] url, _, error in
            if error == nil, let url = url,
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    if let weakSelf = self {
                        weakSelf.image = image
                    }
                }
            }
        }
        downloadTask.resume()
        return downloadTask
    }
}
