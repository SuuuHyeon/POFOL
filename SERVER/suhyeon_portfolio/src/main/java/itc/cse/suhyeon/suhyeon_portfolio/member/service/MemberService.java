package itc.cse.suhyeon.suhyeon_portfolio.member.service;

import itc.cse.suhyeon.suhyeon_portfolio.common.exception.CustomException;
import itc.cse.suhyeon.suhyeon_portfolio.jwt.JwtToken;
import itc.cse.suhyeon.suhyeon_portfolio.jwt.JwtTokenProvider;
import itc.cse.suhyeon.suhyeon_portfolio.member.dto.MemberDto;
import itc.cse.suhyeon.suhyeon_portfolio.member.dto.MemberResponseDto;
import itc.cse.suhyeon.suhyeon_portfolio.member.entity.Member;
import itc.cse.suhyeon.suhyeon_portfolio.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class MemberService {

    final MemberRepository memberRepository;
    final PasswordEncoder passwordEncoder; // SecurityConfig 클래스에 passwordEncoder() 빈으로 지정해줘야함
    final JwtTokenProvider jwtTokenProvider;
    private final AuthenticationManagerBuilder authenticationManagerBuilder;

    // 회원가입
    public void register(MemberDto memberDto) {
        Optional<Member> savedMember = memberRepository.findByEmail(memberDto.getEmail());
        if (savedMember.isPresent()) {
            throw new IllegalStateException("이미 존재하는 회원입니다.");
        }

        // 멤버 엔티티 생성
        Member member = Member.createMember(memberDto, passwordEncoder); // 권한, 티어 생성해둠

        memberRepository.save(member);
    }

    public JwtToken login(String email, String password) {
        System.out.println("로그인 서비스 시작");

        // 1. 아이디 검증
        Member member = memberRepository.findByEmail(email)
                .orElseThrow(() -> new CustomException("아이디가 존재하지 않습니다.", HttpStatus.NOT_FOUND));

        // 2. 비밀번호 검증
        if (!passwordEncoder.matches(password, member.getPassword())) {
            throw new CustomException("비밀번호가 틀렸습니다.", HttpStatus.UNAUTHORIZED);
        }

        // 3. 인증 성공 -> 토큰 생성
        UsernamePasswordAuthenticationToken authenticationToken =
                new UsernamePasswordAuthenticationToken(email, password);

        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);

        return jwtTokenProvider.generateToken(authentication);
    }



    public MemberResponseDto getMemberInfoByToken(String accessToken) {
        try {
            // 사용자 정보 가져오기
            Authentication authentication = jwtTokenProvider.getAuthentication(accessToken);
            // 가져온 정보로 이메일 추출 (getName에서 리턴값을 email로 해놓음)
            String memberEmail = authentication.getName();

            // 추출한 email로 member 찾기
            Optional<Member> member = memberRepository.findByEmail(memberEmail);

            if (member.isPresent()) {
                return MemberResponseDto.toDto(member.get());
            } else {
                throw new IllegalStateException("해당 유저를 찾을 수 없습니다.");
            }
        } catch(Exception e) {
            throw new IllegalStateException("유저 정보를 불러오는 중 오류가 발생했습니다.");
        }

    }
}
