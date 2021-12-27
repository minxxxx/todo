//
//  APIManager.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 10/25/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit
import Alamofire


public func makeAlert(_ msg : String) {
    // to check
    if let cont = UIApplication.shared.keyWindow?.rootViewController?.childViewControllers.last {
        let al = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        al.addAction(UIAlertAction(title: "Ok", style: .default, handler: { me in
            al.dismiss(animated: true, completion: nil)
        }))
        cont.present(al, animated: true, completion: nil)
    }
    
}

class APIManager: NSObject, URLSessionDelegate {
    
    let ip: String = "www.come-over.com"
    let token: String? = nil
    let delegate: Alamofire.SessionDelegate = Manager.delegate
    var url: String {
        return  "https://\(self.ip):4242/"
    }
    
    private static var Manager: Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "https://www.come-over.com:4242/event": .disableEvaluation,
            "https://www.come-over.com:4242/": .disableEvaluation,
        ]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return manager
    }()
    
    let jsonEncoder: JSONEncoder = JSONEncoder()
    
    override init() {
        delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = APIManager.Manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            return (disposition, credential)
        }
    }

    func getAlbumTracks(_ album: Album, completion: @escaping (Album) -> ()) {
        let tracksUrl = self.url + "album/\(album.id)"
        var request = URLRequest(url: URL(string: tracksUrl)!)
        request.httpMethod = "GET"
        request.setValue("Bearer " + userManager.currentUser!.token!, forHTTPHeaderField: "Authorization")
        searchAll(Album.self, request: request) { (tracksData) in
            var album = album
            album = tracksData
            completion(album)
        }
    }
    
    func searchPlaylists(_ search: String, completion: @escaping ([SPlaylist]) -> ()) {
        let w = search.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let playlistsUrl = self.url + "search/playlist?q=\(w)"
        var playlistsRequest = URLRequest(url: URL(string: playlistsUrl)!)
        playlistsRequest.httpMethod = "GET"
        playlistsRequest.setValue("Bearer " + userManager.currentUser!.token!, forHTTPHeaderField: "Authorization")
        self.searchAll([SPlaylist].self, request: playlistsRequest, completion: { (res) in
            completion(res)
        })
    }
    
    func searchAlbums(_ search: String, completion: @escaping ([Album]) -> ()) {
        let w = search.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let albumsUrl = self.url + "search/album?q=\(w)"
        var albumsRequest = URLRequest(url: URL(string: albumsUrl)!)
        albumsRequest.httpMethod = "GET"
        albumsRequest.setValue("Bearer " + userManager.currentUser!.token!, forHTTPHeaderField: "Authorization")
        self.searchAll([Album].self, request: albumsRequest, completion: { (albums) in
            completion(albums)
        })
    }
    
    func searchTracks(_ search: String, completion: @escaping ([Track]) -> ()) {
        let w = search.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let tracksUrl = self.url + "search/track?q=\(w)"
        var tracksRequest = URLRequest(url: URL(string: tracksUrl)!)
        tracksRequest.httpMethod = "GET"
        tracksRequest.setValue("Bearer " + userManager.currentUser!.token!, forHTTPHeaderField: "Authorization")
        self.searchAll([Track].self, request: tracksRequest, completion: { (tracks) in
            completion(tracks)
        })
    }
    
    func searchArtists(_ search: String, completion: @escaping ([Artist]) -> ()) {
        let w = search.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let artistsUrl = self.url + "search/artist?q=\(w)"
        var artistsRequest = URLRequest(url: URL(string: artistsUrl)!)
        artistsRequest.httpMethod = "GET"
        artistsRequest.setValue("Bearer " + userManager.currentUser!.token!, forHTTPHeaderField: "Authorization")
        self.searchAll([Artist].self, request: artistsRequest, completion: { (artists) in
            completion(artists)
        })
    }

    func updateUser(_ data : Data?, completion : @escaping (([String:Any]?) -> ())) {
        let url = self.url + "user/me"
        var req = URLRequest(url: URL(string: url)!)
        req.httpMethod = "PUT"
        req.setValue("Bearer " + userManager.currentUser!.token!, forHTTPHeaderField: "Authorization")
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.httpBody = data
        URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: req){ (data, res, err) in
            if err != nil {
                makeAlert("No response from the server, try again..")
            }
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data!, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    if let error = responseJSON["error"] as? String {
                        makeAlert(error)
                        completion(nil)
                    }
                    completion(responseJSON)
                }
            }
            catch {
                makeAlert("Error")
            }
        }.resume()
    }

    func giveDeezerToken(_ user : MyUser) {
        let url = self.url + "user/login/deezer?deezerToken=\(user.deezer_token!)"
        var req = URLRequest(url : URL(string : url)!)
        req.httpMethod = "PUT"
        req.setValue("Bearer " + user.token!, forHTTPHeaderField: "Authorization")
        URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: req) { (data, response, err) in
            if err != nil {
                makeAlert("No response from the server, try again..")
            }
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data!, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    if let error = responseJSON["error"] as? String {
                        makeAlert(error)
                    }
                }
            }
            catch {
                makeAlert("Error")
            }
        }.resume()
    }

    func deleteUserById() {
        let url = self.url + "user/me"
        var req = URLRequest(url : URL(string: url)!)
        req.httpMethod = "DELETE"
        req.addValue("Bearer \(userManager.currentUser!.token!)", forHTTPHeaderField: "Authorization")
        URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: req) { (data, response, err) in
            if err != nil {
                makeAlert("No response from the server, try again..")
            }
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data!, options: [])
                if let responseJSON = responseJSON as? [String: AnyObject] {
                    return
                }
            }
            catch {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data!, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        if let error = responseJSON["error"] as? String {
                            makeAlert(error)
                        }
                        return
                    }
                }
                catch {
                    return
                }
            }
            }.resume()
    }
    
    func login(_ forg: String, _ token : String, completion: @escaping ( ([String: AnyObject]) -> ())) {
        let loginUrl = self.url + "user/login/" + forg + "?access_token=" + token
        var loginRequest = URLRequest(url : URL(string : loginUrl)!)
        loginRequest.httpMethod = "GET"
        URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: loginRequest) { (data, response, err) in
            if err != nil {
                makeAlert("No response from the server, try again..")
            }
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data!, options: [])
                if let responseJSON = responseJSON as? [String: AnyObject] {
                    completion(responseJSON)
                }
            }
            catch {
                makeAlert("Error")
            }
        }.resume()
    }

    func likeTracksEvent(_ eventID: String, _ body : TrackLike ,completion: @escaping ((Bool) -> ())) {
        
        let likeTracksUrl = self.url + "track/\(eventID)/like"
        var req = URLRequest(url : URL(string: likeTracksUrl)!)
        req.httpMethod = "PUT"
        do {
            req.httpBody = try jsonEncoder.encode(body)
            req.addValue("Bearer \(userManager.currentUser!.token!)", forHTTPHeaderField: "Authorization")
            req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: req) { (data, response, err) in
                if err != nil {
                    makeAlert("No response from the server, try again..")
                }
                if let d = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: d, options: [])
                        if let responseJSON = responseJSON as? [String: Any] {
                            if let error = responseJSON["error"] as? String {
                                makeAlert(error)
                                completion(false)
                            } else {
                                completion(true)
                            }
                        }
                    } catch {
                        makeAlert("Error")
                        completion(false)
                    }
                    
                }
            }.resume()
        } catch {
            makeAlert("Error")
        }
    }
    
    func getPlaylists(completion: @escaping (DataPlaylist) -> ()) {
        let playlistsUrl = self.url + "playlist"
        var playlistsRequest = URLRequest(url: URL(string: playlistsUrl)!)
        playlistsRequest.httpMethod = "GET"
        playlistsRequest.addValue("Bearer \(userManager.currentUser!.token!)", forHTTPHeaderField: "Authorization")
        self.searchAll(DataPlaylist.self, request: playlistsRequest, completion: { (playlists) in
            completion(playlists)
        })
    }
    
    func getDeezerPlaylistById(_ id : Int, completion : @escaping((Playlist) -> ())) {
        let getPlaylistUrl = self.url + "playlist/\(id)"
        var playlistDeezerRequest = URLRequest(url : URL(string: getPlaylistUrl)!)
        playlistDeezerRequest.httpMethod = "GET"
        playlistDeezerRequest.addValue("Bearer \(userManager.currentUser!.token!)", forHTTPHeaderField: "Authorization")
        self.searchAll(Playlist.self, request: playlistDeezerRequest, completion: { (playlists) in
            completion(playlists)
        })
    }
    
    func createPlaylist(_ string: String, _ target: PlaylistsController?) {
        let playlistsUrl = self.url + "playlist"
        var createPlaylistRequest = URLRequest(url: URL(string: playlistsUrl)!)
        createPlaylistRequest.httpMethod = "POST"
        createPlaylistRequest.addValue("Bearer \(userManager.currentUser!.token!)", forHTTPHeaderField: "Authorization")
        createPlaylistRequest.httpBody = string.data(using: .utf8)
        URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: createPlaylistRequest) { (data, response, error) in
            target?.reloadPlaylists()
        }.resume()
    }
    
    func updatePlaylist(_ playlist: Playlist, completion : @escaping((String) -> ())) {
        guard let pId = playlist._id else { return }
        let playlistURL = self.url + "playlist/\(pId)"
        do {
            let data = try jsonEncoder.encode(playlist)
            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            let ulr =  URL(string: playlistURL)
            var req = URLRequest(url: ulr! as URL)
            req.httpMethod = "PUT"
            req.setValue("Bearer \(userManager.currentUser!.token!)", forHTTPHeaderField: "Authorization")
            req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            req.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
            request(req)
            URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: req) { (data, response, err) in
                SocketIOManager.sharedInstance.updateTracks(roomID: eventID, tracks: playlist.tracks!.data)
                completion("ok")
            }.resume()
        } catch {
            makeAlert("Error")
        }
    }
    
    func deletePlaylist(_ id: String, _ target: PlaylistDetailController?) {
        let playlistsUrl = self.url + "playlist/\(id)"
        var createPlaylistRequest = URLRequest(url: URL(string: playlistsUrl)!)
        createPlaylistRequest.httpMethod = "DELETE"
        createPlaylistRequest.addValue("Bearer \(userManager.currentUser!.token!)", forHTTPHeaderField: "Authorization")
        URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: createPlaylistRequest) { (data, response, error) in
            target?.navigationController?.popViewController(animated: true)
        }.resume()
    }
    
    func addTrackToPlaylist(_ playListId: String, _ track: Track) {
        let postEventUrl = self.url + "playlist/\(playListId)/track"
        let parameter : Parameters = ["id" : "\(track.id)"]
        let headers : HTTPHeaders = ["Authorization": "Bearer \(userManager.currentUser!.token!)"]
        APIManager.Manager.request(postEventUrl, method: .put, parameters: parameter, encoding: URLEncoding.default, headers: headers)
    }
    
    func addTrackToLibrary(_ trackId: String) {
        let addTrackUrl = self.url + "track/"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(userManager.currentUser!.token!)"]
        let parameter : Parameters = ["id" : trackId]
        APIManager.Manager.request(addTrackUrl, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headers).response { (data) in
            self.getLibraryTracks { (tracks) in
                lovedTracksId.removeAll()
                tracks.forEach({ (track) in
                    lovedTracksId.append(track.id)
                })
            }
        }
    }
    
    func removeTrackFromLibrary(_ trackId: String) {
        let addTrackUrl = self.url + "track/\(trackId)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(userManager.currentUser!.token!)"]
        let parameter : Parameters = ["id":trackId]
        APIManager.Manager.request(addTrackUrl, method: .delete, parameters: parameter, encoding: URLEncoding.default, headers: headers).response { (data) in
            self.getLibraryTracks { (tracks) in
                lovedTracksId.removeAll()
                tracks.forEach({ (track) in
                    lovedTracksId.append(track.id)
                })
            }
        }
    }
    
    func getLibraryTracks(completion: @escaping ([Track]) -> ()) {
        let trackUrl = self.url + "track"
        var trackRequest = URLRequest(url: URL(string: trackUrl)!)
        trackRequest.httpMethod = "GET"
        trackRequest.addValue("Bearer \(userManager.currentUser!.token!)", forHTTPHeaderField: "Authorization")
        self.searchAll([Track].self, request: trackRequest, completion: { (tracks) in
            completion(tracks)
        })
    }
    
    func deleteTrackFromPlaylist(_ playListId: String, _ track: Track, target: PlaylistDetailController?) {
        let playlistsUrl = self.url + "playlist/\(playListId)/\(track.id)"
        var createPlaylistRequest = URLRequest(url: URL(string: playlistsUrl)!)
        createPlaylistRequest.httpMethod = "DELETE"
        createPlaylistRequest.addValue("Bearer \(userManager.currentUser!.token!)", forHTTPHeaderField: "Authorization")
        URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: createPlaylistRequest) { (data, response, error) in
            target?.tableView.reloadData()
        }.resume()
    }
    
    func registerUser(_ user : Data?) {
        let registerUrl = self.url + "user/"
        var registerRequest = URLRequest(url: URL(string: registerUrl)!)
        registerRequest.httpMethod = "POST"
        registerRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        registerRequest.httpBody = user
        
        URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: registerRequest) { (data, response, err) in
            if err != nil {
                print("error while requesting")
            }
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data!, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    if let error = responseJSON["error"] as? String {
                        makeAlert(error)
                    }
                }
            }
            catch {
                return
            }
        }.resume()
    }

    func loginUser(_ json : Data?, completion : @escaping (DataUser?) -> ()) {
        let loginUrl = self.url + "user/login"
        var loginRequest = URLRequest(url: URL(string: loginUrl)!)
        loginRequest.httpMethod = "POST"
        loginRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        loginRequest.httpBody = json
        URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: loginRequest) { (data, response, err) in
            if err != nil {
                makeAlert("No response from the server, try again..")
                completion(nil)
             }
            if let d = data {
                do {
                    let dic = try JSONDecoder().decode(DataUser.self, from: d)
                    completion(dic)
                }
                catch {
                    makeAlert("Invalid credentials")
                }
            }
            }.resume()
    }
    
    func getMe(_ token : String, completion : @escaping ((User) -> ())) {
        let meUrl = self.url + "user/me"
        var request = URLRequest(url: URL(string: meUrl)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        searchAll(User.self, request: request) { (me) in
            completion(me)
        }
    }
    
    func putEvent(_ event : Event, completion : @escaping((Bool) -> ())) {
        let url = self.url + "event/\(event._id!)"
        do {
            let data = try jsonEncoder.encode(event)
            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            var req = URLRequest(url : URL(string: url)!)
            req.httpMethod = "PUT"
            req.setValue("Bearer \(userManager.currentUser!.token!)", forHTTPHeaderField: "Authorization")
            req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            req.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
            URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: req, completionHandler: { (data, resp, err) in
                if err != nil {
                    makeAlert("No response from the server, try again..")
                    completion(false)
                }
                if data != nil {
                    completion(true)
                }
            }).resume()
        } catch {
            makeAlert("Error")
        }
    }
    
    func getEventById(_ id : String, completion: @escaping ((Event) -> ())) {
        let url = self.url + "event/\(id)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(userManager.currentUser!.token!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        searchAll(Event.self, request: request, completion: { res in
            completion(res)
        })
    }
    
    func getEvents(completion : @escaping ((DataEvent) -> ())){
        let eventsUrl = self.url + "event"
        var request = URLRequest(url: URL(string: eventsUrl)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(userManager.currentUser!.token!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        self.searchAll(DataEvent.self, request: request) { (res) in
            completion(res)
        }
    }
    
    func getImgEvent(_ path : String, completion : @escaping (UIImage?) -> ()) {
        let url = self.url + "eventPicture/" + path
        let imageView = UIImageView()
        imageView.getImageUsingCacheWithUrlString(urlString: url) { (image) in
            completion(image)
        }
    }
    
    func getAllUsers(_ search : String, completion : @escaping (([User]) -> ())) {
        let w = search.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let allUserUrl = self.url + "user?criteria=\(w)"
        var request = URLRequest(url: URL(string: allUserUrl)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(userManager.currentUser!.token!)", forHTTPHeaderField: "Authorization")
        searchAll([User].self, request: request) { (me) in
            completion(me)
        }
    }
    
    func deleteEventById(_ id: String, completion: @escaping (() -> ())) {
        let url = self.url + "event/\(id)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(userManager.currentUser!.token!)", forHTTPHeaderField: "Authorization")
        URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: request, completionHandler: { (data, resp, err) in
            if err != nil {
                makeAlert("No response from the server, try again..")
                return
            }
            completion()
        }).resume()
        
    }
    
    func postEvent(_ token : String, event : Event, img : UIImage, onCompletion: @escaping ((Bool) -> Void)) {
        do {
            let postEventUrl = self.url + "event/"
            let dataBody = try jsonEncoder.encode(event)
            let dataImg = UIImageJPEGRepresentation(img, 0.1)
            let headers : HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Content-type": "multipart/form-data"
            ]
            APIManager.Manager.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(dataBody, withName: "body")
                if let data = dataImg {
                    multipartFormData.append(data, withName: "file", fileName: "image.jpeg", mimeType: "image/jpeg")
                }
            }, usingThreshold: UInt64.init(), to: postEventUrl, method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if response.error != nil {
                            makeAlert("Error from the server, try again")
                            onCompletion(false)
                            return
                        }
                        onCompletion(true)
                    }
                case .failure(_):
                    makeAlert("Error during downloading file")
                    onCompletion(false)
                }
            }
        } catch {
            makeAlert("Error")
        }
    }
    
    func loadImageUsingCacheWithUrl(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ())
    {
        URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: url, completionHandler: completion).resume()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    func searchAll<T: Decodable>(_ myType: T.Type, request: URLRequest, completion: @escaping (T) -> ())
    {
        URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: request) { (data, response, err) in
            if err != nil {
                makeAlert("No response from the server, try again..")
            }
            if let d = data {
                do {
                    let dic = try JSONDecoder().decode(myType.self, from: d)
                    completion(dic)

                } catch {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: data!, options: [])
                        if let responseJSON = responseJSON as? [String: Any] {
                            if let error = responseJSON["error"] as? String {
                                makeAlert(error)
                            }
                        }
                        
                    }
                    catch {
                        makeAlert("Can't connect to the server")
                    }
                }
            }
        }.resume()
    }
}
