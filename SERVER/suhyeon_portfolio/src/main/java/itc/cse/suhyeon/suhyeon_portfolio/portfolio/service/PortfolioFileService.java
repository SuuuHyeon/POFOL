package itc.cse.suhyeon.suhyeon_portfolio.portfolio.service;

import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.Portfolio;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.PortfolioFile;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.repository.PortfolioFileRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class PortfolioFileService {

    @Value(value = "${fileLocation}")
    private String fileLocation;

    final PortfolioFileRepository portfolioFileRepository;

    public PortfolioFile saveFile(MultipartFile file) throws IOException {
        UUID uuid = UUID.randomUUID();
        String originalFileName = file.getOriginalFilename();
        String ext = originalFileName.substring(originalFileName.lastIndexOf("."), originalFileName.length());
        String savedFileName = uuid.toString() + ext;
        String fileUploadFullPath = fileLocation + "/" + savedFileName;

        String fileUrl = "/images/portfolio/" + savedFileName; // portfolioFile의 fileUrl값

//        log.info("========= 파일 정보 =========");
//        log.info(originalFileName);
//        log.info(ext);
//        log.info(savedFileName);
//        log.info(fileUploadFullPath);

        PortfolioFile portfolioFile = PortfolioFile.builder()
                .orgNm(originalFileName)
                .savedNm(savedFileName)
                .savedPath(fileUrl)
                .build();

        // 파일 저장
        file.transferTo(new File(fileUploadFullPath));

        portfolioFileRepository.save(portfolioFile);
        return portfolioFile;
    }
}
