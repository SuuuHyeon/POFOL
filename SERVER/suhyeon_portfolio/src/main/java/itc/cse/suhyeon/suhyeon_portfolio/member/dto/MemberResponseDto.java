package itc.cse.suhyeon.suhyeon_portfolio.member.dto;

import itc.cse.suhyeon.suhyeon_portfolio.member.constant.Tier;
import itc.cse.suhyeon.suhyeon_portfolio.member.entity.Member;
import lombok.*;
import org.modelmapper.ModelMapper;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberResponseDto {

        private Long id;

        private String email;

        private String name;

        private String position;

        private Tier tier;

        private static ModelMapper modelMapper = new ModelMapper();

        public static MemberResponseDto toDto(Member member) {
            return modelMapper.map(member, MemberResponseDto.class);
        }
}
