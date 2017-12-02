//
//  AuthProvider.swift
//  myindiefilms
//
//  Created by Vin on 12/1/17.
//  Copyright © 2017 Vin. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ msg: String?) -> Void;

struct LoginErrorCode {
    static let INVALID_EMAIL = "Invalid Email Address, Please Provide a Real Email Address";
    static let WRONG_PASSWORD = "Wrong Password, Please Enter the Correct Password";
    static let PROBLEM_CONNECTING = "Problem Connecting to Database, Please Try Again Later";
    static let USER_NOT_FOUND = "User Not Found, Please Register";
    static let EMAIL_ALREADY_IN_USE = "Email Already In Use, Please Use Another Email";
    static let WEAK_PASSWORD = "Password Should Be At Least 6 Characters Long";
}

class AuthProvider {
    private static let _instance = AuthProvider();
    
    static var Instance: AuthProvider {
        
        return _instance;
    }
    
    func login(withEmail: String, password: String, LoginHandler: LoginHandler?) {
        
        Auth.auth().signIn(withEmail: withEmail, password: password) { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error! as NSError, loginHandler: LoginHandler);
            } else  {
                LoginHandler?(nil);
                
            }
            
        }
        
    };
    
    // login func
    
    func signUp(withEmail: String, password: String, loginHandler:LoginHandler?) {
        
        Auth.auth().createUser(withEmail: withEmail, password: password) { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error! as NSError, loginHandler: loginHandler);
                
            } else {
                if (user?.uid) != nil {
                    
                    //store the user to database
                    //log in the user
                    
                    self.login(withEmail: withEmail, password: password, LoginHandler: loginHandler);
                }
            }
        }
        
    };
    func logOut() -> Bool {
        if (Auth.auth().currentUser != nil) {
            do {
                try Auth.auth().signOut();
                return true;
            } catch {
                return false;
            }
        }
        
        return true;
}
    private func handleErrors(err: NSError, loginHandler: LoginHandler?){
        
        if let errCode = AuthErrorCode(rawValue: err.code ){
            
            switch errCode {
                
            case .wrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD);
                break;
                
            case .invalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL);
                break;
                
            case .userNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND);
                break;
                
            case .emailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE);
                break;
                
            case .weakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD);
                break;
                
            default:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
                
                
                
            }
        }
    }
    
    
}
