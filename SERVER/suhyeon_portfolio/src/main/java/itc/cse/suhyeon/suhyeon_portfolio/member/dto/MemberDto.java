package itc.cse.suhyeon.suhyeon_portfolio.member.dto;

import itc.cse.suhyeon.suhyeon_portfolio.member.constant.Tier;
import itc.cse.suhyeon.suhyeon_portfolio.member.entity.Member;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberDto {

    private String email;

    private String name;

    private String password;

    private String position;

}
