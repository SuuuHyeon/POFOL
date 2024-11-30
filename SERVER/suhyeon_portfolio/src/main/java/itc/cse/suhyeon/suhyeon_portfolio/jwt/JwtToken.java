package itc.cse.suhyeon.suhyeon_portfolio.jwt;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Builder
public class JwtToken {

    private String accessToken;
    private String refreshToken;
}
