<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 10:45
  To change this template use File | Settings | File Templates.
--%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="reservation.ReservationLib" %>
<%@ page import="utilisateurstation.UtilisateurStation" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>

<% try{
    ReservationLib bc = new ReservationLib();
    String listeCrt[] = {"id", "idclientlib","daty","etat", "montant"};
    String listeInt[] = {"daty", "montant"};
    String libEntete[] = {"id", "idclientlib","daty","montant","revient", "marge","remarque","etatlib",};
    String libEnteteAffiche[] = {"id","Nom du client","Date de r&eacute;servation","Montant","Prix de revient", "Marge","remarque","&Eacute;tat"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des R&eacute;servations ");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("reservation/reservation-liste.jsp");
    String[] colSomme = { "montant" };
    Champ[] liste = new Champ[1];
    Liste listeEtat = new Liste("etat");
    String[] aff = {"TOUTES","CR&Eacute;&Eacute;S", "VIS&Eacute;ES", "ANNUL&Eacute;ES"};
    String[] val = {"%", "1", "11", "0"};
    listeEtat.ajouterValeur(val, aff);
    liste[0] = listeEtat;
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    pr.getFormu().getChamp("etat").setLibelle("&Eacute;tat");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty1").setDefaut(UtilisateurStation.getDateDebutSemaine());
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(UtilisateurStation.getDateFinSemaine());
    pr.getFormu().getChamp("montant1").setLibelle("Montant Min");
    pr.getFormu().getChamp("montant2").setLibelle("Montant Max");
    pr.creerObjetPage(libEntete, colSomme);
    String[] libEnteteRecap = {"","Nombre","Somme des montants"};
    pr.getTableauRecap().setLibeEntete(libEnteteRecap);
    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=reservation/reservation-modif.jsp");
    lienTab.put("Valider",pr.getLien() + "?classe=reservation.Reservation&but=apresTarif.jsp&bute=reservation/reservation-fiche.jsp&acte=valider"+pr.getFormu().getChamp("id").getValeur()+"");
    lienTab.put("Voir fiche",pr.getLien() + "?but=reservation/reservation-fiche.jsp");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=reservation/reservation-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("reservation/inc/reservation-details.jsp&id=");
    //pr.getTableau().setModalOnClick(true);
%>
<script>
    function changerDesignation() {
        document.vente.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="reservation" id="reservation">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>