package com.orktek.quebragalho.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.orktek.quebragalho.model.Tags;
import java.util.List;
import java.util.Optional;

@Repository
public interface TagRepository extends JpaRepository<Tags, Long> {
    List<Tags> findByStatus(String status);
    Optional<Tags> findByNomeIgnoreCase(String nome);
}
