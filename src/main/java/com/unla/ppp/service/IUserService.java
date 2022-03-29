package com.unla.ppp.service;

import java.util.List;

import com.unla.ppp.dto.*;
import com.unla.ppp.model.Usuario;


public interface IUserService {
    List<UserResponse> findAllUsers();
    String softDeleteUser(long id);
    Usuario updateUser(Long id, UserRequest user);

}
