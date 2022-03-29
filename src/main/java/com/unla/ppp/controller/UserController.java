package com.unla.ppp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.unla.ppp.dto.UserRequest;
import com.unla.ppp.dto.UserResponse;
import com.unla.ppp.service.IUserService;
import lombok.AllArgsConstructor;

@RestController
@RequestMapping(path = "/users")
@AllArgsConstructor
public class UserController {

    @Autowired
    private IUserService userService;

    @GetMapping("/")
    public List<UserResponse> getUserList() {
        return userService.findAllUsers();
    }
    
    @PatchMapping(value = "/{id}")
    public ResponseEntity<Object> updateUser(@PathVariable ("id") Long id, @RequestBody UserRequest user){
        try{
            return new ResponseEntity<>(userService.updateUser(id, user), HttpStatus.OK);
        }
        catch (Exception e){
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

}