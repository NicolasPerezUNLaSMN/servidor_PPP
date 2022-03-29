package com.unla.ppp.service.impl;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import com.unla.ppp.dto.UserRequest;
import com.unla.ppp.dto.UserResponse;
import com.unla.ppp.model.Rol;
import com.unla.ppp.model.Usuario;
import com.unla.ppp.repository.RolRepository;
import com.unla.ppp.repository.UsuarioRepository;
import com.unla.ppp.service.IUserService;
import com.unla.ppp.util.ERol;

import lombok.AllArgsConstructor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class UserService implements UserDetailsService, IUserService{
	
    @Autowired
    RolRepository rolRepository;

    private final BCryptPasswordEncoder bCryptPasswordEncoder;
    private final UsuarioRepository userRepository;
    private final MessageSource messageSource;

    public String signUpUser(Usuario usuario) {
        try {
            String encodedPassword = bCryptPasswordEncoder.encode(usuario.getClave());

            usuario.setClave(encodedPassword);
            userRepository.save(usuario);
            String userCreatedMessage = messageSource.getMessage("user.created", new Object[]{"User"}, Locale.US);
            return userCreatedMessage;
        } catch (Exception e) {
        	e.printStackTrace();
            String registerError = messageSource.getMessage("register.error", null, Locale.US);
            return registerError;
        }
    }

    @Override
    public UserDetails loadUserByUsername(String email)
            throws UsernameNotFoundException {
        String userNotFoundMsg = messageSource.getMessage("user.not.found", new Object[]{"User"}, Locale.US);
        Optional<Usuario> usuario = userRepository.findByEmail(email);
        List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
        authorities.add(new SimpleGrantedAuthority(usuario.get().getRolId().getName()));
        try {
            return new org.springframework.security.core.userdetails.User(usuario.get().getEmail(), usuario.get().getClave(), authorities);
        } catch (Exception e) {
            throw new UsernameNotFoundException(userNotFoundMsg);
        }
    }

    public Authentication getAuthentication() {
        return SecurityContextHolder.getContext().getAuthentication();
    }


    @Override
    public List<UserResponse> findAllUsers() {
        List<Usuario> listUser = userRepository.findAll();
        List<UserResponse> listUserResponse = new ArrayList<>();

        listUserResponse = listUser.stream().map(new Function<Usuario, UserResponse>() {
                                                @Override
                                                public UserResponse apply(Usuario u) {
                                                    return new UserResponse(
                                                    		u.getId(),
                                                            u.getNombre(),
                                                            u.getApellido(),
                                                            u.getEmail(),
                                                            u.getDescripcion(),
                                                            u.getRolId()
                                                    );
                                                }
                                            }
        ).collect(Collectors.toList());


        return listUserResponse;
    }

    @Override
    public String softDeleteUser(long id) throws UsernameNotFoundException {
        try {
            userRepository.deleteById(id);
            String userDeleteMessage = messageSource.getMessage("user.deleted", new Object[]{"User"}, Locale.US);
            return userDeleteMessage;
        } catch (Exception e) {
            String userNotFoundByIdMsg = messageSource.getMessage("user.not.found.by.id", new Object[]{"User"}, Locale.US);
            throw new UsernameNotFoundException(userNotFoundByIdMsg);
        }
    }

    @Override
    public Usuario updateUser(Long id, UserRequest user) {
        Optional<Usuario> userToUp = userRepository.findById(id);
        Usuario usr = userToUp.get();
        if (id == userToUp.get().getId()) {
            if (userToUp.isPresent()) {
                String firstName = user.getNombre() == null ? usr.getNombre() : user.getNombre();
                String lastName = user.getApellido() == null ? usr.getApellido() : user.getApellido();
                String descripcion = user.getDescripcion() == null ? usr.getDescripcion() : user.getDescripcion();
                String email = user.getEmail() == null ? usr.getEmail() : user.getEmail();
                
                String password = user.getClave() == null ? usr.getClave() : bCryptPasswordEncoder.encode(user.getClave());
                usr.setNombre(firstName);
                usr.setApellido(lastName);
                usr.setEmail(email);
                usr.setClave(password);
                usr.setDescripcion(descripcion);
                // modificacion del rol
                if(user.getNombreRol() != null) {
                	Rol rol = rolRepository.findByName(user.getNombreRol());
                	if(rol != null) {
                		usr.setRolId(rol);
                	} 
                }
            }
            return userRepository.save(usr);
        } else {
            String userNotFoundMsg = messageSource.getMessage("user.not.found", new Object[]{"User"}, Locale.US);
            throw new RuntimeException(userNotFoundMsg);
        }

    }

}
