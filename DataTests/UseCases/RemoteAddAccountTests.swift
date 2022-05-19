import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_httpPostClient_with_corret_url() throws {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeCreateSut()
        let _addAccountModel = createAccount()
        
        sut.add(addAccountModel: _addAccountModel)
        
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func test_add_should_call_httpPostClient_with_corret_data() throws {
        let (sut, httpClientSpy) = makeCreateSut()
        let _addAccountModel = createAccount()
        
        sut.add(addAccountModel: _addAccountModel)
        
        XCTAssertEqual(httpClientSpy.data, _addAccountModel.toData())
    }
     
}

extension RemoteAddAccountTests {
    
    class HttpClientSpy: HttpPostClient {
        var urls = [URL]()
        var data: Data?   // ? = opcional
        
        func post(to url: URL, with data: Data?) {
            self.urls.append(url)
            self.data = data
        }
    }
    
    func createAccount() -> AddAccountModel {
        return AddAccountModel(name: "any name", email: "any_email@email.com", password: "any_password", passwordConfirmation: "any_password")
    }
    
    func makeCreateSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (sut, httpClientSpy)
    }

}
