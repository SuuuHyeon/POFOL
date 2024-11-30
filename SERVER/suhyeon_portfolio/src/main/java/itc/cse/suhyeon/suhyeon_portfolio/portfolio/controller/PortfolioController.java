package itc.cse.suhyeon.suhyeon_portfolio.portfolio.controller;


import itc.cse.suhyeon.suhyeon_portfolio.portfolio.dto.PortfolioDto;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.dto.PortfolioResponseDto;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.Portfolio;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.service.PortfolioService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/portfolio")
@RequiredArgsConstructor
public class PortfolioController {

    final PortfolioService portfolioService;

    @PostMapping("/upload")
    public ResponseEntity<?> uploadPortfolio(@ModelAttribute PortfolioDto dto) throws IOException {
        log.info("포트폴리오 컨트롤러 진입");
        log.info(dto.toString());
        try {
            Portfolio portfolio = portfolioService.savePortfolio(dto);
            return ResponseEntity.ok("파일 업로드 완료: " + portfolio.toString());
        } catch (Exception e) {
            log.info("업로드 실패");
            return ResponseEntity.status(500).body("파일 업로드 실패: " + e.getMessage());
        }
    }

    @PostMapping("/list")
    public ResponseEntity<List<PortfolioResponseDto>> getPortfolioList() {
        try {
            List<PortfolioResponseDto> allPortfolioList = portfolioService.findAllPortfolioList();
            log.info("포트폴리오 리스트: " + allPortfolioList.toString());
            return ResponseEntity.status(200).body(allPortfolioList);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }

    }
}
