import 'package:http/http.dart' as http;
import 'dart:convert';

const String base_url = 'https://phpstack-351614-1150808.cloudwaysapps.com';
const api_url = base_url + '/api/customer';

class UserRepository {
  //  Future<List<Address>> getAllAddress() => _addressProvider.getAddress();

  // Future<List<Pickup>> getAllPickup() => _addressProvider.getPikup();

  Future<void> signUp(Map user) async {
    print(user);
    return Future.value();
  }

  Future<http.Response> signIn(Map parametrs) {
    return http.post(
      Uri.parse(api_url + '/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(parametrs),
    );
  }
}

//
//  DownloadManager.swift
//  SmartApaga
//
//  Created by MacBook on 6/3/20.
//  Copyright © 2020 Armen Gasparyan. All rights reserved.
//

// import Foundation
// import SwiftKeychainWrapper

// const base_url = 'https://phpstack-351614-1150808.cloudwaysapps.com' //"https://smartapaga.nooshtech.com"
// const api_url = base_url + '/api/customer'

// enum APIEndpoints {
//     register,
//     resetPassword,
//     checkCode,
//     activate,
//     exists,
//     sendCode,
//     logout,
//     pickupAdd,
//     pickupsOngoing,
//     pickupCancel(picID: Int),
//     pickupsPassed,
//     addressAdd,
//     addresses,

//     var path: String {
//         switch self {
//         case .register:
//             return "/register"
//         case .resetPassword:
//             return "/resetPassword"
//         case .checkCode:
//             return "/checkCode"
//         case .activate:
//             return "/activate"
//         case .exists:
//             return "/exists"
//         case .sendCode:
//             return "/sendCode"
//         case .logout:
//             return "/logout"
//         case .pickupAdd:
//             return "/pickups/add"
//         case .pickupsOngoing:
//             return "/pickups/ongoing"
//         case let .pickupCancel(picID):
//             return "/pickups/\(picID)/cancel"
//         case .pickupsPassed:
//             return "/pickups/passed"
//         case .addressAdd:
//             return "/addresses/add"
//         case .addresses:
//             return "/addresses"
//         }
//     }
// }

// enum HttpMethod: String {
//     case GET, POST
// }

// class RequestManager {
//     static let shared = RequestManager()

//     func makeRequest(with parametrs: [String: Any]? = nil, endPoint: APIEndpoints, httpMethod: HttpMethod, completion: @escaping (_ result: Results) -> Void) {
//         let urlString = api_url + endPoint.path
//         guard let url = URL(string: urlString) else { return }

//         var request = URLRequest(url: url)
//         request.addValue("application/json", forHTTPHeaderField: "Content-Type")

//         if let token = KeychainWrapper.standard.string(forKey: "accessToken") {
//             request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//         }

//         if let parametrs = parametrs {
//             guard let httpBody = try? JSONSerialization.data(withJSONObject: parametrs, options: []) else { return }
//             request.httpBody = httpBody
//         }

//         request.httpMethod = httpMethod.rawValue

//         let sesion = URLSession.shared
//         sesion.dataTask(with: request) { (data, response, error) in
//             completion(Results(withData: data,
//                                response: response,
//                                error: error))
//         }.resume()
//     }

// }

// struct Results {
//     var data: Data?
//     var response: URLResponse?
//     var error: Error?

//     init(withData data: Data?, response: URLResponse?, error: Error?) {
//         self.data = data
//         self.response = response
//         self.error = error
//     }

//     init(withError error: Error) {
//         self.error = error
//     }
// }

