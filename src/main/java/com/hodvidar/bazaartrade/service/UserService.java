package com.hodvidar.bazaartrade.service;

import com.hodvidar.bazaartrade.model.User;

import java.util.List;

public interface UserService {

    List<User> getAllUsers();

    User getUserById(Long id);
}
