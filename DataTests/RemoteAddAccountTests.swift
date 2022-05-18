import XCTest
import Domain

class RemoteAddAccount {
    private let url: URL
    private let httpClient: HttpPostClient
    
    init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add(addAccountModel: AddAccountModel) {
        let data = try? JSONEncoder().encode(addAccountModel)
        httpClient.post(to: url, with: data)
    }
}

protocol HttpPostClient {
    func post(to url: URL, with data: Data?)
}


class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_httpPostClient_with_corret_url() throws {
        let url = URL(string: "http://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        let _addAccountModel = createAccount()
        sut.add(addAccountModel: _addAccountModel)
        
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    func test_add_should_call_httpPostClient_with_corret_data() throws {
        let url = URL(string: "http://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        let _addAccountModel = createAccount()
        sut.add(addAccountModel: _addAccountModel)
        let _data = try? JSONEncoder().encode(_addAccountModel)
        
        XCTAssertEqual(httpClientSpy.data, _data)
    }
     
}

extension RemoteAddAccountTests {
    
    class HttpClientSpy: HttpPostClient {
        var url: URL? // ? = opcional
        var data: Data?
        
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
    
    func createAccount() -> AddAccountModel {
        return AddAccountModel(name: "any name", email: "any_email@email.com", password: "any_password", passwordConfirmation: "any_password")
    }

}
