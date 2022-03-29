package com.unla.ppp.service.impl;

import java.util.HashMap;
import java.util.Locale;
import java.util.Optional;

import org.springframework.context.MessageSource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import com.unla.ppp.dto.LoginRequest;
import com.unla.ppp.dto.RegistrationRequest;
import com.unla.ppp.dto.UserResponse;
import com.unla.ppp.model.Rol;
import com.unla.ppp.model.Usuario;
import com.unla.ppp.repository.RolRepository;
import com.unla.ppp.repository.UsuarioRepository;
import com.unla.ppp.service.IAuthService;
import com.unla.ppp.util.ERol;
import com.unla.ppp.util.JwtUtil;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@AllArgsConstructor
@Slf4j
public class AuthService implements IAuthService {
    private final UserService userService;
    private AuthenticationManager authenticationManager;
    private UsuarioRepository userRepository;
    private final MessageSource messageSource;
    private JwtUtil jwtTokenUtil;
    private final RolRepository roleRepository;

    @Override
    public ResponseEntity<Object> register(RegistrationRequest request) {

    	Usuario newUser = new Usuario(request.getNombre(), request.getApellido(), request.getEmail(),request.getDescripcion(), request.getClave());
    	
    	Rol rol = roleRepository.findByName(request.getNombreRol());
    	if(rol == null) {
    		rol = roleRepository.findByName(ERol.ROL_USER.name());
    	}
    	newUser.setRolId(rol);
        String register = userService.signUpUser(newUser);
        String error = messageSource.getMessage("register.error", null, Locale.US);
        log.info("{}", register);
        if (register != error) {
            LoginRequest loginRequest = this.createLoginRequest(request);
            return this.login(loginRequest);
        } else {
            return new ResponseEntity<>(error, HttpStatus.UNAUTHORIZED);
        }
    }

    @Override
    public ResponseEntity<Object> login(LoginRequest loginRequest)  {
        try {
            authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getClave()));
            var userReturn = findByEmail(loginRequest.getEmail());
            final UserDetails userDetails = userService.loadUserByUsername(loginRequest.getEmail());
            final String jwt = jwtTokenUtil.generateToken(userDetails);

            HttpHeaders responseHeaders = new HttpHeaders();
            responseHeaders.set("jwt",jwt);
            
            return new ResponseEntity<>(userReturn, responseHeaders, HttpStatus.OK);

        } catch (Exception e) {
        	System.out.println(e.getMessage());
            String loginErrorMsg = messageSource.getMessage("login.error", new Object[]{" Invalid"}, Locale.US);
            HashMap<String, Boolean> error = new HashMap<String, Boolean>();
            error.put("ok:", false);
            return new ResponseEntity<>(error + loginErrorMsg, HttpStatus.UNAUTHORIZED);
        }

    }

    @Override
    public UserResponse findByEmail(String email){
        Optional<Usuario> usuario = userRepository.findByEmail(email);
        UserResponse UserResponse = new UserResponse();
        if (usuario != null && usuario.isPresent()) {
        	UserResponse.setId(usuario.get().getId());
            UserResponse.setNombre(usuario.get().getNombre());
            UserResponse.setApellido(usuario.get().getApellido());
            UserResponse.setEmail(usuario.get().getEmail());
            UserResponse.setRolId(usuario.get().getRolId());
        }
        return UserResponse;
    }

    @Override
    public LoginRequest createLoginRequest(RegistrationRequest reqModel){
        LoginRequest loginRequest = new LoginRequest();
        loginRequest.setEmail(reqModel.getEmail());
        loginRequest.setClave(reqModel.getClave());
        return loginRequest;
    }
}
