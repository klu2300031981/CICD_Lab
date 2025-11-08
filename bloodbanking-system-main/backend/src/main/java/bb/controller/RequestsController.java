package bb.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import bb.model.Requests;
import bb.model.RequestsManager;

@RestController
@RequestMapping("/requests")
@CrossOrigin(origins="*")
public class RequestsController 
{
    @Autowired
    RequestsManager RM;

    @PostMapping("/insert")
    public String insert(@RequestBody Requests R) {
        return RM.insertrequest(R);
    }

    @GetMapping("/readrequest")
    public String readrequest() {
        return RM.readrequest();
    }

    @GetMapping("/getrequest/{id}")
    public String getrequestbyid(@PathVariable("id") Long id) {
        return RM.getRequestDetailsbyId(id);
    }

    @PutMapping("/update")
    public String updaterequest(@RequestBody Requests R) {
        return RM.updaterequest(R);
    }

    @DeleteMapping("/delete/{id}")
    public String deleterequest(@PathVariable("id") Long id) {
        return RM.deleterequest(id);
    }

    @PutMapping("/accept/{id}")
    public String acceptRequest(@PathVariable("id") Long id) {
        return RM.acceptRequest(id);
    }

    @GetMapping("/inventory")
    public String getInventory() {
        return RM.getInventory();
    }
}
