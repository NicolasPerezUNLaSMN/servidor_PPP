package com.unla.ppp.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.annotations.Where;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.Collection;

@Entity
@Table(name = "users")
@SQLDelete(sql = "UPDATE users SET deleted=true WHERE id = ?")
@Where(clause = "deleted = false")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Data
public class Usuario implements UserDetails{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
    @NotNull(message = "El nombre no puede estar vacio")
    private String nombre;

    @NotNull(message = "El apellido no puede estar vacio")
    private String apellido;

    @NotNull(message = "El email no puede estar vacio")
    @Email(message = "Not valid email.")
    @Column(unique = true)
    private String email;

    @NotNull(message = "La clave no puede estar vacia")
    private String clave;
    
    private String descripcion;

    @JoinColumn(name = "roles", referencedColumnName = "id")
    @ManyToOne
    private Rol rolId;

    @UpdateTimestamp
    private LocalDateTime createdAt;

    @NotNull(message = "Deleted can not be empty")
    private Boolean deleted = Boolean.FALSE;

	public Usuario(String nombre,String apellido,String email, String descripcion,String clave) {
		super();
		this.nombre = nombre;
		this.apellido = apellido;
		this.email = email;
		this.clave = clave;
		this.descripcion = descripcion;
	}
	
	public Usuario(String nombre,String apellido,String email, String clave,String descripcion, Rol rol) {
		super();
		this.nombre = nombre;
		this.apellido = apellido;
		this.email = email;
		this.clave = clave;
		this.descripcion = descripcion;
		this.rolId = rol;
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getPassword() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getUsername() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean isAccountNonExpired() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean isAccountNonLocked() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean isEnabled() {
		// TODO Auto-generated method stub
		return false;
	}


}