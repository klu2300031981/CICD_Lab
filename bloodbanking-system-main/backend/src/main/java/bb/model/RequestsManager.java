package bb.model;

import java.util.*;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import bb.rep.RequestsRepository;
import bb.rep.DonorsRepository;

@Service
public class RequestsManager 
{
    @Autowired
    RequestsRepository RR;
    @Autowired
    DonorsRepository DR;

    private static final List<String> BLOOD_GROUPS = Arrays.asList(
        "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"
    );

    // Insert new request
    public String insertrequest(Requests R) {
        try {
            if (isAvailable(R.getBloodgroup(), R.getRhfactor())) {
                R.setStatus("accepted");
                consumeUnit(R.getBloodgroup(), R.getRhfactor());
            } else {
                R.setStatus("pending");
            }
            RR.save(R);
            return "200::New Request Added Successfully (" + R.getStatus() + ")";
        } catch (Exception e) {
            return "401::" + e.getMessage();
        }
    }

    public String readrequest() {
        try {
            List<Requests> requestList = RR.findAll();
            return new GsonBuilder().create().toJson(requestList);
        } catch (Exception e) {
            return "401::" + e.getMessage();
        }
    }

    public String getRequestDetailsbyId(Long id) {
        try {
            Requests R = RR.findById(id).orElse(null);
            return new GsonBuilder().create().toJson(R);
        } catch (Exception e) {
            return "401::" + e.getMessage();
        }
    }

    public String updaterequest(Requests R) {
        try {
            if (R.getStatus().equals("pending") && isAvailable(R.getBloodgroup(), R.getRhfactor())) {
                R.setStatus("accepted");
                consumeUnit(R.getBloodgroup(), R.getRhfactor());
            }
            RR.save(R);
            return "200::Request details updated (" + R.getStatus() + ")";
        } catch (Exception e) {
            return "401::" + e.getMessage();
        }
    }

    public String deleterequest(Long id) {
        try {
            RR.deleteById(id);
            return "200::Request deleted successfully";
        } catch (Exception e) {
            return "401::" + e.getMessage();
        }
    }

    public String acceptRequest(Long id) {
        try {
            Requests R = RR.findById(id).orElseThrow();
            if (R.getStatus().equals("pending") && isAvailable(R.getBloodgroup(), R.getRhfactor())) {
                R.setStatus("accepted");
                consumeUnit(R.getBloodgroup(), R.getRhfactor());
                RR.save(R);
                return "200::Request Accepted";
            }
            return "200::Request already accepted or insufficient inventory";
        } catch (Exception e) {
            return "401::" + e.getMessage();
        }
    }

    // Inventory = Donors - Accepted Requests
    public String getInventory() {
        try {
            List<Donors> donors = DR.findAll();
            Map<String, Long> donorInventory = donors.stream()
                    .collect(Collectors.groupingBy(
                            d -> d.getBloodgroup() + d.getRhfactor(),
                            Collectors.counting()));

            List<Requests> acceptedRequests = RR.findAll().stream()
                    .filter(r -> r.getStatus().equals("accepted"))
                    .collect(Collectors.toList());

            Map<String, Long> acceptedCount = acceptedRequests.stream()
                    .collect(Collectors.groupingBy(
                            r -> r.getBloodgroup() + r.getRhfactor(),
                            Collectors.counting()));

            // Adjust inventory = donors - requests
            for (String key : acceptedCount.keySet()) {
                donorInventory.put(key, donorInventory.getOrDefault(key, 0L) - acceptedCount.get(key));
            }

            // Final inventory map with all 8 groups
            Map<String, Long> finalInventory = new LinkedHashMap<>();
            for (String bg : BLOOD_GROUPS) {
                finalInventory.put(bg, donorInventory.getOrDefault(bg, 0L));
            }

            Gson gson = new GsonBuilder().setPrettyPrinting().create();
            return gson.toJson(finalInventory);

        } catch (Exception e) {
            return "401::" + e.getMessage();
        }
    }

    // Helpers
    private boolean isAvailable(String bloodgroup, String rhfactor) {
        String key = bloodgroup + rhfactor;
        String json = getInventory();
        if (json.startsWith("401::")) return false;
        Map<String, Double> inv = new Gson().fromJson(json, Map.class);
        return inv.getOrDefault(key, 0.0) > 0;
    }

    private void consumeUnit(String bloodgroup, String rhfactor) {
        // Logical only – inventory auto-adjusts when request is accepted
    }
}
