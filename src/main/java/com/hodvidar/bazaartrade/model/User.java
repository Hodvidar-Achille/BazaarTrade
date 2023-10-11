package com.hodvidar.bazaartrade.model;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "Users")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String address;
    private String email;
    private String password;

    @Enumerated(EnumType.STRING)
    private UserRole role;

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", name=" + name +
                ", address=" + address +
                ", email=" + email +
                ", password=" + password +
                ", role=" + role +
                '}';
    }
}