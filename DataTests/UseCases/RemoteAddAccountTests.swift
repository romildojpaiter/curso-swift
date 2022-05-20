import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_httpPostClient_with_corret_url() throws {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeSut()
        let _addAccountModel = makeAddAccountModel()
        
        sut.add(addAccountModel: _addAccountModel) { _ in }
        
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func test_add_should_call_httpPostClient_with_correct_data() throws {
        let (sut, httpClientSpy) = makeSut()
        let _addAccountModel = makeAddAccountModel()
        
        sut.add(addAccountModel: _addAccountModel) { _ in }
        
        XCTAssertEqual(httpClientSpy.data, _addAccountModel.toData())
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_error() throws {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithError(.noConnectivity)
        })
    }
    
    func test_add_should_complete_with_account_if_client_completes_with_valid_data() throws {
        let (sut, httpClientSpy) = makeSut()
        let account = makeAccountModel()
        expect(sut, completeWith: .success(account), when: {
            httpClientSpy.completeWithData(account.toData()!)
        })
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_invalid_data() throws {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithData(Data("invalid_json_data".utf8))
        })
    }
     
}

extension RemoteAddAccountTests {
    
    class HttpClientSpy: HttpPostClient {
        var urls = [URL]()
        var data: Data?   // ? = opcional
        var completion: ((Result<Data, HttpError>) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            self.completion?(.failure(error))
        }
        
        func completeWithData(_ _data: Data) {
            self.completion?(.success(_data))
        }
        
    }
    
    func makeAccountModel() -> AccountModel {
        return AccountModel(id: "any id", name: "any name", email: "any_email@email.com", password: "any_password")
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any name", email: "any_email@email.com", password: "any_password", passwordConfirmation: "any_password")
    }
    
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (sut, httpClientSpy)
    }
    
    func expect(_ sut: RemoteAddAccount, completeWith expectResult: Result<AccountModel, DomainError>, when action: () -> Void) {
        let exp = expectation(description: "waiting")
        
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectResult, receivedResult) {
                
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError)
                
            case (.success(let expectedSuccess), .success(let receiveSuccess)): XCTAssertEqual(expectedSuccess, receiveSuccess)
                
            default: XCTFail("Expected \(expectResult) received \(receivedResult) instead")
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
        
    }

}
