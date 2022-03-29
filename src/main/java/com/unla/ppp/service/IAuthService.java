package com.unla.ppp.service;

import org.springframework.http.ResponseEntity;

import com.unla.ppp.dto.LoginRequest;
import com.unla.ppp.dto.RegistrationRequest;
import com.unla.ppp.dto.UserResponse;


public interface IAuthService {
    ResponseEntity<Object> register(RegistrationRequest request);
    ResponseEntity<Object> login(LoginRequest loginRequest);
    UserResponse findByEmail(String email);
    LoginRequest createLoginRequest(RegistrationRequest reqModel);
}
