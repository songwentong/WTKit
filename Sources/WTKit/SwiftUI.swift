//
//  SwiftUI.swift
//  宋文通
//
//  Created by 宋文通 on 2019/8/7.
//  Copyright © 2019 宋文通. All rights reserved.
//

import Foundation
#if canImport(SwiftUI) && canImport(Combine)
import SwiftUI
import Combine
#if os(iOS)
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class ImageLoader:ObservableObject{
    public var didChange = PassthroughSubject<ImageLoader,Never>()
    @Published var image:UIImage = UIImage.init()
    deinit {
        loadingTask?.cancel()
    }
    var loadingTask:URLSessionDataTask? = nil
    func downloadImage(with url:String) {
        loadingTask?.cancel()
        URLSession.default.useCacheElseLoadUrlData(with: url.urlValue) { data in
            
        } failed: { error in
            
        }

        self.loadingTask = URLSession.default.useCacheElseLoadURLData(with: url.urlValue) { (data, res, err) in
            if let data = data, let img = data.uiImage{
                self.image = img
            }
        }
    }
}
#endif
#endif
