package com.unla.ppp.util.dataseed;

import java.util.ArrayList;
import java.util.List;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

import com.unla.ppp.model.Rol;
import com.unla.ppp.model.Usuario;
import com.unla.ppp.repository.RolRepository;
import com.unla.ppp.repository.UsuarioRepository;
import com.unla.ppp.util.ERol;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RequiredArgsConstructor
public class DataSeedUsuarios {
	private final RolRepository roleRepository;
	private final UsuarioRepository userRepository;
	private final BCryptPasswordEncoder passwordEncoder;
	
	private boolean userDataIsEmpty() {
		return userRepository.count() == 0;
	}
	
	public void loadData() {
		if (userDataIsEmpty()) {
			makeAdminUsers();
			makeRegularUsers();
			makeRelevadoresUsers();
		} else
			log.info("Users data is not empty");
		
	}
	
	private Rol getRole(ERol roleEnum) {
		Rol role = roleRepository.findByName(roleEnum.name());
		if (role == null) {
			role = new Rol();
			role.setName(roleEnum.name());
			role = roleRepository.save(role);
		}
		return role;
	}

	
	private void makeAdminUsers() {
		Rol role = getRole(ERol.ROL_ADMIN);
		List<Usuario> listaUsuarios = new ArrayList<Usuario>() {
			/**
			 * 
			 */
			private static final long serialVersionUID = 1L;

			{
				add(new Usuario("Guille","Alegre","admin01@email.com",passwordEncoder.encode("secreto"),"Coordinador General de Proyecto.",role));
				add(new Usuario("Leandro","Parietti","admin02@email.com",passwordEncoder.encode("secreto"),"Coordinador del trabajo de campo y cumplimiento de Salvaguardas "
						+ "ambientales y sociales.",role));
				add(new Usuario("Jorge","Montenegro","admin03@email.com",passwordEncoder.encode("secreto"),"Coordinador AMBA",role));
				add(new Usuario("Nehuen","Nuciforo","admin04@email.com",passwordEncoder.encode("secreto"),"Responsable de elegibilidad de gastos/ certificados de los planes de obra",role));
				add(new Usuario("Federico Marco","Chalimoniuk","admin05@email.com",passwordEncoder.encode("secreto"),"Responsable de procesamiento de información",role));
				add(new Usuario("Malena","Blanco","admin06@email.com",passwordEncoder.encode("secreto"),"Técnico/a supervisor de plan de obras",role));
				add(new Usuario("Santiago","Goyer","admin07@email.com",passwordEncoder.encode("secreto"),"Unla",role));
				add(new Usuario("Sisu","Sisu","admin08@email.com",passwordEncoder.encode("secreto"),"",role));
				add(new Usuario("Programador","Admin","admin_programador@email.com",passwordEncoder.encode("secretoProgramador"),"Encargado de desarrollar la aplicacion.",role));
			}
		};
		saveUsers(listaUsuarios);
	}
	
	private void makeRegularUsers() {
		Rol role = getRole(ERol.ROL_USER);
		List<Usuario> listaUsuarios = new ArrayList<Usuario>() {
			/**
			 * 
			 */
			private static final long serialVersionUID = 1L;

			{
				add(new Usuario("NombreUsuario","Apellido","usuario01@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario02@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario03@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario04@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario05@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario06@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario07@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario08@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario09@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario10@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario11@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario12@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario13@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario14@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario15@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario16@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario17@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario18@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario19@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario20@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
				add(new Usuario("NombreUsuario","Apellido","usuario21@email.com",passwordEncoder.encode("secreto"),"Usuario",role));
			}
		};
		saveUsers(listaUsuarios);
	}
	
	private void makeRelevadoresUsers() {
		Rol role = getRole(ERol.ROL_RELEVADOR);
		List<Usuario> listaUsuarios = new ArrayList<Usuario>() {
			/**
			 * 
			 */
			private static final long serialVersionUID = 1L;

			{
				add(new Usuario("Liber","Fernandes Hermosí","relevador01@email.com",passwordEncoder.encode(passwordEncoder.encode("secreto")),"Relevador",role));
				add(new Usuario("Mailen","Apellido","relevador02@email.com",passwordEncoder.encode("secreto"),"Relevador",role));
				add(new Usuario("Nombre","Apellido","relevador03@email.com",passwordEncoder.encode("secreto"),"Relevador",role));
				add(new Usuario("Nombre","Apellido","relevador04@email.com",passwordEncoder.encode("secreto"),"Relevador",role));
				add(new Usuario("Nombre","Apellido","relevador05@email.com",passwordEncoder.encode("secreto"),"Relevador",role));
				add(new Usuario("Nombre","Apellido","relevador06@email.com",passwordEncoder.encode("secreto"),"Relevador",role));
				add(new Usuario("Nombre","Apellido","relevador07@email.com",passwordEncoder.encode("secreto"),"Relevador",role));
				add(new Usuario("Nombre","Apellido","relevador08@email.com",passwordEncoder.encode("secreto"),"Relevador",role));
				add(new Usuario("Nombre","Apellido","relevador09@email.com",passwordEncoder.encode("secreto"),"Relevador",role));
			}
		};
		saveUsers(listaUsuarios);
	}
	
	private void saveUsers(List<Usuario> usuarios) {

		for(Usuario u : usuarios) {
			u = userRepository.save(u);
		}
	}
	
}
