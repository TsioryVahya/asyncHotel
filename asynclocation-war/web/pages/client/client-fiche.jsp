<%-- 
    Document   : client-fiche
    Created on : 22 mars 2024, 14:50:51
    Author     : SAFIDY
--%>

<%@page import="client.Client"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="fichier.AttacherFichier" %>
<%@ page import="uploadbean.UploadService" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    
%>
<%
    String ismodal = request.getParameter("ismodal");
    Client  client = new Client();
    client.setNomTable("CLIENT");

    PageConsulte pc = new PageConsulte(client, request, u);
    pc.setTitre("Fiche Client");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("nom").setLibelle("Nom");
    pc.getChampByName("telephone").setLibelle("T&eacute;l&eacute;phone");
    pc.getChampByName("mail").setLibelle("Adresse e-mail");
    pc.getChampByName("adresse").setLibelle("Adresse");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("datecin").setLibelle("Date CIN");
    pc.getChampByName("datepermis").setLibelle("Date Permis");
    pc.getChampByName("cinpath").setVisible(false);
    pc.getChampByName("permispath").setVisible(false);
    pc.getChampByName("photoproflepath").setVisible(false);

    String lien = (String) session.getValue("lien");
    String pageModif = "client/client-modif.jsp";
    String classe = "client.Client";

    String projectName = pc.getChampByName("nom").getValeur()
            .replace("'","_")
            .replace("/","_")
            .replace("-","_")
            .replace(":", "_")
            .replace("*", "_")
            .replace(" ", "_");
    String dossierTemp = "client/files/"+projectName;
    String dossier = dossierTemp;

    String pageActuel = "client/client-fiche.jsp";

    AttacherFichier[] fichiers = UploadService.getUploadFile(request.getParameter("id"));
    configuration.CynthiaConf.load();
    String cdn = configuration.CynthiaConf.properties.getProperty("cdnReadUri");

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/reservation-liste-client", "");
    map.put("inc/facture-liste-client", "");
    map.put("inc/historique-location", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/reservation-liste-client";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
%>

<div class="content-wrapper">
    <h1 class="box-title">
        <a href=<%= lien + "?but=client/client-liste.jsp"%>> <i class="fa fa-angle-left"></i></a>
        <%=pc.getTitre()%></h1>
    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <a  class="btn btn-primary pull-right" href="<%= lien  + "?but=reservation/reservation-saisie.jsp&idclient=" + id%>">Saisir reservation</a>
                            <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=client/client-liste.jsp&classe="+classe %>">Supprimer</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj="+ pc.getChampByName("nom").getValeur() %>" style="margin-right: 10px;">Attacher Fichier</a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <%
                        if (ismodal != null && ismodal.equalsIgnoreCase("true"))
                        {
                    %>
                    <li class="<%=map.get("inc/reservation-liste-client")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=client/client-fiche.jsp&id=<%= id %>&tab=inc/reservation-liste-client&ismodal=true','modalContent')">Reservation(s)</a></li>
                    <li class="<%=map.get("inc/facture-liste-client")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=client/client-fiche.jsp&id=<%= id %>&tab=inc/facture-liste-client&ismodal=true','modalContent')">Facture(s)</a></li>
                    <li class="<%=map.get("inc/historique-location")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=client/client-fiche.jsp&id=<%= id %>&tab=inc/historique-location&ismodal=true','modalContent')">Historique(s)</a></li>
                    <%
                        }else{
                    %>
                    <li class="<%=map.get("inc/reservation-liste-client")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=inc/reservation-liste-client">Reservation(s)</a></li>
                    <li class="<%=map.get("inc/facture-liste-client")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=inc/facture-liste-client">Facture(s)</a></li>
                    <li class="<%=map.get("inc/historique-location")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=inc/historique-location">Historique(s)</a></li>
                    <% } %>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab%>" >
                        <jsp:param name="idmere" value="<%= id%>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
    <div class="row">
        <%--        <div class="col-md-1"></div>--%>
        <div class="col-md-12 bottom-vente-fiche">
            <div class="box">
                <h2 class="box-title" style="margin-left: 10px;">Les fichiers attach&eacute;s</h2>
                <div class="box-body" style="padding: 0 20px 20px 20px;">
                    <table class="table table-striped table-bordered table-condensed tree" style="color: #4e4e4e;">
                        <thead>
                        <tr>
                            <th class="contenuetable"></th>
                            <th class="contenuetable">Libell&eacute;</th>
                            <th class="contenuetable">Fichier</th>
                            <th class="contenuetable">Date d`upload</th>
                            <th class="contenuetable">Telecharger</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%if (fichiers == null || fichiers.length == 0) { %>
                        <tr>
                            <td colspan="3" style="text-align: center;"><strong>Aucun fichier</strong></td>
                        </tr>
                        <%} else {
                            for (AttacherFichier fichier : fichiers) {%>
                        <tr class="treegrid-1 treegrid-expanded">
                            <td><span class="treegrid-expander glyphicon glyphicon-minus"></span></td>
                            <td><%=fichier.getChemin()%></td>
                            <td><%=Utilitaire.champNull(fichier.getLibelle())%></td>
                            <td><%=fichier.getDaty()%></td>
                            <td>
                                <!--                                    <form action="../UploadDownloadFileServlet" method="get">
                                            <input type="submit" value="download">
                                            <input type="hidden" name="fileName" value="<%=cdn + dossier + "/" + fichier.getChemin()%>">
                                        </form>-->
                                <a href="../FileManager2?parent=<%= "/"+dossier + "/" +fichier.getChemin()  %>" class="btn btn-success" >Telecharger</a>
                            </td>
                        </tr>
                        <%}
                        }%>

                        </tbody>

                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

