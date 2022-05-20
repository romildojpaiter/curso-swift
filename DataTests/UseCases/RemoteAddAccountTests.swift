import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_httpPostClient_with_corret_url() throws {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeCreateSut()
        let _addAccountModel = createAccount()
        
        sut.add(addAccountModel: _addAccountModel) { _ in }
        
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func test_add_should_call_httpPostClient_with_correct_data() throws {
        let (sut, httpClientSpy) = makeCreateSut()
        let _addAccountModel = createAccount()
        
        sut.add(addAccountModel: _addAccountModel) { _ in }
        
        XCTAssertEqual(httpClientSpy.data, _addAccountModel.toData())
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_error() throws {
        let (sut, httpClientSpy) = makeCreateSut()
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: createAccount()) { result in
            switch result {
                case .failure(let error): XCTAssertEqual(error, .unexpected)
                case .success : XCTFail("Expected error receive \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
    
     
}

extension RemoteAddAccountTests {
    
    class HttpClientSpy: HttpPostClient {
        var urls = [URL]()
        var data: Data?   // ? = opcional
        var completion: ((Result<Date, HttpError>) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (Result<Date, HttpError>) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            self.completion?(.failure(error))
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
