package itc.cse.suhyeon.suhyeon_portfolio.member.controller;


import itc.cse.suhyeon.suhyeon_portfolio.common.exception.CustomException;
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
    public ResponseEntity<?> login(@RequestBody MemberLoginDto member) {
        try {
            String email = member.getEmail();
            String password = member.getPassword();
            JwtToken jwtToken = memberService.login(email, password);
            return ResponseEntity.ok(jwtToken);
        } catch (CustomException e) {
            // CustomException을 처리
            return ResponseEntity.status(e.getStatus()).body(e.getMessage());
        } catch (IllegalArgumentException e) {
            // 기타 예외 처리
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("잘못된 요청입니다.");
        } catch (Exception e) {
            // 예상치 못한 서버 오류 처리
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버에 문제가 발생했습니다.");
        }
    }




//    @PostMapping("/login")
//    public ResponseEntity<?> login() {
//
//    }
}
