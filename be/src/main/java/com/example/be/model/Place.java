package com.example.be.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Place {
    @JsonProperty("name")
    private String name;
    
    @JsonProperty("rating")
    private double rating;
    
    @JsonProperty("imageUrl")
    private String imageUrl;

    // Constructor mặc định cho Jackson
    public Place() {
    }

    public Place(String name, double rating, String imageUrl) {
        this.name = name;
        this.rating = rating;
        this.imageUrl = imageUrl;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
} 