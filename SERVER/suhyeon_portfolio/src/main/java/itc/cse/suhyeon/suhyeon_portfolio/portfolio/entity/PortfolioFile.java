package itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity;


import itc.cse.suhyeon.suhyeon_portfolio.common.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PortfolioFile extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "file_id")
    private Long id;

    private String orgNm;
    private String savedNm;
    private String savedPath;

    @OneToOne(mappedBy = "portfolioFile")
    private Portfolio portfolio;

}
