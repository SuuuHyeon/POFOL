package itc.cse.suhyeon.suhyeon_portfolio.member.repository;

import itc.cse.suhyeon.suhyeon_portfolio.member.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, Long> {
    Optional<Member> findByEmail(String email);
}
