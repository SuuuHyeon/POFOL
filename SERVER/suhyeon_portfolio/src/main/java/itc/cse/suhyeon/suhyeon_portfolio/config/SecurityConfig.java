package itc.cse.suhyeon.suhyeon_portfolio.config;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {

//        http.formLogin(form -> form
//                .loginPage("/api/member/login")
//                .defaultSuccessUrl("/") // ???
//                .usernameParameter("email")
//                .passwordParameter("password")
////                .failureUrl("/api/member/login")
//                .permitAll()
//        );

        http.authorizeHttpRequests(request -> request
                .requestMatchers("/css/**", "/images/**").permitAll()
                .requestMatchers("/", "/api/member/**").permitAll()
                .requestMatchers("/api/portfolio/**").permitAll()
                .anyRequest().authenticated()
        );


        http.csrf(AbstractHttpConfigurer::disable);



        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}


