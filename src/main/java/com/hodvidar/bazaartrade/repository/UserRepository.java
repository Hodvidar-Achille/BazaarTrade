package com.hodvidar.bazaartrade.repository;

import com.hodvidar.bazaartrade.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    // Additional query methods can be defined here if needed
}

