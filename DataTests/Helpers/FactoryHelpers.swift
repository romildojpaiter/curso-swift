import Foundation

func makeInvalidData() -> Data {
    return Data("invalid_json_data".utf8)
}

func makeUrl() -> URL {
    return URL(string: "http://any-url.com")!
}

func makeValidData() -> Data {
    return Data("{\"name\":\"Romildo\"}".utf8)
}

func makeError() -> Error {
    return NSError(domain: "any_erro", code: 0)
}


