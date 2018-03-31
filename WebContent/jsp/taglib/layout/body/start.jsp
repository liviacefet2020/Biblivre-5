<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Set"%>
<%@ page import="biblivre.core.translations.Languages"%>
<%@ page import="biblivre.core.translations.TranslationsMap"%>
<%@ page import="biblivre.core.translations.LanguageDTO"%>
<%@ page import="biblivre.view.LayoutUtils"%>
<%@ page import="biblivre.core.auth.AuthorizationPoints"%>
<%@ page import="biblivre.core.translations.LanguageDTO"%>
<%@ page import="biblivre.core.translations.LanguageDTO"%>
<%@ page import="biblivre.core.translations.LanguageDTO"%>
<%@ page import="biblivre.core.configurations.Configurations"%>
<%@ page import="biblivre.core.utils.Constants"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>

<jsp:useBean id="schema" type="java.lang.String" scope="request" />
<jsp:useBean id="translationsMap" type="biblivre.core.translations.TranslationsMap" scope="request" />
<jsp:useBean id="isMultiPart" type="java.lang.Boolean" scope="request" />
<jsp:useBean id="isDisableMenu" type="java.lang.Boolean" scope="request" />
<jsp:useBean id="isBanner" type="java.lang.Boolean" scope="request" />
<jsp:useBean id="isSchemaSelection" type="java.lang.Boolean" scope="request" />
<jsp:useBean id="isEmployee" type="java.lang.Boolean" scope="request" />
<jsp:useBean id="isLogged" type="java.lang.Boolean" scope="request" />

