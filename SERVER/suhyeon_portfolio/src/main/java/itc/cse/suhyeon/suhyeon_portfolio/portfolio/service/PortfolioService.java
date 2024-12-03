package itc.cse.suhyeon.suhyeon_portfolio.portfolio.service;


import itc.cse.suhyeon.suhyeon_portfolio.jwt.JwtTokenProvider;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.dto.PortfolioDto;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.dto.PortfolioResponseDto;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.Portfolio;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.PortfolioFile;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.repository.PortfolioRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class PortfolioService {

    final PortfolioFileService portfolioFileService;
    final PortfolioRepository portfolioRepository;
    final JwtTokenProvider jwtTokenProvider;

    // 포트폴리오 저장
    public Portfolio savePortfolio(PortfolioDto portfolioDto) {
        try {
            MultipartFile file = portfolioDto.getFile();
            // 파일 저장
            PortfolioFile portfolioFile = portfolioFileService.saveFile(file);

            // 포트폴리오에 파일 세팅 후 저장
            Portfolio portfolio = portfolioDto.createPortfolio();
            portfolio.setPortfolioFile(portfolioFile);

            return portfolioRepository.save(portfolio);
        } catch (Exception e) {
            log.info("포트폴리오 저장 실패");
            return null;
        }
    }

    // 포트폴리오 리스트 조회(생선한 사람 {email 값}으로 조회)
    public List<PortfolioResponseDto> findAllPortfolioList(String accessToken) {
        // getAuthentication 메서드로 인증정보를 가져오기
        Authentication authentication = jwtTokenProvider.getAuthentication(accessToken);
        // 인증정보에서 email 값 추출
        String email = authentication.getName();
        log.info("(service)인증정보 email: " + email);

        // email 값으로 내가 작성한 포트폴리오 리스트 조회
        List<PortfolioResponseDto> portfolioResponseDtoList = new ArrayList<>();
        List<Portfolio> portfolioList = portfolioRepository.findAllByCreatedBy(email); // jpql 사용
        for (Portfolio portfolio : portfolioList) {
            PortfolioResponseDto portfolioResponseDto = PortfolioResponseDto.builder()
                    // id는 앱에서 삭제할 때 사용하기 위해 같이 날려주기
                    .id(portfolio.getId())
                    .title(portfolio.getTitle())
                    .description(portfolio.getDescription())
                    .fileUrl(portfolio.getPortfolioFile().getSavedPath())
                    .build();
            portfolioResponseDtoList.add(portfolioResponseDto);
            log.info("===========" + portfolioResponseDto.toString());
        }
        return portfolioResponseDtoList;
    }

    // 포트폴리오 삭제
    public void deletePortfolio(Long portfolioId) {
        Portfolio portfolio = portfolioRepository.findById(portfolioId).orElseThrow(() -> new EntityNotFoundException("해당 포트폴리오가 존재하지 않습니다."));
        String filePath = portfolio.getPortfolioFile().getSavedPath();
        if (filePath != null && !filePath.isEmpty()) {
            // 파일 삭제
            portfolioFileService.deleteFile(filePath);
        }
        portfolioRepository.deleteById(portfolioId);
    }

}
