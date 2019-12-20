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
#endif
#if os(iOS)
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class ImageHolder:ObservableObject{
    @Published var image:UIImage = UIImage.init()
    func downloadImage(with url:String) {
        URLSession.default.useCacheElseLoadURLData(with: url.urlValue()) { (data, res, err) in
            if let data = data, let img = UIImage.init(data: data){
                self.image = img
            }
        }
    }
}
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct WTImage:SwiftUI.View{
    var imageHolder:ImageHolder = ImageHolder()
    mutating func downloadImage(with url:String) {
        imageHolder.downloadImage(with: url)
    }
    public var body: some View {
        Image.init(uiImage: imageHolder.image)
    }
}

#endif
