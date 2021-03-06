//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import Hyperspace
import Result

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: - Models

struct User: Decodable {
    let id: Int
    let name: String
    let username: String
    let email: String
}

struct Post: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

struct NewPost: Encodable {
    let userId: Int
    let title: String
    let body: String
}

// MARK: - Example

/// 1. Customize the defaults for NetworkRequest creation (optional)

NetworkRequestDefaults.defaultTimeout = 60 // Default timeout is 30 seconds
NetworkRequestDefaults.defaultCachePolicy = .reloadIgnoringLocalCacheData // Default cache policy is '.useProtocolCachePolicy'

/// 2. Create your concrete NetworkRequest types

struct GetUserRequest: NetworkRequest {
    // Define the model we want to get back
    typealias ResponseType = User
    typealias ErrorType = AnyError
    
    // Define NetworkRequest property values
    var method: HTTP.Method = .get
    var url: URL {
        return URL(string: "http://jsonplaceholder.typicode.com/users/\(userId)")!
    }
    var queryParameters: [URLQueryItem]?
    var headers: [HTTP.HeaderKey: HTTP.HeaderValue]?
    var body: Data?
    
    // Define any custom properties needed
    private let userId: Int
    
    // Initializer
    init(userId: Int) {
        self.userId = userId
    }
}

struct CreatePostRequest: NetworkRequest {
    // Define the model we want to get back
    typealias ResponseType = Post
    typealias ErrorType = AnyError
    
    // Define NetworkRequest property values
    var method: HTTP.Method = .post
    var url = URL(string: "http://jsonplaceholder.typicode.com/posts")!
    var queryParameters: [URLQueryItem]?
    var headers: [HTTP.HeaderKey: HTTP.HeaderValue]? = [.contentType: .applicationJSON]
    var body: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(newPost)
    }
    
    // Define any custom properties needed
    private let newPost: NewPost
    
    // Initializer
    init(newPost: NewPost) {
        self.newPost = newPost
    }
}

/// 3. Instantiate your concrete NetworkRequest types

let getUserRequest = GetUserRequest(userId: 1)
let createPostRequest = CreatePostRequest(newPost: NewPost(userId: 1, title: "Test tile", body: "Test body"))

/// 4. Create a BackendServices to execute the requests

let backendService = BackendService()

/// 5. Execute the NetworkRequest

func getUser(completion: @escaping () -> Void) {
    backendService.execute(request: getUserRequest) { (result) in
        switch result {
        case .success(let user):
            print("Fetched user: \(user)")
        case .failure(let error):
            print("Error fetching user: \(error)")
        }
        
        completion()
    }
}

func createPost(completion: @escaping () -> Void) {
    backendService.execute(request: createPostRequest) { (result) in
        switch result {
        case .success(let post):
            print("Created post: \(post)")
        case .failure(let error):
            print("Error creating post: \(error)")
        }
        
        completion()
    }
}

func executeExample() {
    getUser {
        createPost {
            PlaygroundPage.current.finishExecution()
        }
    }
}

executeExample()
