package itc.cse.suhyeon.suhyeon_portfolio.portfolio.entity;

import itc.cse.suhyeon.suhyeon_portfolio.common.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity

public class Portfolio extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "portfolio_id")
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String description;

    @ElementCollection
    @CollectionTable(name = "tech_list", joinColumns = @JoinColumn(name = "portfolio_id"))
    @Column(name = "tech_name_list")
    private List<String> techList;

    @OneToOne(orphanRemoval = true, cascade = CascadeType.ALL)
    @JoinColumn(name = "file_id")
    private PortfolioFile portfolioFile;


    public void updatePortfolio(String title, String description, List<String> techList, PortfolioFile file) {
        this.title = title;
        this.description = description;
        this.portfolioFile = file;
        this.techList = techList;
    }
}
