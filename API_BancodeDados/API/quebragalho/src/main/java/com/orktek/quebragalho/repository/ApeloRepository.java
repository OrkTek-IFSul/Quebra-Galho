package com.orktek.quebragalho.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.orktek.quebragalho.model.Apelo;
import com.orktek.quebragalho.model.Denuncia;

@Repository
public interface ApeloRepository extends JpaRepository<Apelo, Long> {

    boolean existsByDenuncia(Denuncia denuncia);

    List<Apelo> findByStatus(boolean b);
    
}
