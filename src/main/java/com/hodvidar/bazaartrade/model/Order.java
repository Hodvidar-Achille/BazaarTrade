package com.hodvidar.bazaartrade.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "Orders")
@NoArgsConstructor
@Getter
@Setter
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "buyer_id")
    private User buyer;
    private LocalDateTime timestamp;
    @Enumerated(EnumType.STRING)
    private OrderStatus status;
    private Double totalPrice;

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", buyer=" + buyer +
                ", timestamp=" + timestamp +
                ", status=" + status +
                ", totalPrice=" + totalPrice +
                '}';
    }
}

