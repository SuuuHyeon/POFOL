package itc.cse.suhyeon.suhyeon_portfolio.member.service;

import itc.cse.suhyeon.suhyeon_portfolio.member.dto.MemberDto;
import itc.cse.suhyeon.suhyeon_portfolio.member.entity.Member;
import itc.cse.suhyeon.suhyeon_portfolio.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class MemberService {

    final MemberRepository memberRepository;
    final PasswordEncoder passwordEncoder; // SecurityConfig 클래스에 passwordEncoder() 빈으로 지정해줘야함

    // 회원가입
    public void register(MemberDto memberDto) {
        Optional<Member> member = memberRepository.findByEmail(memberDto.getEmail());
        if (member.isPresent()) {
            throw new IllegalStateException("이미 존재하는 회원입니다.");
        } else {
            Member newMember = Member.createMember(memberDto, passwordEncoder);
            memberRepository.save(newMember);
        }
    }

    // 로그인
    public void login(String email, String password) {
        Optional<Member> member = memberRepository.findByEmail(email);
        if(member.isPresent()) {
            if (passwordEncoder.matches(password, member.get().getPassword())) {
                log.info("로그인 성공");
            } else {
                throw new IllegalStateException("비밀번호가 일치하지 않습니다.");
            }
        } else {
            throw new IllegalStateException("존재하지 않는 회원입니다.");
        }

    }

}
