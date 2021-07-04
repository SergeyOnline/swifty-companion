//
//  PostAndGet.swift
//  swifty-companion
//
//  Created by Сергей on 02.07.2021.
//

import Foundation

let ClienId = "b44dd5fb7360f2d0393efeeb0f1e6280d253b55af360aa9f733a62c46175622a"
let ClientSecret = "637d7999402fc2cd8aa9c5ab30e8c3083861115bea55a047567e79d5bf43c241"
let TokenHTTP = "https://api.intra.42.fr/oauth/token"


struct Token: Decodable {
	var access_token: String
	var created_at: Int
	var expires_in: Int
	var scope: String
	var token_type: String
}

struct User: Decodable {
	var id:		Int
	var login:	String
	var url:	String
}

struct Project: Decodable {
	var id: Int
	var name: String
}

struct ProjectsUsers: Decodable {
	var final_mark: Int?
	var status: String
	var project: Project
	var cursus_ids: [Int]
}

struct Cursus: Decodable {
	var grade: String?
	var level: Double
	var skills: [Skills]
}

struct Skills: Decodable {
	var id: Int
	var name: String
	var level: Double
}


struct CurrentUser: Decodable {
	var id:		Int
	var login:	String
	var url:	String
	var email: String
	var first_name: String
	var last_name: String
	var displayname: String
	var image_url: String
	var correction_point: Int
	var pool_month: String
	var pool_year: String
	var wallet: Int
	var projects_users: [ProjectsUsers]
	var cursus_users: [Cursus]
}

func tokenPost(completion: @escaping (Token) -> ()) {
	guard let url = URL(string: TokenHTTP) else { return }
	let parameters = ["grant_type":"client_credentials", "client_id": ClienId, "client_secret": ClientSecret]
	var request = URLRequest(url: url)
	request.httpMethod = "POST"
	request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	
	guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
	request.httpBody = httpBody
	
	let session = URLSession.shared
	session.dataTask(with: request) { data, response, error in
//			if let response = response {
//				print(response)
//			}
		guard let data = data else { return }
		guard error == nil else { return }
		do {
			let token = try JSONDecoder().decode(Token.self, from: data)
//			print(token)
			completion(token)
		} catch {
			print(error)
		}
	}.resume()
}

func getUsers(user: String, params: Token, completion: @escaping ([User]) -> ()) {
	guard let url = URL(string: "https://api.intra.42.fr/v2/users?range[login]=\(user),\(user + "z")&sort=login") else { return }
	var request = URLRequest(url: url)
	request.httpMethod = "GET"
	request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	request.addValue("Bearer " + params.access_token, forHTTPHeaderField: "Authorization")
	let session = URLSession.shared
	session.dataTask(with: request) { data, response, error in
//		if let response = response {
//			print(response)
//		}
		guard let data = data else { return }
		guard error == nil else { return }
		
		do {
			let users = try JSONDecoder().decode([User].self, from: data)
			completion(users)
//			print(users)
		} catch {
//			print(error)
		}
	}.resume()
}

func getUserInfo(userId: Int, params: Token, completion: @escaping (CurrentUser) -> ()) {
	guard let url = URL(string: "https://api.intra.42.fr/v2/users/\(userId)") else { return }
	var request = URLRequest(url: url)
	request.httpMethod = "GET"
	request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	request.addValue("Bearer " + params.access_token, forHTTPHeaderField: "Authorization")
	let session = URLSession.shared
	session.dataTask(with: request) { data, response, error in
//		if let response = response {
//			print(response)
//		}
		guard let data = data else { return }
		guard error == nil else { return }
		
		do {
			let user = try JSONDecoder().decode(CurrentUser.self, from: data)
			completion(user)
//			print(user)
		} catch {
			print(error)
		}
	}.resume()
}
