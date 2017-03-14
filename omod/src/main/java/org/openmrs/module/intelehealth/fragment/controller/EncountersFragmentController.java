package org.openmrs.module.intelehealth.fragment.controller;
 
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Patient;
import org.openmrs.api.EncounterService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.FragmentParam;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;
 
import java.util.Calendar;
import java.util.Date;
import java.util.List;
 
public class EncountersFragmentController {
 
    private Date defaultStartDate() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        return cal.getTime();
    }
 
    private Date defaultEndDate(Date startDate) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(startDate);
        cal.add(Calendar.DAY_OF_MONTH, 1);
        cal.add(Calendar.MILLISECOND, -1);
        return cal.getTime();
    }
 
    public void controller(FragmentModel model,
                           @SpringBean("encounterService") EncounterService service,
                           @FragmentParam(value="patient", required=true) Patient patient,
                           @FragmentParam(value="encountertype", required=false) List<EncounterType> encountertype,
                           @FragmentParam(value="start", required=false) Date startDate,
                           @FragmentParam(value="end", required=false) Date endDate) {
 
        if (startDate == null)
            startDate = defaultStartDate();
        if (endDate == null)
            endDate = defaultEndDate(startDate);
//        if (encountertype == null)
//             List<EncounterType> encountertype = findEncounterTypes("Visit Note");
 
        model.addAttribute("encounters", service.getEncounters(patient, null, startDate, endDate, null, encountertype, null, false));
    }
 
    public List<SimpleObject> getEncounters(@RequestParam(value="start", required=false) Date startDate,
                                            @RequestParam(value="end", required=false) Date endDate,
                           		    @RequestParam(value="patient", required=true) Patient patient,
                                            @RequestParam(value="encountertype", required=false) List<EncounterType> encountertype,
                                            @RequestParam(value="properties", required=false) String[] properties,
                                            @SpringBean("encounterService") EncounterService service,
                                            UiUtils ui) {
 
        if (startDate == null)
            startDate = defaultStartDate();
        if (endDate == null)
            endDate = defaultEndDate(startDate);
  //      if (encountertype == null)
  //           List<EncounterType> encountertype = findEncounterTypes("Visit Note");
 
        if (properties == null) {
            properties = new String[] {"uuid", "patient", "encounterType", "encounterDatetime", "location", "provider" };
        }
 
        List<Encounter> encs = service.getEncounters(patient, null, startDate, endDate, null, encountertype, null, false);
        return SimpleObject.fromCollection(encs, ui, properties);
    }
 
}
