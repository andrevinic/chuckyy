//
//  HandleError.swift
//  Chucky
//
//  Created by Andre Nogueira on 15/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import Foundation
import Moya

struct ResponseApiError: Decodable {
    let message: String?
    let technicalMessage: String?
}

enum ServiceError: Error {
    case invalidResponse
    case expiredSession
    case noInternetConnection
    case generic(message: String)
    case `default`
    case none
}

extension ServiceError {
    var errorMessage: String {
        switch self {
        case .invalidResponse:
            return "Falha ao obter informações."
        case .expiredSession:
            return "Sua sessão expirou."
        case .noInternetConnection:
            return "Você precisa se conectar à internet."
        case .generic(let message):
            return message
        case .default:
            return "Ocorreu um erro"
        case .none:
            return ""
        }
    }
}

class HandleError {
    
    /**
     Trata qualquer erro de api
     - Parameters:
     - error: qualquer erro de api ou de tentativa de requisicao
     */
    func handle(with error: Error) -> ServiceError {
        do {
            let response = try getResponseError(with: error)
            
            //print(String(data: response.data, encoding: .utf8) ?? "No response")
            
            switch response.statusCode {
            case 401:
                return .expiredSession
            case 404:
                return .generic(message: "Servico não encontrado")
            default: break
            }
            
            if isValidJson(response.data) {
                
                if let jsonError = try? JSONDecoder().decode(ResponseApiError.self, from: response.data) {
                    return .generic(message: jsonError.message ?? "")
                }
                
                //HANDLE DIFFERENT TYPES OF API ERROR
                print("Erro desconhecido")
                return .generic(message: "Ocorreu um erro")
                
            } else {
                let finalError = String(data: response.data, encoding: .utf8)
                    ?? ServiceError.invalidResponse.errorMessage
                print("finalError", finalError)
                return .generic(message: "Ocorreu um erro, tente novamente")
            }
            
        } catch {
            
            if let error = error as? ServiceError {
                return error
            }
            return .generic(message: "Ops ocorreu um erro")
        }
    }
    
    /**
     - Parameters:
     - data: Stream de erro de resposta da api
     - Returns: True se for válido ou false caso não seja válido
     */
    private func isValidJson(_ data: Data) -> Bool {
        do {
            _ = try JSONSerialization.jsonObject(with: data, options: [])
            return true
        } catch {
            return false
        }
    }
    
    /**
     - Note: Pode ser adicionado mais exeções
     - Parameters:
     - error: qualquer erro de api ou de tentativa de requisicao
     - Throws: `ApiError.noInternetConnection` se não estiver conectado na internet ou um
     `ApiError.invalidResponse` se não conseguir obter o response data
     - Returns: Response (Moya object)
     */
    private func getResponseError(with error: Error) throws -> Response {
        
        if !Reachability.isConnectedToNetwork() {
            throw ServiceError.noInternetConnection
        }
        
        if let error = error as? MoyaError, let response = error.response {
            return response
        }
        
        if let error = error as? ServiceError {
            throw error
        }
        
        throw ServiceError.invalidResponse
    }
}
