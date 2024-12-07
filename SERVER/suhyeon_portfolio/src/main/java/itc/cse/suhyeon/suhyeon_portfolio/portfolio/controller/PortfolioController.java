package itc.cse.suhyeon.suhyeon_portfolio.portfolio.controller;


import itc.cse.suhyeon.suhyeon_portfolio.portfolio.dto.PortfolioDto;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.dto.PortfolioResponseDto;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.Portfolio;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.repository.PortfolioRepository;
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
    private final PortfolioRepository portfolioRepository;

    @PostMapping("/upload")
    public ResponseEntity<?> uploadPortfolio(@ModelAttribute PortfolioDto dto) {
        log.info("포트폴리오 컨트롤러 진입");
        log.info(dto.toString());
        try {
            portfolioService.savePortfolio(dto);
            return ResponseEntity.ok("파일 업로드 완료: ");
        } catch (Exception e) {
            log.info("업로드 실패");
            return ResponseEntity.status(500).body("파일 업로드 실패");
        }
    }

    // 내가 작성한 포트폴리오 리스트 조회(토큰으로 조회)
    @GetMapping("/list")
    public ResponseEntity<List<PortfolioResponseDto>> getPortfolioList(@RequestHeader("Authorization") String token) {
        try {
            String accessToken = token.substring(7);
            List<PortfolioResponseDto> allPortfolioList = portfolioService.findAllPortfolioList(accessToken);
            log.info("포트폴리오 리스트: " + allPortfolioList.toString());
            return ResponseEntity.status(200).body(allPortfolioList);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }

    }

    @PutMapping("/update/{portfolioId}")
    public ResponseEntity<?> updatePortfolio(@PathVariable Long portfolioId, @ModelAttribute PortfolioDto portfolioDto) {
        try {
            portfolioService.updatePortfolio(portfolioId, portfolioDto);
            return ResponseEntity.status(200).body("포트폴리오 수정 완료");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("포트폴리오 수정 실패");
        }

    }


    // 포트폴리오 삭제
    @DeleteMapping("/delete/{portfolioId}")
    public ResponseEntity<?> deletePortfolio(@PathVariable Long portfolioId) {
        try {
            portfolioService.deletePortfolio(portfolioId);
            return ResponseEntity.status(200).body("포트폴리오 삭제 완료");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("포트폴리오 삭제 실패");
        }
    }
}
