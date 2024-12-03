package itc.cse.suhyeon.suhyeon_portfolio.portfolio.service;

import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.Portfolio;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.PortfolioFile;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.repository.PortfolioFileRepository;
import itc.cse.suhyeon.suhyeon_portfolio.portfolio.repository.PortfolioRepository;
import jakarta.persistence.EntityNotFoundException;
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

    private final PortfolioRepository portfolioRepository;
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

        PortfolioFile portfolioFile = PortfolioFile.builder()
                .orgNm(originalFileName)
                .savedNm(savedFileName)
                .savedPath(fileUrl)
                .build();

        // 경로에 파일 저장
        file.transferTo(new File(fileUploadFullPath));

        // db에 파일 저장
        portfolioFileRepository.save(portfolioFile);
        return portfolioFile;
    }

    // 파일 삭제
    public void deleteFile(String filePath) {
        // 실제 경로로 변환
        String fileUploadFullPath = fileLocation + filePath.replace("/images/portfolio/", "/");
        File deleteFile = new File(fileUploadFullPath);
        if (deleteFile.exists()) {
            if (deleteFile.delete()) {
                log.info("========== 파일 삭제 성공 ==========");
            } else {
                log.info("========== 파일 삭제 실패 ==========");
            }
        } else {
            log.info(filePath + "파일이 존재하지 않습니다.");
        }
    }
}
