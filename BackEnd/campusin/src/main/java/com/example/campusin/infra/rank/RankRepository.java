package com.example.campusin.infra.rank;

import com.example.campusin.domain.rank.Rank;
import com.example.campusin.domain.rank.dto.response.RankResponse;
import com.example.campusin.domain.statistics.Statistics;
import com.example.campusin.domain.studygroup.StudyGroup;
import com.example.campusin.domain.user.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;


@Repository
public interface RankRepository extends JpaRepository<Rank, Long> {
    @Query(value = "SELECT r FROM Rank r " +
            "WHERE r.studyGroup.id != null " +
            "AND r.statistics.date = :localDate " +
            "ORDER BY r.totalElapsedTime DESC")
    Page<Rank> countInStudyGroup(@Param("localDate") LocalDate localDate, Pageable pageable);

<<<<<<< Updated upstream
    @Query(value = "select r from Rank r where r.user = :user and r.statistics = :statistics and r.studyGroup.id = null")
    Rank findByUserAndStatistics(User user, Statistics statistics);
=======
    @Query(value = "select r from Rank r where r.user = :user and r.statistics = :statistics")
    Rank findByUserAndStatistics(@Param("user") User user, @Param("statistics") Statistics statistics);
>>>>>>> Stashed changes

    @Query(value = "select r from Rank r where r.user = :user and r.statistics = :statistics and r.studyGroup.id = :studyGroupId")
    Rank findByUserAndStatisticsAndStudyGroup(@Param("user") User user, @Param("statistics") Statistics statistics, @Param("studyGroupId") Long studyGroupId);
    @Query(value = "SELECT r FROM Rank r " +
            "WHERE r.studyGroup.id = null " +
            "AND r.statistics.date = :localDate " +
            "ORDER BY r.totalElapsedTime DESC")
    Page<Rank> findAllByOrderByTotalStudyTimeAsc(@Param("localDate") LocalDate localDate, Pageable pageable);

    @Query(value = "SELECT r FROM Rank r " +
            "WHERE r.studyGroup.id = null " +
            "AND r.statistics.date = :localDate " +
            "ORDER BY r.totalNumberOfQuestions DESC")
    Page<Rank> findAllByOrderByTotalNumberOfQuestionsAsc(@Param("localDate") LocalDate localDate,Pageable pageable);
}
