package com.unla.ppp.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import lombok.AllArgsConstructor;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.unla.ppp.util.ERol;

@Configuration
@AllArgsConstructor
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    private final BCryptPasswordEncoder bCryptPasswordEncoder;
    private final UserDetailsService userDetailsService;

    @Autowired
    private JwtRequestFilter jwtRequestFilter;

    @Override
    protected void configure(HttpSecurity http) throws Exception {

		http.csrf().disable();
    	http.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS);
        http.authorizeRequests()
    		.antMatchers("/auth/login/**","/api-docs/***","/swagger-ui/**","/","/api-docs").permitAll()
    		.antMatchers(HttpMethod.POST, "/auth/register").hasAnyAuthority(ERol.ROL_ADMIN.name())
    		.antMatchers(HttpMethod.POST, "/visita").hasAnyAuthority(ERol.ROL_ADMIN.name(), ERol.ROL_RELEVADOR.name())
    		.antMatchers(HttpMethod.POST, "/certificado").hasAnyAuthority(ERol.ROL_ADMIN.name(), ERol.ROL_RELEVADOR.name())
    		.antMatchers(HttpMethod.POST, "/vivienda").hasAnyAuthority(ERol.ROL_ADMIN.name())
    		.antMatchers(HttpMethod.PATCH, "/vivienda/**").hasAnyAuthority(ERol.ROL_ADMIN.name())
    		.antMatchers(HttpMethod.DELETE, "/vivienda").hasAnyAuthority(ERol.ROL_ADMIN.name())
    		.antMatchers(HttpMethod.POST, "/auth/register/**").hasAnyAuthority(ERol.ROL_ADMIN.name())
    		.antMatchers("/users/**").hasAnyAuthority(ERol.ROL_ADMIN.name())
    		.antMatchers(HttpMethod.POST, "/{id}/habitabilidad").hasAnyAuthority(ERol.ROL_ADMIN.name(), ERol.ROL_RELEVADOR.name())
    		.anyRequest().authenticated();
        http.addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class); //Add filters for JWT
    }

    @Override
    @Bean
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.authenticationProvider(daoAuthenticationProvider());
    }

    @Bean
    public DaoAuthenticationProvider daoAuthenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setPasswordEncoder(bCryptPasswordEncoder);
        provider.setUserDetailsService(userDetailsService);
        return provider;
    }
}
