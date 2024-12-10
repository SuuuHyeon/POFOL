package itc.cse.suhyeon.suhyeon_portfolio.portfolio.dto;


import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.Portfolio;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.modelmapper.ModelMapper;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Getter
@Setter
@ToString
public class PortfolioDto {

    private String title;
    private String description;
    private List<String> techList;
    private MultipartFile file;

    private static ModelMapper modelMapper =new ModelMapper();

    public Portfolio createPortfolio() {
        return modelMapper.map(this, Portfolio.class);
    }

    public PortfolioDto of(Portfolio portfolio) {
        return modelMapper.map(portfolio, PortfolioDto.class);
    }
}