package com.soham.paymentengine.dto;
import lombok.Getter;
import lombok.Setter;
import com.soham.paymentengine.enums.Role;
import java.util.Date;

@Getter
@Setter
public class UserModel {
    private String username;
    private String password;
    private String name;
    private String email;
    private Date dob;
    private Role role;
    private boolean enabled;
}