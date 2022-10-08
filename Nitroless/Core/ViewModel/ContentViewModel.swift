//
//  ContentViewModel.swift
//  Nitroless
//
//  Created by Paras KCD on 2022-10-08.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var repos = [Repo]()
    @Published var isLoading = false
    @Published var isHomeActive = true
    
    init() {
        self.fetchRepos()
    }
    
    func makeRepoActive(url: String) {
        let repos = self.repos
        var newRepos = [Repo]()
        
        for var repo in repos {
            repo.active = false
            if repo.url == url {
                repo.active = true
            }
            
            newRepos.append(repo)
        }
        
        DispatchQueue.main.async {
            self.repos = newRepos
            if self.isHomeActive == true {
                self.isHomeActive = false
            }
        }
        
    }
    
    func makeAllReposInactive() {
        let repos = self.repos
        var newRepos = [Repo]()
        
        for var repo in repos {
            if repo.active == true {
                repo.active = false
            }
            
            newRepos.append(repo)
        }
        
        DispatchQueue.main.async {
            self.repos = newRepos
            self.isHomeActive = true
        }
    }
    
    func fetchRepos() {
        guard let url = URL(string: "https://nitroless.github.io/default.json") else { return }
        let req = URLRequest(url: url)
        URLSession.shared.dataTask(with: req) {
            data, response, error in
            
            if let error = error {
                print("DEBUG: Error - \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("DEBUG: Response Code - \(response.statusCode)")
            }
            
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode([String].self, from: data)
                DispatchQueue.main.async {
                    for urlString in json {
                        guard let url = URL(string: "\(urlString)/index.json") else { continue }
                        
                        URLSession.shared.dataTask(with: url) {
                            data, response, error in
                            
                            if let error = error {
                                print("DEBUG: Error - \(error.localizedDescription)")
                                DispatchQueue.main.async {
                                    self.isLoading = false
                                }
                                return
                            }
                            
                            if let response = response as? HTTPURLResponse {
                                print("DEBUG: Response Code - \(response.statusCode)")
                            }
                            
                            guard let data = data else { return }
                            
                            do {
                                let emote = try JSONDecoder().decode(Emote.self, from: data)
                                DispatchQueue.main.async {
                                    let repo = Repo(active: false, url: urlString, emote: emote)
                                    self.repos.append(repo)
                                    self.isLoading = false
                                }
                            } catch let error {
                                print("DEBUG: Failed to decode because of Error - \(error)")
                                DispatchQueue.main.async {
                                    self.isLoading = false
                                }
                            }

                        }.resume()
                    }
                }
            } catch let error {
                print("DEBUG: Failed to decode because of Error - \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }
}
