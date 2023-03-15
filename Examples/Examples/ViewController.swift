//
//  ViewController.swift
//  Examples
//
//  Created by yudonlee on 2023/02/18.
//

import UIKit
import SwiftNetzy

// MARK: - Welcome
struct HttpBinResponseModel: Codable {
    let headers: Headers?
    let url: String
    let origin:  String
}

struct HttpReqResponseModel: Codable {
    let success: String
}

// MARK: - Headers
struct Headers: Codable {
    let accept, acceptEncoding: String
    let host: String
    let userAgent, xAmznTraceID: String

    enum CodingKeys: String, CodingKey {
        case accept = "Accept"
        case acceptEncoding = "Accept-Encoding"
        case host = "Host"
        case userAgent = "User-Agent"
        case xAmznTraceID = "X-Amzn-Trace-Id"
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var requestDataButotn: UIButton!
    @IBOutlet weak var getLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var putLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    var indicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewProperty()
    }
    
    private func setupViewProperty() {
        requestDataButotn.setTitle("Data is now Loading", for: .disabled)
        requestDataButotn.setTitleColor(UIColor.gray, for: .disabled)
        
    }
    
    private func isNowLoading() {
        indicatorView.color = .black
        indicatorView.style = .large
        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        indicatorView.startAnimating()
    }
    
    private func isNowFinishing() {
        indicatorView.stopAnimating()
        indicatorView.removeFromSuperview()
    }
    
    @IBAction private func dataLoad(_ sender: Any) {
        requestDataButotn.isEnabled = false
        isNowLoading()
        
        Task {
            do {
                async let getResponse = SwiftNetzy.request(HttpBinResponseModel.self, "https://httpbin.org/get", method: .get)
                
                async let postResponse = SwiftNetzy.request(HttpBinResponseModel.self, "https://httpbin.org/post", method: .post)
                
                async let putResponse = SwiftNetzy.request(HttpBinResponseModel.self, "https://httpbin.org/put", method: .put)
                
                async let deleteResponse = SwiftNetzy.request(HttpBinResponseModel.self, "https://httpbin.org/delete", method: .delete)
                
                let data = try await [getResponse, postResponse, putResponse, deleteResponse]
                
                getLabel.text = "URL: \(data[0].url) \nget method success\n \(data[0].origin)"
                postLabel.text = "URL: \(data[1].url) \npost method success\n \(data[1].origin)"
                putLabel.text = "URL: \(data[2].url) \nput method success\n \(data[2].origin)"
                deleteLabel.text = "URL: \(data[3].url) \ndelete method success\(data[3].origin)"
                
                
                requestDataButotn.isEnabled = true
                isNowFinishing()
                
            } catch {
                print("\(error)")
                
                getLabel.text = "\(error)"
                postLabel.text = ""
                putLabel.text = ""
                deleteLabel.text = ""
                requestDataButotn.isEnabled = true
                isNowFinishing()
            }
        }
    }
}

