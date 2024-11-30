//package itc.cse.suhyeon.suhyeon_portfolio.config;
//
//import lombok.extern.slf4j.Slf4j;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.data.domain.AuditorAware;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.core.context.SecurityContextHolder;
//
//import java.util.Optional;
//
//@Slf4j
//public class AuditorAwareImpl implements AuditorAware<String> {
//
//    @Override
//    public Optional<String> getCurrentAuditor() {
//        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//        log.info("authentication getdetail()" +authentication.getDetails().toString());
//        String userId = "";
//
//        if (authentication != null) {
//            userId = authentication.getName();
//            log.info("인증 userId: " + userId);
//        }
//        return Optional.of(userId);
//    }
//}
