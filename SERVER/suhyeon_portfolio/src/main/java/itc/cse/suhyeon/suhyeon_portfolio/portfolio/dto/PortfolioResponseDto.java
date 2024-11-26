package itc.cse.suhyeon.suhyeon_portfolio.portfolio.dto;


import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.Portfolio;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.modelmapper.ModelMapper;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Setter
@ToString
@Builder
public class PortfolioResponseDto {

    private String title;
    private String description;
    private String fileUrl;

    private static ModelMapper modelMapper =new ModelMapper();

}