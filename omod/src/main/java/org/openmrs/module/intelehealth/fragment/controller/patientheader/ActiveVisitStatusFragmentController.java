package org.openmrs.module.intelehealth.fragment.controller.patientheader;

import org.openmrs.Location;
import org.openmrs.Patient;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.coreapps.utils.VisitTypeHelper;
import org.openmrs.module.emrapi.adt.AdtService;
import org.openmrs.module.emrapi.patient.PatientDomainWrapper;
import org.openmrs.module.emrapi.visit.VisitDomainWrapper;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.FragmentParam;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;

public class ActiveVisitStatusFragmentController {

	public void controller(FragmentConfiguration config,
			@FragmentParam("patient") PatientDomainWrapper pdw,
			@SpringBean("adtService") AdtService adtService,
			@SpringBean("visitTypeHelper") VisitTypeHelper visitTypeHelper,
			UiSessionContext sessionContext, UiUtils uiUtils, FragmentModel model) {

		config.addAttribute("activeVisitStartDatetime", null);

		Patient patient = pdw.getPatient();

		VisitDomainWrapper activeVisit = (VisitDomainWrapper) config.getAttribute("activeVisit");
		if (activeVisit == null) {
			try {
				Location visitLocation = adtService.getLocationThatSupportsVisits(sessionContext.getSessionLocation());
				activeVisit = adtService.getActiveVisit(patient, visitLocation);
			} catch (IllegalArgumentException ex) {
				// location does not support visits
			}
		}
		if (activeVisit != null) {
			config.addAttribute("activeVisit", activeVisit);
			config.addAttribute("activeVisitStartDatetime", uiUtils.format(activeVisit.getStartDatetime()));
			config.addAttribute("showVisitTypeOnPatientHeaderSection", visitTypeHelper.showVisitTypeOnPatientHeaderSection());

			String color = "";
			if(activeVisit != null){
				color = (String) visitTypeHelper.getVisitTypeColorAndShortName(
						activeVisit.getVisit().getVisitType()).get("color");
			}

			model.addAttribute("visitAttributeColor", color);
		}

	}

}
