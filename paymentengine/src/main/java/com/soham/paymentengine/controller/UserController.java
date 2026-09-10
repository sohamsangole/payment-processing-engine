package com.soham.paymentengine.controller;

import com.soham.paymentengine.dto.UserModel;
import com.soham.paymentengine.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = {"http://localhost:4200", "http://localhost:3000", "*"})
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping
    public ResponseEntity<UserModel> createUser(@RequestBody UserModel userModel) {
        UserModel created = userService.createUser(userModel);
        return new ResponseEntity<>(created, HttpStatus.CREATED);
    }
    @GetMapping("/{username}")
    public ResponseEntity<UserModel> getUser(@PathVariable String username) {
        UserModel user = userService.getUser(username);
        return ResponseEntity.ok(user);
    }
    @PutMapping
    public ResponseEntity<UserModel> updateUser(@RequestBody UserModel userModel) {
        UserModel updated = userService.updateUser(userModel);
        return ResponseEntity.ok(updated);
    }
    @PostMapping("/login")
    public ResponseEntity<UserModel> login(@RequestBody UserModel userModel) {
        UserModel user = userService.login(userModel);
        return ResponseEntity.ok(user);
    }
    @DeleteMapping("/{username}")
    public ResponseEntity<Void> deleteUser(@PathVariable String username) {
        userService.deleteUser(username);
        return ResponseEntity.noContent().build();
    }

}
