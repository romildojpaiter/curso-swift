import Foundation
import Domain

func makeAddAccountModel() -> AddAccountModel {
    return AddAccountModel(name: "any name", email: "any_email@email.com", password: "any_password", passwordConfirmation: "any_password")
}