<%
	Set<LanguageDTO> languages = Languages.getLanguages(schema);
	LayoutUtils utils = new LayoutUtils(translationsMap);

	AuthorizationPoints atps = (AuthorizationPoints) session.getAttribute(schema + ".logged_user_atps");
	if (atps == null) {
		atps = AuthorizationPoints.getNotLoggedInstance(schema);
	}

	try {
		out.println("<body>");

		if (isMultiPart) {
			out.println(
					"<form id=\"page_submit\" name=\"page_submit\" method=\"post\" enctype=\"multipart/form-data\" accept-charset=\"UTF-8\">");
			out.println("  <input type=\"hidden\" name=\"controller\" id=\"controller\" value=\"json\">");
		} else {
			out.println(
					"<form id=\"page_submit\" name=\"page_submit\" method=\"post\" onsubmit=\"return false;\">");
			out.println("  <input type=\"hidden\" name=\"controller\" id=\"controller\" value=\"jsp\">");
		}

		out.println("  <input type=\"hidden\" name=\"module\" id=\"module\" value=\"login\">");
		if (isLogged) {
			out.println("  <input type=\"hidden\" name=\"action\" id=\"action\" value=\"logout\">");
		} else {
			out.println("  <input type=\"hidden\" name=\"action\" id=\"action\" value=\"login\">");
		}

		out.println("  <div id=\"header\">");

		out.println("    <div id=\"logo_biblivre\">");
		out.println("      <a href=\"http://biblivre.org.br/\" target=\"_blank\">");
		out.println(
				"        <img src=\"static/images/logo_biblivre.png\" width=\"117\" height=\"66\" alt=\"Biblivre V\">");
		out.println("      </a>");
		out.println("    </div>");

		out.println("    <div id=\"logo_support\">");

		out.println("      <div>");
		out.println(
				"        <img src=\"static/images/logo_pedro_i.png\" width=\"88\" height=\"66\" alt=\"Organização Pedro I\">");
		out.println("      </div>");

		out.println("      <div>");
		out.println(
				"        <img src=\"static/images/logo_sabin.png\" width=\"88\" height=\"66\" alt=\"SABIN\">");
		out.println("      </div>");

		out.println("      <div>");
		out.println("        <a href=\"http://www.bn.br/\" target=\"_blank\">");
		out.println(
				"          <img src=\"static/images/logo_biblioteca_nacional.png\" width=\"88\" height=\"66\" alt=\"Biblioteca Nacional\">");
		out.println("        </a>");
		out.println("      </div>");

		out.println("      <div>");
		out.println("        <a href=\"http://www.cultura.gov.br/\" target=\"_blank\">");
		out.println(
				"          <img src=\"static/images/logo_lei_de_incentivo.png\" width=\"88\" height=\"66\" alt=\""
						+ translationsMap.getHtml("header.law") + "\">");
		out.println("        </a>");
		out.println("      </div>");

		out.println("    </div>");

		out.println("    <div id=\"logo_sponsor\">");
		out.println("      <a href=\"http://www.itaucultural.org.br/\" target=\"_blank\">");
		out.println(
				"        <img src=\"static/images/logo_itau.png\" width=\"77\" height=\"66\" alt=\"Itaú Cultural\">");
		out.println("      </a>");
		out.println("      <div id=\"clock\">00:00</div>");
		out.println("    </div>");

		out.println("    <div id=\"title\">");

		out.println("      <div id=\"logo_biblivre_small\">");
		out.println("        <a href=\"http://biblivre.org.br/\" target=\"_blank\">");
		out.println(
				"          <img src=\"static/images/logo_biblivre_small.png\" width=\"43\" height=\"36\" alt=\"Biblivre V\">");
		out.println("        </a>");
		out.println("      </div>");

		out.println("      <h1><a href=\"?\">" + Configurations.getHtml(schema, "general.title") + "</a></h1>");
		out.println("      <h2>" + Configurations.getHtml(schema, "general.subtitle") + "</h2>");

		out.println("    </div>");

		if (languages.size() > 1) {
			out.println("    <div id=\"language_selection\">");
			out.println(
					"      <select class=\"combo combo_auto_size\" name=\"i18n\" onchange=\"Core.submitForm('menu', 'i18n', 'jsp');\">");

			for (LanguageDTO dto : languages) {
				boolean selectedLanguage = translationsMap.getLanguage().equals(dto.getLanguage());

				out.println(String.format("<option value=\"%s\" %s>%s</option>", dto.getLanguage(),
						(selectedLanguage) ? "selected=\"selected\"" : "", dto.toString()));
			}

			out.println("      </select>");
			out.println("    </div>");
		}

		out.println("    <div id=\"menu\">");
		out.println("      <ul>");

		if (isDisableMenu) {
			out.println(utils.menuHelp(atps));
		} else if (isSchemaSelection) {
			if (isLogged) {
				// LOGGED IN MULTI SCHEMA MENU
				out.println(utils.menuLevel(atps, "multi_schema", "administration_password",
						"multi_schema_manage", "multi_schema_configurations", "multi_schema_translations",
						"multi_schema_backup"));
				out.println(utils.menuHelp(atps));
				out.println(utils.menuLogout());
			} else {
				// LOGGED OFF MULTI SCHEMA MENU
				out.println(utils.menuHelp(atps));
				out.println(utils.menuLogin());
			}
		} else {
			if (isEmployee) {
				// LOGGED EMPLOYEE MENU
				out.println(utils.menuLevel(atps, "search", "search_bibliographic", "search_authorities",
						"search_vocabulary", "search_z3950"));

				out.println(utils.menuLevel(atps, "circulation", "circulation_user", "circulation_lending",
						"circulation_reservation", "circulation_access", "circulation_user_cards"));

				out.println(utils.menuLevel(atps, "cataloging", "cataloging_bibliographic",
						"cataloging_authorities", "cataloging_vocabulary", "cataloging_import",
						"cataloging_labels"));

				out.println(utils.menuLevel(atps, "acquisition", "acquisition_supplier", "acquisition_request",
						"acquisition_quotation", "acquisition_order"));

				out.println(utils.menuLevel(atps, "administration", "administration_password",
						"administration_permissions", "administration_user_types",
						"administration_access_cards", "administration_z3950_servers", "administration_reports",
						"administration_maintenance", "administration_configurations",
						"administration_translations", "administration_brief_customization",
						"administration_form_customization"));

				out.println(utils.menuHelp(atps));
				out.println(utils.menuLogout());

			} else if (isLogged) {
				// Logged reader menu
				out.println(utils.menuLevel(atps, "search", "search_bibliographic", "search_authorities",
						"search_vocabulary", "search_z3950"));

				out.println(utils.menuLevel(atps, "self_circulation", "circulation_user_reservation"));

				out.println(utils.menuLevel(atps, "administration", "administration_password"));

				out.println(utils.menuHelp(atps));
				out.println(utils.menuLogout());
			} else {
				// LOGGED OFF MENU
				out.println(utils.menuLevel(atps, "search", "search_bibliographic", "search_authorities",
						"search_vocabulary", "search_z3950"));

				out.println(utils.menuHelp(atps));
				out.println(utils.menuLogin());
			}
		}

		out.println("      </ul>");
		out.println("      <div id=\"slider_area\">");
		out.println("        <div id=\"slider\"></div>");
		out.println("      </div>");
		out.println("    </div>");
		out.println("  </div>");

		out.println("  <div id=\"notifications\">");
		out.println("    <div id=\"messages\">");

		if (isLogged && !isDisableMenu) {
			Boolean passwordWarning = (Boolean) session.getAttribute(schema + ".system_warning_password");
			Boolean backupWarning = (Boolean) session.getAttribute(schema + ".system_warning_backup");
			Boolean indexingWarning = (Boolean) session.getAttribute(schema + ".system_warning_reindex");
			String updateWarning = (String) session.getAttribute(schema + ".system_warning_new_version");

			if (passwordWarning != null && passwordWarning) {
				out.print("<div class=\"message sticky error system_warning_password\"><div>");
				out.print(translationsMap.getHtml("warning.change_password"));

				out.print(" <a href=\"?action=administration_password\" class=\"fright\">");
				out.print(translationsMap.getHtml("warning.fix_now"));
				out.print("</a>");

				out.print("</div></div>");
			}

			if (backupWarning != null && backupWarning) {
				out.print("<div class=\"message sticky error system_warning_backup\"><div>");
				out.print(translationsMap.getHtml("warning.create_backup"));

				out.print(" <a href=\"?action=administration_maintenance\" class=\"fright\">");
				out.print(translationsMap.getHtml("warning.fix_now"));
				out.print("</a>");

				out.print("</div></div>");
			}

			if (indexingWarning != null && indexingWarning) {
				out.print("<div class=\"message sticky error system_warning_reindex\"><div>");
				out.print(translationsMap.getHtml("warning.reindex_database"));

				out.print(" <a href=\"?action=administration_maintenance\" class=\"fright\">");
				out.print(translationsMap.getHtml("warning.fix_now"));
				out.print("</a>");

				out.print("</div></div>");
			}

			if (StringUtils.isNotBlank(updateWarning)) {
				out.print("<div class=\"message sticky error system_warning_new_version\"><div>");

				out.print("<div class=\"fright\">");
				out.print(
						" <a href=\"javascript:void(0)\" onclick=\"Core.ignoreUpdate(this);\" class=\"close\" target=\"_blank\">&times;</a>");
				out.print("<br>");
				out.print(" <a href=\"" + Constants.DOWNLOAD_URL + "\" target=\"_blank\">");
				out.print(translationsMap.getHtml("warning.download_site"));
				out.print("</a>");
				out.print("</div>");

				String message = translationsMap.getText("warning.new_version");
				message = message.replace("{0}", Constants.BIBLIVRE_VERSION);
				message = message.replace("{1}", updateWarning);

				out.print(message);

				out.print("</div></div>");
			}
		}

		out.println("    </div>");
		out.println(
				"    <div id=\"breadcrumb\"><div id=\"page_help_icon\"><a onclick=\"PageHelp.show();\" title=\""
						+ translationsMap.getHtml("common.help") + "\">?</a></div></div>");
		out.println("  </div>");

		out.println("  <div id=\"content_outer\">");

		if (isBanner) {
			out.println("  <div class=\"banner\"></div>");
		}

		out.println("    <div id=\"content\">");

		out.println("      <div class=\"px\"></div>");
		out.println("      <div id=\"content_inner\">");

		// No Script
		out.println("<noscript>");
		out.println(translationsMap.getHtml("text.main.noscript"));
		out.println("  <ul>");
		out.println(String.format("<li><a href=\"?action=list_bibliographic\">Bibliográfica</a></li>"));
		// TODO: SEO
		//out.println(String.format("<li><a href=\"?action=list_authorities\">Autoridades</a></li>"));
		//out.println(String.format("<li><a href=\"?action=list_vocabulary\">Vocabulário</a></li>"));
		out.println("  </ul>");
		out.println("</noscript>");
	} catch (Exception e) {
		e.printStackTrace();
	}
%>