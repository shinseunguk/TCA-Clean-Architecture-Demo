//
//  ValidationError.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation

enum ValidationError: Error, Equatable {
    case emptyTitle
    case titleTooShort(minLength: Int)
    case titleTooLong(maxLength: Int)
    case invalidEmail
    case emptyEmail
    case invalidPhoneNumber
    case emptyName
    case nameTooShort(minLength: Int)
    case nameTooLong(maxLength: Int)
    case invalidUsername
    case usernameAlreadyExists
    case invalidWebsite
    case custom(String)
    
    var localizedDescription: String {
        switch self {
        case .emptyTitle:
            return "제목을 입력해주세요."
        case .titleTooShort(let minLength):
            return "제목은 최소 \(minLength)자 이상 입력해주세요."
        case .titleTooLong(let maxLength):
            return "제목은 최대 \(maxLength)자까지 입력 가능합니다."
        case .invalidEmail:
            return "올바른 이메일 형식을 입력해주세요."
        case .emptyEmail:
            return "이메일을 입력해주세요."
        case .invalidPhoneNumber:
            return "올바른 전화번호 형식을 입력해주세요."
        case .emptyName:
            return "이름을 입력해주세요."
        case .nameTooShort(let minLength):
            return "이름은 최소 \(minLength)자 이상 입력해주세요."
        case .nameTooLong(let maxLength):
            return "이름은 최대 \(maxLength)자까지 입력 가능합니다."
        case .invalidUsername:
            return "올바른 사용자명 형식을 입력해주세요."
        case .usernameAlreadyExists:
            return "이미 사용 중인 사용자명입니다."
        case .invalidWebsite:
            return "올바른 웹사이트 URL을 입력해주세요."
        case .custom(let message):
            return message
        }
    }
}

extension ValidationError {
    static func validateEmail(_ email: String) -> ValidationError? {
        if email.isEmpty {
            return .emptyEmail
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            return .invalidEmail
        }
        
        return nil
    }
    
    static func validateTitle(_ title: String, minLength: Int = 1, maxLength: Int = 100) -> ValidationError? {
        if title.isEmpty {
            return .emptyTitle
        }
        
        if title.count < minLength {
            return .titleTooShort(minLength: minLength)
        }
        
        if title.count > maxLength {
            return .titleTooLong(maxLength: maxLength)
        }
        
        return nil
    }
    
    static func validateName(_ name: String, minLength: Int = 1, maxLength: Int = 50) -> ValidationError? {
        if name.isEmpty {
            return .emptyName
        }
        
        if name.count < minLength {
            return .nameTooShort(minLength: minLength)
        }
        
        if name.count > maxLength {
            return .nameTooLong(maxLength: maxLength)
        }
        
        return nil
    }
}
