package com.orktek.quebragalho.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.orktek.quebragalho.model.Tag;

@Repository
public interface TagRepository extends JpaRepository<Tag, Long> {
    
}
