package itc.cse.suhyeon.suhyeon_portfolio.member.controller;


import itc.cse.suhyeon.suhyeon_portfolio.jwt.JwtToken;
import itc.cse.suhyeon.suhyeon_portfolio.member.dto.MemberDto;
import itc.cse.suhyeon.suhyeon_portfolio.member.dto.MemberLoginDto;
import itc.cse.suhyeon.suhyeon_portfolio.member.dto.MemberResponseDto;
import itc.cse.suhyeon.suhyeon_portfolio.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/member")
@RequiredArgsConstructor
public class MemberController {

    final MemberService memberService;

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody MemberDto memberDto) {
        System.out.println("SignUp Dto = " + memberDto.toString());
        try {
            memberService.register(memberDto);
            return ResponseEntity.status(HttpStatus.OK).body("회원가입이 완료되었습니다.");
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage()); // 409
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("회원가입 중 오류가 발생했습니다.");
        }
    }

    @PostMapping("/me")
    public ResponseEntity<?> loadUserData(@RequestHeader("Authorization") String token) {
        try {
            String accessToken = token.substring(7);
            MemberResponseDto memberResponseDto = memberService.getMemberInfoByToken(accessToken);
            return ResponseEntity.status(HttpStatus.OK).body(memberResponseDto);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("회원정보를 불러오는 중 오류가 발생했습니다.");
        }
    }

    @PostMapping("/login")
    public JwtToken login(@RequestBody MemberLoginDto member) {
        String email = member.getEmail();
        String password = member.getPassword();
        JwtToken jwtToken = memberService.login(email, password);
        log.info(jwtToken.getAccessToken());
        log.info(jwtToken.getRefreshToken());

        return jwtToken;
    }


//    @PostMapping("/login")
//    public ResponseEntity<?> login() {
//
//    }
}
