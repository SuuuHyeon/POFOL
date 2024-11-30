package itc.cse.suhyeon.suhyeon_portfolio.config;


import itc.cse.suhyeon.suhyeon_portfolio.jwt.JwtAuthenticationFilter;
import itc.cse.suhyeon.suhyeon_portfolio.jwt.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtTokenProvider jwtTokenProvider;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//        http.formLogin(form -> form
//                .usernameParameter("email")
//                .passwordParameter("password")
//                .permitAll()
//        );

        http.authorizeHttpRequests(request -> request
                .requestMatchers("/css/**", "/images/**").permitAll()
                .requestMatchers("/", "/api/member/**").permitAll()
                .requestMatchers("/api/portfolio/**").hasRole("USER")
                .anyRequest().authenticated()
        );

        http
                .csrf(AbstractHttpConfigurer::disable)
                .addFilterBefore(new JwtAuthenticationFilter(jwtTokenProvider), UsernamePasswordAuthenticationFilter.class);
//                .httpBasic(AbstractHttpConfigurer::disable)
//                // jwt 사용하니까 세션 사용 X
//                .sessionManagement((auth) -> auth.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
//                .csrf(AbstractHttpConfigurer::disable)

                // UsernamePasswordAuthenticationFilter 앞에 추가하여 JWT 인증을 처리


        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}


