//
//  Extensions.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 10/30/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

let                 imageCache = NSCache<NSString, UIImage>()



extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}

extension Data {
    
    // struct
    init<T>(from value: T) {
        var value = value
        self.init(bytes: &value, count: MemoryLayout<T>.size)
    }
    
    // extract Struct
    func extract<T>(from: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }   // FAILS HERE: EXC_BAD_ACCESS
    }
}

extension           UIImageView
{

    
    func            getImageUsingCacheWithUrlString(urlString: String, completion: @escaping (UIImage) -> ())
    {
        self.image = nil
        guard urlString != "" else { return }
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        let url = URL(string: urlString)
        guard let gurl = url else { return }
        apiManager.loadImageUsingCacheWithUrl(from: gurl, completion: { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                if let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: String(describing: url!) as NSString)
                    completion(image)
                }
            }
        })
    }
    
    func            loadImageUsingCacheWithUrlString(urlString: String)
    {
        getImageUsingCacheWithUrlString(urlString: urlString) { (image) in
            self.image = image
        }
    }
}
