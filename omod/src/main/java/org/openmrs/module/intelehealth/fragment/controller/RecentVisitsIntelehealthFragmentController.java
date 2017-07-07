/**
 * 
 */
package org.openmrs.module.intelehealth.fragment.controller;

import org.apache.commons.beanutils.PropertyUtils;
import org.openmrs.Location;
import org.openmrs.Order;
import org.openmrs.OrderType;
import org.openmrs.Patient;
import org.openmrs.Visit;
import org.openmrs.api.OrderService;
import org.openmrs.api.PatientService;
import org.openmrs.api.VisitService;
import org.openmrs.module.appframework.context.AppContextModel;
import org.openmrs.module.appframework.domain.AppDescriptor;
import org.openmrs.module.appframework.template.TemplateFactory;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.coreapps.CoreAppsProperties;
import org.openmrs.module.coreapps.contextmodel.PatientContextModel;
import org.openmrs.module.coreapps.contextmodel.VisitContextModel;
import org.openmrs.module.coreapps.utils.VisitTypeHelper;
import org.openmrs.module.emrapi.adt.AdtService;
import org.openmrs.module.emrapi.patient.PatientDomainWrapper;
import org.openmrs.module.emrapi.visit.VisitDomainWrapper;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.InjectBeans;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.openmrs.ui.framework.page.PageModel;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @author maitree.kuria
 *
 */
public class RecentVisitsIntelehealthFragmentController {

	public void controller(FragmentConfiguration config,
            @SpringBean("patientService") PatientService patientService,
            @SpringBean("visitService") VisitService visitService,
            FragmentModel model) throws Exception{
//		config.require("patient");
//		Object patient = config.get("patient");
		
		 config.require("patient|patientId");
	        Patient patient;
	        Object pt = config.getAttribute("patient");
	        if (pt == null) {
	            patient = patientService.getPatient((Integer) config.getAttribute("patientId"));
	        }
	        else {
	            // in case we are passed a PatientDomainWrapper (but this module doesn't know about emrapi)
	            patient = (Patient) (pt instanceof Patient ? pt : PropertyUtils.getProperty(pt, "patient"));
	        }

	        List<Visit> visitList = visitService.getVisitsByPatient(patient);
//	        OrderType drugOrders = orderService.getOrderTypeByUuid(OrderType.DRUG_ORDER_TYPE_UUID);
//	        List<Order> activeDrugOrders = orderService.getActiveOrders(patient, drugOrders, null, null);

	        model.addAttribute("patient", patient);
	        model.addAttribute("visitList", visitList);

//		if (patient instanceof Patient) {
//			patientWrapper.setPatient((Patient) patient);
//			config.addAttribute("patient", patientWrapper);
//		} else if (patient instanceof PatientDomainWrapper) {
//			patientWrapper = (PatientDomainWrapper) patient;
//		}
//
//		AppContextModel contextModel = sessionContext.generateAppContextModel();
//		contextModel.put("patient", new PatientContextModel(patientWrapper.getPatient()));
//		contextModel.put("patientId", patientWrapper.getPatient().getUuid()); // backwards-compatible
//																				// for
//																				// links
//																				// that
//																				// still
//																				// specify
//																				// patient
//																				// uuid
//																				// substitution
//																				// with
//																				// "{{patientId}}"
//
//		AppDescriptor app = (AppDescriptor) pageModel.get("app");
//
//		String visitsPageWithSpecificVisitUrl = null;
//		String visitsPageUrl = null;
//
//		System.out.println("Hiiiii********************************************");
//		
//		// see if the app specifies urls to use
//		if (app != null) {
//			try {
//				visitsPageWithSpecificVisitUrl = app.getConfig().get("visitUrl").getTextValue();
//			} catch (Exception ex) {
//			}
//			try {
//				visitsPageUrl = app.getConfig().get("visitsUrl").getTextValue();
//			} catch (Exception ex) {
//			}
//		}
//
//		if (visitsPageWithSpecificVisitUrl == null) {
//			visitsPageWithSpecificVisitUrl = coreAppsProperties.getVisitsPageWithSpecificVisitUrl();
//		}
//		visitsPageWithSpecificVisitUrl = "/" + ui.contextPath() + "/" + visitsPageWithSpecificVisitUrl;
//
//		if (visitsPageUrl == null) {
//			visitsPageUrl = coreAppsProperties.getVisitsPageUrl();
//		}
//
//		// hack fix for RA-1002--if there is an active visit, and we are using
//		// the "regular" visit dashboard we actually want to link to the
//		// specific visit
//		Location visitLocation = adtService.getLocationThatSupportsVisits(sessionContext.getSessionLocation());
//		VisitDomainWrapper activeVisit = adtService.getActiveVisit(patientWrapper.getPatient(), visitLocation);
//		if (visitsPageUrl.contains("/coreapps/patientdashboard/patientDashboard.page?") && activeVisit != null) {
//			visitsPageUrl = coreAppsProperties.getVisitsPageWithSpecificVisitUrl();
//			contextModel.put("visit", activeVisit.getVisit());
//		}
//
//		visitsPageUrl = "/" + ui.contextPath() + "/" + visitsPageUrl;
//		model.addAttribute("visitsUrl", "/intelehealth/overview/patientSummary.page?patientId=" + patientWrapper.getPatient().getUuid());
//
//		List<VisitDomainWrapper> recentVisits = patientWrapper.getAllVisitsUsingWrappers();
//		if (recentVisits.size() > 5) {
//			recentVisits = recentVisits.subList(0, 5);
//		}
//
//		Map<VisitDomainWrapper, String> recentVisitsWithLinks = new LinkedHashMap<VisitDomainWrapper, String>();
//		for (VisitDomainWrapper recentVisit : recentVisits) {
//			contextModel.put("visit", new VisitContextModel(recentVisit));
//			// since the "recentVisit" isn't part of the context module, we bind
//			// it first to the visit url, before doing the handlebars binding
//			// against the context
//			recentVisitsWithLinks.put(recentVisit, templateFactory
//					.handlebars(ui.urlBind(visitsPageWithSpecificVisitUrl, recentVisit.getVisit()), contextModel));
//		}
//
//		Map<Integer, Map<String, Object>> recentVisitsWithAttr = visitTypeHelper
//				.getVisitColorAndShortName(recentVisits);
//		model.addAttribute("recentVisitsWithAttr", recentVisitsWithAttr);
//		model.addAttribute("recentVisitsWithLinks", recentVisitsWithLinks);
//
//		config.addAttribute("showVisitTypeOnPatientHeaderSection",
//				visitTypeHelper.showVisitTypeOnPatientHeaderSection());
	}

}
