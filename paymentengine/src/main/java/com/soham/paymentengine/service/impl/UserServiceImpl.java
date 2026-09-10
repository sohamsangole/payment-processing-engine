package com.soham.paymentengine.service.impl;

import com.soham.paymentengine.dto.UserModel;
import com.soham.paymentengine.entity.UserEntity;
import com.soham.paymentengine.enums.Role;
import com.soham.paymentengine.mapper.UserMapper;
import com.soham.paymentengine.repository.UserRepository;
import com.soham.paymentengine.service.UserService;
import com.soham.paymentengine.util.PasswordEncoder;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    public UserModel getUser(String username) {
        UserEntity userEntity = userRepository.findByUsername(username).orElseThrow(() -> new RuntimeException("User not found with username " + username));
        return userMapper.userEntityToModel(userEntity);
    }

    @Override
    public UserModel createUser(UserModel userModel) {
        if (userRepository.existsByUsername(userModel.getUsername())){
            throw new RuntimeException("Username '" + userModel.getUsername() + "' is already taken");
        }

        UserEntity userEntity = userMapper.userModelToEntity(userModel);
        if (userEntity.getRole() == null) {
            userEntity.setRole(Role.USER);
        }
        userEntity.setEnabled(true);
        if (userModel.getPassword() != null && !userModel.getPassword().isEmpty()) {
            userEntity.setPassword(passwordEncoder.encode(userModel.getPassword()));
        }
        UserEntity savedEntity = userRepository.save(userEntity);
        return userMapper.userEntityToModel(savedEntity);
    }

    @Override
    public UserModel updateUser(UserModel userModel) {
        UserEntity existingEntity = userRepository.findByUsername(userModel.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found with username: " + userModel.getUsername()));
        existingEntity.setName(userModel.getName());
        existingEntity.setEmail(userModel.getEmail());
        existingEntity.setDob(userModel.getDob());
        existingEntity.setRole(userModel.getRole());
        existingEntity.setEnabled(userModel.isEnabled());
        if (userModel.getPassword() != null && !userModel.getPassword().isEmpty()) {
            existingEntity.setPassword(passwordEncoder.encode(userModel.getPassword()));
        }
        UserEntity updatedEntity = userRepository.save(existingEntity);
        return userMapper.userEntityToModel(updatedEntity);
    }

    @Override
    public void deleteUser(String username) {
        UserEntity userEntity = userRepository.findByUsername(username).orElseThrow(() -> new RuntimeException("User not found with username " + username));
        userRepository.delete(userEntity);
    }

    @Override
    public UserModel login(UserModel userModel) {
        UserEntity userEntity = userRepository.findByUsername(userModel.getUsername())
                .orElseThrow(() -> new RuntimeException("Invalid username or password"));
        if (!passwordEncoder.matches(userModel.getPassword(), userEntity.getPassword())) {
            throw new RuntimeException("Invalid username or password");
        }
        return userMapper.userEntityToModel(userEntity);
    }
}
