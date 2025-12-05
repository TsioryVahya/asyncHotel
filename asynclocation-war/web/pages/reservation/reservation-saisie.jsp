<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 10:44
  To change this template use File | Settings | File Templates.
--%>
<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="reservation.Reservation" %>
<%@ page import="reservation.ReservationDetails" %>
<%@ page import="client.Client" %>
<%@ page import="utils.ConstanteAsync" %>
<%
  try {
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    Reservation mere = new Reservation();
    ReservationDetails fille = new ReservationDetails();
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("remarque").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    Client client = null;
    if(request.getParameter("idclient")!=null){
      pi.getFormu().getChamp("idclient").setDefaut(request.getParameter("idclient"));
      client = (Client)new Client().getById(request.getParameter("idclient"),null,null);
    }
    String daty = request.getParameter("daty");
    String idproduit = request.getParameter("idproduit");
    String tranche = request.getParameter("tranche");

    pi.getFormu().getChamp("idclient").setLibelle("Client");
    pi.getFormu().getChamp("idclient").setPageAppelCompleteInsert("client.Client","id","Client", "client/client-saisie.jsp","id;nom");

    pi.getFormufle().getChamp("idproduit_0").setLibelle("Services");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","id","AS_INGREDIENTS_LIB","pv;idVoiture","pu;idVoiture");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    pi.getFormufle().getChamp("idVoiture_0").setLibelle("Voiture");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
    pi.getFormufle().getChamp("daty_0").setLibelle("Date de d&eacute;but");
    pi.getFormufle().getChamp("heure_0").setLibelle("Heure de d&eacute;but");
    pi.getFormufle().getChamp("distanceestimation_0").setLibelle("Estimation Distance");
    for (int i = 0; i < nombreLigne; i++)
    {
      pi.getFormufle().getChamp("qte_"+i).setDefaut("0");
      pi.getFormufle().getChamp("idVoiture_"+i).setAutre("readOnly");
      pi.getFormufle().getChamp("daty_"+i).setDefaut(Utilitaire.dateDuJour());
      pi.getFormufle().getChamp("heure_"+i).setDefaut(Utilitaire.heureCouranteHM());
        if (daty != null && !daty.equalsIgnoreCase(""))
        {
          pi.getFormufle().getChamp("daty_"+i).setDefaut(daty);
        }
        if (idproduit != null && !idproduit.equalsIgnoreCase(""))
        {
          pi.getFormufle().getChamp("idVoiture_"+i).setDefaut(idproduit);
        }
        if(tranche!=null && !tranche.equalsIgnoreCase("")){
          pi.getFormufle().getChamp("heure_"+i).setDefaut(ConstanteAsync.getHeureTranche(tranche));
        }
    }
    if(idproduit != null && !idproduit.equalsIgnoreCase("")){
      String aWhere = "  and idVoiture = '"+idproduit+"'";
      affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","id","AS_INGREDIENTS_LIB","pv;idVoiture","pu;idVoiture",aWhere);
    }
    pi.preparerDataFormu();
    String[] ordreFormu={"daty"};
    pi.getFormu().setOrdre(ordreFormu);
    String[] order = {"idproduit", "idvoiture","qte","pu", "distanceestimation", "remarque", "daty","heure"};
    pi.getFormufle().setColOrdre(order);

    //Variables de navigation
    String classeMere = "reservation.Reservation";
    String classeFille = "reservation.ReservationDetails";
    String butApresPost = "reservation/reservation-fiche.jsp";
    String colonneMere = "idmere";
    //Preparer les affichages
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
    String titre="Enregistrement d'une R&eacute;servation";
    String acte = request.getParameter("acte");
    if(acte!=null&&acte.compareToIgnoreCase("update")==0){
      titre="Modification de la r&eacute;servation";
    }

%>
<div class="content-wrapper">
  <h1><%=titre%></h1>
  <div class="box-body">
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
      <%

        out.println(pi.getFormu().getHtmlInsert());
        out.println(pi.getFormufle().getHtmlTableauInsert());
      %>
      <input name="acte" type="hidden" id="nature" value="insert">
      <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
      <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
      <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
      <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
      <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
      <input name="nomtable" type="hidden" id="nomtable" value="RESERVATIONDETAILS">
    </form>
  </div>
</div>
<script>
  <% if(client != null ) { %>
  document.getElementById('idclientlibelle').value = '<%=client.getNom()%>';
  <% } %>
</script>
<%
} catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript">
  alert('<%=e.getMessage()%>');
  history.back();
</script>
<% }%>
