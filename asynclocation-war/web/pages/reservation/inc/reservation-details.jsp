<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 15:13
  To change this template use File | Settings | File Templates.
--%>
<%@page import="vente.VenteDetailsLib"%>
<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<%@ page import="reservation.ReservationDetailsLib" %>


<%
  try{
    ReservationDetailsLib t = new ReservationDetailsLib();
    t.setNomTable("RESERVATIONDETAILS_LIB_MARGE");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "idVoitureLib", "libelleproduit", "qte","pu","daty","heure","remarque","distanceestimation", "distancereelle","montant", "revient", "marge", "htmlAction"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = null;
    if(request.getParameter("id") != null){
      pr.setAWhere(" and idmere='"+request.getParameter("id")+"'");
    }
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
  <%
    String libEnteteAffiche[] =  {"ID", "Voiture", "Produit", "Quantit&eacute;","Prix unitaire","Date de R&eacute;servation","Heure","Remarque","Estimation Distance", "Distance R&eacute;elle","Montant", "Revient", "Marge", "Action"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    if(pr.getTableau().getHtml() != null){
      out.println(pr.getTableau().getHtml());
    }if(pr.getTableau().getHtml() == null)
  {
  %><center><h4>Aucune donne trouvee</h4></center><%
  }


%>
</div>
<%
  } catch (Exception e) {
    e.printStackTrace();
  }%>
