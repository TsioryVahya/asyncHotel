<%--
  Created by IntelliJ IDEA.
  User: maroussia
  Date: 2025-05-21
  Time: 15:49
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="produits.Voiture" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.*" %>

<%
    try{
    //Information sur les navigations via la page
    String lien = (String) session.getValue("lien");
    String pageModif = "produits/voiture-modif.jsp";
    String classe = "produits.Voiture";
    String pageListe = "produits/voiture-liste.jsp";
    String pageActuel = "produits/voiture-fiche.jsp";

    //Information sur la fiche
    Voiture t = new Voiture();
    t.setNomTable("VoitureLibelleMontant");
    PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
    t = (Voiture) pc.getBase();
    String id=request.getParameter("id");
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("nom").setLibelle("Nom");
    pc.getChampByName("charge_per_kilometre").setLibelle("Charges par kilom&egrave;tre");
    pc.getChampByName("valeur_actuelle").setLibelle("Valeur Actuelle");
    pc.getChampByName("kilometrage_actuel").setLibelle("Kilometrage acquisition");
    pc.getChampByName("estEnPanne").setLibelle("Est en panne");
    pc.getChampByName("categorie").setVisible(false);
        pc.getChampByName("categorieLibelle").setLibelle("Categorie");
    pc.getChampByName("estEnPanne").setValeurDirect(t.getEstFonctionnel());
    pc.getChampByName("montantResa").setLibelle("Montant Reservation Valide");
    pc.getChampByName("etatGenerale").setLibelle("Etat generale / 10");

    pc.setTitre("Fiche Voiture");

    // Vérifier si la voiture est marquée comme 'Non charge'
    boolean isNonCharge = false;
    if (id != null && id.trim().length() > 0) {
        Connection cFlag = null;
        try {
            cFlag = new UtilDB().GetConn();
            String sqlFlag = "SELECT 1 FROM NONCHARGEAUTOMOBILE WHERE IDVOITURE = ?";
            PreparedStatement psFlag = cFlag.prepareStatement(sqlFlag);
            psFlag.setString(1, id);
            ResultSet rsFlag = psFlag.executeQuery();
            if (rsFlag.next()) {
                isNonCharge = true;
            }
            rsFlag.close();
            psFlag.close();
        } catch (Exception ignore) {
        } finally {
            if (cFlag != null) try { cFlag.close(); } catch (Exception e2) {}
        }
    }

    // Calcul du total des montants d'entretien pour cette voiture (FINPANNE.MONTANT)
    BigDecimal totalEntretien = BigDecimal.ZERO;
    if (id != null && id.trim().length() > 0) {
        Connection cTotal = null;
        try {
            cTotal = new UtilDB().GetConn();
            String sqlTotal =
                "SELECT NVL(SUM(f.MONTANT), 0) " +
                "FROM FINPANNE f " +
                "JOIN PANNE p ON p.ID = f.IDPANNE " +
                "WHERE p.IDVOITURE = ?";
            PreparedStatement psTotal = cTotal.prepareStatement(sqlTotal);
            psTotal.setString(1, id);
            ResultSet rsTotal = psTotal.executeQuery();
            if (rsTotal.next()) {
                totalEntretien = rsTotal.getBigDecimal(1);
                if (totalEntretien == null) {
                    totalEntretien = BigDecimal.ZERO;
                }
            }
            rsTotal.close();
            psTotal.close();
        } catch (Exception ignore) {
            // en cas d'erreur, laisser totalEntretien à 0
        } finally {
            if (cTotal != null) try { cTotal.close(); } catch (Exception e2) {}
        }
    }

    // Si la voiture est 'Non charge', forcer les montants à 0
    if (isNonCharge) {
        try {
            if (pc.getChampByName("montantResa") != null) pc.getChampByName("montantResa").setValeurDirect("0");
            if (pc.getChampByName("charge") != null) pc.getChampByName("charge").setValeurDirect("0");
            if (pc.getChampByName("marge") != null) pc.getChampByName("marge").setValeurDirect("0");
            if (pc.getChampByName("valeur_actuelle") != null) pc.getChampByName("valeur_actuelle").setValeurDirect("0");
            if (pc.getChampByName("consommation") != null) pc.getChampByName("consommation").setValeurDirect("0");
        } catch (Exception ignore) {}
        totalEntretien = BigDecimal.ZERO;
    }

    //Initialisation de l'objet onglet
    Map<String, String> map = new HashMap<String, String>();
    map.put("tarif-voiture", "");
    map.put("reservation-visee", "");
    map.put("historique-resa", "");
    map.put("charge-liee", "");
    String tab = "tarif-voiture";
    if(request.getParameter("tab")!=null){
        tab = request.getParameter("tab");
    }
    map.put(tab, "active");
    tab = "inc/" + tab + ".jsp";


%>
<div class="content-wrapper">
    <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=consulte/page-fiche-simple.jsp"><i class="fa fa-amgle-left"></i></a><%=pc.getTitre()%></h1>

    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <table class="table table-bordered">
                            <tr>
                                <th>Montant entretien</th>
                                <td><%= totalEntretien != null ? totalEntretien : BigDecimal.ZERO %></td>
                            </tr>
                        </table>
                        <div class="box-footer">
                            <a class="btn btn-primary pull-right"  href="<%= lien + "?but=location/voiture/saisie-charge-voiture.jsp"+"&id=" + id%>" style="margin-right: 10px">Saisie Charge</a>
                            <a class="btn btn-danger pull-right" href="<%= lien + "?but=panne/noncharge-save.jsp&idVoiture=" + id %>" style="margin-right: 10px">Non charge</a>
                            <a class="btn btn-success pull-right" href="<%= lien + "?but=panne/finpanne-saisie.jsp&idVoiture=" + id %>" style="margin-right: 10px">Finir panne</a>
                            <a class="btn btn-warning pull-right" href="<%= lien + "?but=panne/panne-saisie.jsp&idVoiture=" + id %>" style="margin-right: 10px">Panne</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=produits/as-ingredients-saisie.jsp"+"&id=" + id%>" style="margin-right: 10px">Saisir Tarif</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=#&classe="+classe %>">Supprimer</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs" style="margin-top: 20px;">
                    <!-- a modifier -->
                    <li class="<%=map.get("tarif-voiture")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=tarif-voiture">Tarif(s)</a></li>
                    <li class="<%=map.get("reservation-visee")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=reservation-visee">R&eacute;servation en cours</a></li>
                    <li class="<%=map.get("historique-resa")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=historique-resa">Historique R&eacute;servation </a></li>
                    <li class="<%=map.get("charge-liee")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=charge-liee">Charges li&eacute;&eacute;s </a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab%>" >
                        <jsp:param name="id" value="<%= id%>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>

</div>


<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

