package com.hodvidar.bazaartrade.repository;

import com.hodvidar.bazaartrade.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product, Long> {
    // Additional query methods can be defined here if needed
}
