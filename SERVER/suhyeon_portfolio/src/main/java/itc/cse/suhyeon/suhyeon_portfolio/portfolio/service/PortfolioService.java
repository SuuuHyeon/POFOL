package itc.cse.suhyeon.suhyeon_portfolio.portfolio.service;


import itc.cse.suhyeon.suhyeon_portfolio.portfolio.dto.PortfolioDto;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.dto.PortfolioResponseDto;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.Portfolio;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.PortfolioFile;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.repository.PortfolioRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
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


    public Portfolio savePortfolio(PortfolioDto portfolioDto) throws IOException {
        MultipartFile file = portfolioDto.getFile();
        PortfolioFile portfolioFile = portfolioFileService.saveFile(file);

        Portfolio portfolio = portfolioDto.createPortfolio();
        portfolio.setPortfolioFile(portfolioFile);
        portfolioRepository.save(portfolio);

        return portfolioRepository.save(portfolio);
    }

    public List<PortfolioResponseDto> findAllPortfolioList() {
        List<PortfolioResponseDto> portfolioResponseDtoList = new ArrayList<>();
        List<Portfolio> portfolioList = portfolioRepository.findAll();
        for (Portfolio portfolio : portfolioList) {
            PortfolioResponseDto portfolioResponseDto = PortfolioResponseDto.builder()
                    .title(portfolio.getTitle())
                    .description(portfolio.getDescription())
                    .fileUrl(portfolio.getPortfolioFile().getSavedPath())
                    .build();
            portfolioResponseDtoList.add(portfolioResponseDto);
            log.info("===========" + portfolioResponseDto.toString());
        }
        return portfolioResponseDtoList;
    }
}
