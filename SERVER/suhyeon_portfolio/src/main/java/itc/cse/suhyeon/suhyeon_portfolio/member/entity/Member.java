package itc.cse.suhyeon.suhyeon_portfolio.member.entity;

import itc.cse.suhyeon.suhyeon_portfolio.common.entity.BaseEntity;
import itc.cse.suhyeon.suhyeon_portfolio.member.constant.Tier;
import itc.cse.suhyeon.suhyeon_portfolio.member.dto.MemberDto;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.security.crypto.password.PasswordEncoder;

@Entity
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Member extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String email;

    private String name;

    private String password;

    private String position;

    @Enumerated(EnumType.STRING)
    private Tier tier;

    public static Member createMember(MemberDto memberDto, PasswordEncoder passwordEncoder) {
        return Member.builder()
                .name(memberDto.getName())
                .email(memberDto.getEmail())
                .password(passwordEncoder.encode(memberDto.getPassword()))
                .position(memberDto.getPosition())
                .tier(Tier.SILVER)
                .build();
    }
}
