package itc.cse.suhyeon.suhyeon_portfolio.portfolio.repository;

import itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity.Portfolio;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PortfolioRepository extends JpaRepository<Portfolio, Long> {
}
