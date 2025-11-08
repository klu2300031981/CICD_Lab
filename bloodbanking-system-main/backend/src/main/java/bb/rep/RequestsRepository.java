package bb.rep;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import bb.model.Requests;

@Repository
public interface RequestsRepository extends JpaRepository<Requests, Long> {

    @Query("SELECT r FROM Requests r WHERE r.status = 'pending'")
    List<Requests> findPendingRequests();

    @Query("SELECT r FROM Requests r WHERE r.bloodgroup = ?1 AND r.rhfactor = ?2 AND r.status = 'accepted'")
    List<Requests> findAcceptedByGroup(String bloodgroup, String rhfactor);
}
