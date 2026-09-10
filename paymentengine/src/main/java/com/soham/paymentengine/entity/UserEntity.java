package com.soham.paymentengine.entity;

import com.soham.paymentengine.enums.Role;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Table(name = "users")
@Entity
@Getter
@Setter
public class UserEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(unique = true, nullable = false)
    private String username;
    @Column(nullable = false)
    private String password;
    private String name;
    private String email;
    private Date dob;
    private Role role = Role.USER;
    private boolean enabled = true;
}
