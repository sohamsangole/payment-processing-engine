package com.soham.paymentengine.service;

import com.soham.paymentengine.dto.UserModel;

public interface UserService {
    //getUser
    UserModel getUser(String username);
    //createUser
    UserModel createUser(UserModel userModel);
    //updateUser
    UserModel updateUser(UserModel userModel);
    //deleteUser
    void deleteUser(String username);
    //login
    UserModel login(UserModel userModel);
}
