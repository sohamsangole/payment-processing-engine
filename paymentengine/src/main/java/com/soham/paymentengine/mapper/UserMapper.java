package com.soham.paymentengine.mapper;

import com.soham.paymentengine.dto.UserModel;
import com.soham.paymentengine.entity.UserEntity;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {
    public UserModel userEntityToModel(UserEntity userEntity){
        if (userEntity == null){
            return null;
        }
        UserModel userModel = new UserModel();
        userModel.setUsername(userEntity.getUsername());
        userModel.setName(userEntity.getName());
        userModel.setEmail(userEntity.getEmail());
        userModel.setDob(userEntity.getDob());
        userModel.setRole(userEntity.getRole());
        userModel.setEnabled(userEntity.isEnabled());
        return userModel;
    }

    public UserEntity userModelToEntity(UserModel userModel) {
        if (userModel == null) {
            return null;
        }
        UserEntity userEntity = new UserEntity();
        userEntity.setUsername(userModel.getUsername());
        userEntity.setPassword(userModel.getPassword());
        userEntity.setName(userModel.getName());
        userEntity.setEmail(userModel.getEmail());
        userEntity.setDob(userModel.getDob());
        userEntity.setRole(userModel.getRole());
        userEntity.setEnabled(userModel.isEnabled());
        return userEntity;
    }
}
