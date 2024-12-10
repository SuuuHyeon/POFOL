package itc.cse.suhyeon.suhyeon_portfolio.portfolio.repository;

import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.Portfolio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface PortfolioRepository extends JpaRepository<Portfolio, Long> {

    // email로 등록한 포트폴리오 리스트 조회 (최신순)
    @Query("SELECT p FROM Portfolio p WHERE p.createdBy = :email ORDER BY p.updateTime DESC")
    List<Portfolio> findAllByOrderByCreatedBy(String email);
}
