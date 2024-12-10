package itc.cse.suhyeon.suhyeon_portfolio.portfolio.dto;


import com.fasterxml.jackson.annotation.JsonFormat;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.Portfolio;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.modelmapper.ModelMapper;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@ToString
@Builder
public class PortfolioResponseDto {

    private Long id;
    private String title;
    private String description;
    private List<String> techList;
    private String fileUrl;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul") // 날짜 형식 지정
    private LocalDateTime updatedTime;

    private static ModelMapper modelMapper =new ModelMapper();

}