package com.hodvidar.bazaartrade.service;

import com.hodvidar.bazaartrade.model.User;
import com.hodvidar.bazaartrade.model.UserRole;
import com.hodvidar.bazaartrade.repository.UserRepository;
import com.hodvidar.bazaartrade.service.impl.UserServiceImpl;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.when;

// @RunWith(SpringRunner.class)
@SpringBootTest
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserServiceImpl userService;

    @Test
    void getUserByIdTest() {
        User mockUser = new User(1L, "Test", "Test Address", "test@test.com", "password", UserRole.BUYER);
        when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));

        User user = userService.getUserById(1L);

        assertNotNull(user);
        assertEquals("Test", user.getName());
    }
}

