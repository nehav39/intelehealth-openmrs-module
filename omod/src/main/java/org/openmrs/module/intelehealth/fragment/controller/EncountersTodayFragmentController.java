package org.openmrs.module.intelehealth.fragment.controller;
 
import org.openmrs.Encounter;
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
 
public class EncountersTodayFragmentController {
 
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
                           @FragmentParam(value="start", required=false) Date startDate,
                           @FragmentParam(value="end", required=false) Date endDate) {
 
        if (startDate == null)
            startDate = defaultStartDate();
        if (endDate == null)
            endDate = defaultEndDate(startDate);
 
        model.addAttribute("encounters", service.getEncounters(null, null, startDate, endDate, null, null, null, false));
    }
 
    public List<SimpleObject> getEncounters(@RequestParam(value="start", required=false) Date startDate,
                                            @RequestParam(value="end", required=false) Date endDate,
                                            @RequestParam(value="properties", required=false) String[] properties,
                                            @SpringBean("encounterService") EncounterService service,
                                            UiUtils ui) {
 
        if (startDate == null)
            startDate = defaultStartDate();
        if (endDate == null)
            endDate = defaultEndDate(startDate);
 
        if (properties == null) {
            properties = new String[] { "encounterType", "encounterDatetime", "location", "provider" };
        }
 
        List<Encounter> encs = service.getEncounters(null, null, startDate, endDate, null, null, null, false);
        return SimpleObject.fromCollection(encs, ui, properties);
    }
 
}
