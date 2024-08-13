package es.codeurjc.mastercloudapps.planner.models;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.io.Serializable;

public class EoloplantCreationRequest implements Serializable {

    private static final long serialVersionUID = 5511349529410950840L;

    private long id;
    private long userId;
    private String city;

    public EoloplantCreationRequest() {}
    
    public EoloplantCreationRequest(
            @JsonProperty("id") int id,
            @JsonProperty("userId") int userId,
            @JsonProperty("city") String city) {
        this.id = id;
        this.userId = userId;
        this.city = city;
    }

    public long getId() {
        return id;
    }

    public long getUserId() {
        return userId;
    }

    public String getCity() {
        return city;
    }

    @Override
    public String toString() {
        return "EoloplantCreationRequest {" +
                "id=" + id +
                ", city='" + city + '}';
    }
}
