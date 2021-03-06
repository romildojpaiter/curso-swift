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
