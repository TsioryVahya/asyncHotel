<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="reservation.Reservation" %>
<%@ page import="reservation.ReservationDetailsCheck" %>
<%@ page import="reservation.Check" %>
<%
  try {
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    Reservation mere = new Reservation();
    Check fille = new Check();
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    String butApresPost = "reservation/reservation-fiche.jsp&tab=inc/liste-checkin";

    ReservationDetailsCheck[] res = null;
    String idreservation = request.getParameter("idresa");
    if(idreservation!=null){
        mere.setId(idreservation);
        res = mere.getListeSansCheckIn("RESERVATIONDETSANSCIGROUPLIB",null);
    }

    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("remarque").setVisible(false);
    pi.getFormu().getChamp("daty").setVisible(false);
    pi.getFormu().getChamp("idclient").setVisible(false);
    pi.getFormufle().getChamp("idproduit_0").setLibelle("Services");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","id","AS_INGREDIENTS_LIB","pv","pu");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    pi.getFormufle().getChamp("daty_0").setLibelle("Date check-in");
    pi.getFormufle().getChamp("heure_0").setLibelle("Heure check-in");
    pi.getFormufle().getChamp("idClient_0").setLibelle("Client");
    pi.getFormufle().getChamp("kilometrage_0").setLibelle("Kilom&eacute;trage");
    pi.getFormufle().getChampMulitple("qte").setVisible(false);
    pi.getFormufle().getChamp("reservation_0").setLibelle("ID R&eacute;servation");
    pi.getFormufle().getChamp("reservation_0").setAutre("readOnly");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idClient"),"client.Client","id","Client");

    for(int i = 0; i < nombreLigne; i++){
      pi.getFormufle().getChamp("daty_"+i).setDefaut(utilitaire.Utilitaire.dateDuJour());
      pi.getFormufle().getChamp("heure_"+i).setDefaut(utilitaire.Utilitaire.heureCouranteHM());
    }

    if(idreservation!=null&&res.length>0){
      butApresPost = "reservation/reservation-fiche.jsp&id="+idreservation+"&tab=inc/liste-checkin";
        for (int i = 0; i < res.length; i++){
            pi.getFormufle().getChamp("idproduit_"+i).setDefaut(res[i].getIdproduit());
            pi.getFormufle().getChamp("idClient_"+i).setDefaut(res[i].getIdclient());
            pi.getFormufle().getChamp("reservation_"+i).setDefaut(res[i].getId());
            pi.getFormufle().getChamp("qte_"+i).setDefaut(String.valueOf(res[i].getQte()));
        }
    }
    
    pi.preparerDataFormu();
    String[] order = {"idproduit","kilometrage","remarque", "daty","heure","idClient","qte","reservation"};
    pi.getFormufle().setColOrdre(order);

    //Variables de navigation
    String classeMere = "reservation.Reservation";
    String classeFille = "reservation.Check";
    String colonneMere = "reservation";
    //Preparer les affichages
    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
  <h1>Enregistrement Check-in</h1>
  <div class="box-body">
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
      <%
        out.println(pi.getFormufle().getHtmlTableauInsert());
      %>
      <input name="acte" type="hidden" id="nature" value="insertFilleSeul">
      <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
      <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
      <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
      <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
      <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
      <input name="idMere" type="hidden" id="idMere" value="<%= idreservation %>">
      <input name="nomtable" type="hidden" id="nomtable" value="CHECKIN">
    </form>
  </div>
</div>

<script>
    const valeurs = [
    <% if (res != null) {
      for (int i = 0; i < res.length; i++) { %>
    {
      Produit: "<%= res[i].getProduitlib() %>"
    } <%= (i < res.length - 1) ? "," : "" %>
      <% }
    } %>
    ];
    window.addEventListener('DOMContentLoaded', function() {
      for (let i = 0; i < valeurs.length; i++) {
        const produitInput = document.getElementById('idProduit_' + i +'libelle');
        if (produitInput) produitInput.value = valeurs[i].Produit;
      }
    }
  );

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
