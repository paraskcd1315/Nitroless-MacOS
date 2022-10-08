//
//  ContentViewModel.swift
//  Nitroless
//
//  Created by Paras KCD on 2022-10-08.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var defaultRepos = [String]()
    @Published var emotes = [Emote]()
    @Published var isLoading = false
    
    init() {
         fetchDefaultRepos()
         fetchEmotes()
    }
    
    func fetchDefaultRepos() {
        self.isLoading = true;
        
        let urlString = "https://nitroless.github.io/default.json"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            if let error = error {
                print("DEBUG: Error - \(error.localizedDescription)")
                self.isLoading = false
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("DEBUG: Response Code - \(response.statusCode)")
            }
            
            guard let data = data else { return }
            
            do {
                let defaultRepos = try JSONDecoder().decode([String].self, from: data)
                DispatchQueue.main.async {
                    self.defaultRepos = defaultRepos
                }
            } catch let error {
                print("DEBUG: Failed to decode because of Error - \(error)")
                self.isLoading = false
            }
        }.resume()
    }
    
    func fetchEmotes() {
        let urlStrings = self.defaultRepos
        
        for urlString in urlStrings {
            guard let url = URL(string: urlString) else { continue }
            
            URLSession.shared.dataTask(with: url) {
                data, response, error in
                
                if let error = error {
                    print("DEBUG: Error - \(error.localizedDescription)")
                    self.isLoading = false
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    print("DEBUG: Response Code - \(response.statusCode)")
                }
                
                guard let data = data else { return }
                
                do {
                    let emote = try JSONDecoder().decode(Emote.self, from: data)
                    print("DEBUG -", emote)
                    DispatchQueue.main.async {
                        self.emotes.append(emote)
                    }
                } catch let error {
                    print("DEBUG: Failed to decode because of Error - \(error)")
                    self.isLoading = false
                }

            }.resume()
        }
        
        self.isLoading = false
    }
}
