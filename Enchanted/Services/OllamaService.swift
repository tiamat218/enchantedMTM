//
//  OllamaService.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 09/12/2023.
//

import Foundation
import OllamaKit

class OllamaService: @unchecked Sendable {
    static let shared = OllamaService()
    
    var ollamaKit: OllamaKit
    
    init() {
        
        ollamaKit = OllamaKit(baseURL: URL(string: "https://mtm.ab.vaasl.io")!)
        initEndpoint()
    }
    
    func initEndpoint() {
        
        let fixedUrl = "https://mtm.ab.vaasl.io"
        let fixedBearerToken = "" 

        if let url = URL(string: fixedUrl) {
            ollamaKit = OllamaKit(baseURL: url, bearerToken: fixedBearerToken)
        }
    }
    
    func getModels() async throws -> [LanguageModel]  {
        let response = try await ollamaKit.models()
        let models = response.models.map {
            LanguageModel(
                name: $0.name,
                provider: .ollama,
                imageSupport: $0.details.families?.contains(where: { $0 == "clip" || $0 == "mllama" }) ?? false
            )
        }
        return models
    }
    
    func reachable() async -> Bool {
        return await ollamaKit.reachable()
    }
}
