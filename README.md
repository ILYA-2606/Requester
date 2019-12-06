![CocoaPods](https://cocoapod-badges.herokuapp.com/v/Requester/badge.png)

# Requester

Lightweight HTTP Networking in Swift

## Requirements:
- CocoaPods

## Features:
- Lightweight wrapper for URLSession
- Task management
- Decodable support
- JSON parsing
- Image decoding
- Authentication with URLCredential
- Detail progress information
- iOS 9+ Support

## Installation
- Add `Requester` in your iOS Project with CocoaPods:
```ruby
pod 'Requester', '~> 1.0.1'
```

## How to use:
Image downloading:
```swift
let requester = Requester.shared
requester.sendDataRequest(
    url: url,
    completion: { (image: UIImage) in
        // Image downloaded
},
    failure: { error in
        // Image not loaded with error
},
    progressHandler: { progress in
        // Image downloading with progress
)}
```

JSON API:
```swift
struct SomeResponseDTO: Decodable {
    let parameter1: String
    let parameter2: Double
}

let requester = Requester.shared
requester.sendJSONRequest(
    url: url,
    completion: { (dto: SomeResponseDTO) in
        // JSON is loaded and DTO model has been parsed
},
    failure: { error in
        // JSON not loaded and parsed with error
},
    progressHandler: { progress in
        // JSON downloading with progress
)}
```
