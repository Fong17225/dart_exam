package com.example.be.controller;

import com.example.be.model.Place;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;

@Component
@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*") // Cho phép tất cả các origin truy cập API
public class PlaceController {

    @GetMapping("/places")
    public List<Place> getAllPlaces() {
        // Dữ liệu giả cho các địa điểm phổ biến
        return Arrays.asList(
                new Place("Hội An", 4.8, "https://images.unsplash.com/photo-1582774803540-8a703c87184d?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                new Place("Sài Gòn", 4.5, "https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?q=80&w=1000&auto=format&fit=crop"),
                new Place("Hà Nội", 4.7, "https://images.unsplash.com/photo-1528127269322-539801943592?q=80&w=1000&auto=format&fit=crop"),
                new Place("Đà Nẵng", 4.6, "https://images.unsplash.com/photo-1620976128192-7181e9f91342?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                new Place("Nha Trang", 4.4, "https://images.unsplash.com/photo-1533002832-1721d16b4bb9?q=80&w=2178&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")
        );
    }
} 